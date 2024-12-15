const httpStatus = require('http-status');
// const mongoose = require('mongoose');
// const _ = require('lodash');
const Location = require('../models/location.model');
const HistoryLogService = require('./historyLog.service');
const ApiError = require('../utils/ApiError');
const Message = require('../utils/Message');
// const { getClosestLocation } = require('../controllers/location.controller');
// const UserModel = require('../models/user.model');

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

module.exports = {
  createLocation,
  getLocationByLocationId,
  updateLocation,
  deleteLocation,
  getLocation,
  deleteHardLocation,
};
