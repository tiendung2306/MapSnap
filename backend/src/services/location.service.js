const httpStatus = require('http-status');
// const mongoose = require('mongoose');
// const _ = require('lodash');
const Location = require('../models/location.model');
const HistoryLogService = require('./historyLog.service');
const ApiError = require('../utils/ApiError');
const Message = require('../utils/Message');
const goongService = require('./goong.service');
const cityService = require('./city.service');

const _createHistoryLog = async ({ locationId, locationBody, activityType }) => {
  const historyLogRequest = {
    activityType,
    modelImpact: 'Location',
    objectIdImpact: locationId,
    userId: locationBody.userId,
    createdAt: Date.now(),
    updatedByUser: locationBody.updatedByUser,
    isAutomaticAdded: locationBody.isAutomaticAdded,
  };
  await HistoryLogService.createHistoryLog(historyLogRequest);
};

const createLocation = async (locationBody) => {
  const existedLocation = await Location.findOne(locationBody);
  if (existedLocation) {
    throw new ApiError(httpStatus.BAD_REQUEST, Message.locationMsg.nameExisted);
  }
  const location = await Location.create(locationBody);
  await _createHistoryLog({ locationId: location._id, locationBody, activityType: 'Create' });
  return location;
};

const getLocationByLocationId = async (locationId) => {
  const location = await Location.findById(locationId);
  if (!location) {
    throw new ApiError(httpStatus.NOT_FOUND, Message.notFound);
  }
  return location;
};

// const getClosestLocation = async (locationBody) => {
//   const { lat, lng } = locationBody
// }

const getLocation = async (locationBody) => {
  const {
    userId,
    cityId,
    categoryId,
    isAutomaticAdded,
    updatedByUser,
    sortType = 'desc',
    sortField = 'createdAt',
    searchText,
    status = 'enabled',
  } = locationBody;
  const filter = { userId, status };
  if (cityId) filter.cityId = cityId;
  if (categoryId) filter.categoryId = categoryId;
  if (isAutomaticAdded !== undefined) filter.isAutomaticAdded = isAutomaticAdded;
  if (updatedByUser !== undefined) filter.updatedByUser = updatedByUser;
  if (searchText) {
    filter.$or = [{ address: { $regex: searchText, $options: 'i' } }];
  }
  const sortOption = { [sortField]: sortType === 'asc' ? 1 : -1 };
  const location = await Location.find(filter).sort(sortOption);
  return location;
};

const updateLocation = async ({ locationId, requestBody }) => {
  const location = await Location.findByIdAndUpdate(locationId, requestBody, { new: true });
  await _createHistoryLog({ locationId, journeyBody: location, activityType: 'Update' });
  return location;
};

const deleteLocation = async (locationId) => {
  await updateLocation({ locationId, requestBody: { status: 'disabled' } });
};

const deleteHardLocation = async (locationId) => {
  const locationBody = await Location.findByIdAndDelete(locationId);
  await _createHistoryLog({ locationId, locationBody, activityType: 'Delete' });
};

const reverseGeocoding = async (req, res) => {
  const { results } = await goongService.reverseGeocoding(req, res);
  // console.log(results);
  const address = results[0].formatted_address;
  const country = 'Việt Nam';
  const { district } = results[0].compound;
  const classify = results[0].types[0];
  const homeNumber =
    results[0].address_components[0].long_name +
    (results[0].address_components[1].long_name !== results[0].compound.commune
      ? `, ${results[0].address_components[1].long_name}`
      : '');
  const { commune } = results[0].compound;
  const { province } = results[0].compound;
  const cities = await cityService.getCities({ userId: req.query.userId, searchText: province });
  let cityId = cities[0] ? cities[0]._id : null;
  if (!cityId) {
    const city = await cityService.createCity({
      userId: req.query.userId,
      createdAt: Date.now(),
      name: province,
      status: 'enabled',
      visitedTime: 1,
      updatedByUser: false,
      isAutomaticAdded: true,
    });
    cityId = city._id;
  }
  const location = {
    address,
    country,
    district,
    classify,
    homeNumber,
    commune,
    province,
    cityId,
  };
  return location;
};

module.exports = {
  createLocation,
  getLocationByLocationId,
  updateLocation,
  deleteLocation,
  getLocation,
  deleteHardLocation,
  reverseGeocoding,
};
