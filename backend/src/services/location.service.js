const httpStatus = require('http-status');
// const mongoose = require('mongoose');
// const _ = require('lodash');
const Location = require('../models/location.model');
const ApiError = require('../utils/ApiError');
const Message = require('../utils/Message');
// const UserModel = require('../models/user.model');

const createLocation = async (locationBody) => {
  const existedLocation = await Location.findOne(locationBody);
  if (existedLocation) {
    throw new ApiError(httpStatus.BAD_REQUEST, Message.locationMsg.nameExisted);
  }
  const location = await Location.create(locationBody);
  return location;
};

const getLocationByLocationId = async (locationId) => {
  const location = await Location.findById(locationId);
  if (!location) {
    throw new ApiError(httpStatus.NOT_FOUND, Message.notFound);
  }
  return location;
};

const getLocation = async (locationBody) => {
  const {
    userId,
    cityId,
    locationCategoryId,
    name,
    isAutomaticAdded,
    updatedByUser,
    sortType = 'desc',
    sortField = 'createdAt',
  } = locationBody;
  const filter = { userId };
  if (cityId) filter.cityId = cityId;
  if (locationCategoryId) filter.locationCategoryId = locationCategoryId;
  if (name) filter.name = name;
  if (isAutomaticAdded !== null) filter.isAutomaticAdded = isAutomaticAdded;
  if (updatedByUser !== null) filter.updatedByUser = updatedByUser;
  const sortOption = { [sortField]: sortType === 'asc' ? 1 : -1 };
  const location = await Location.find(filter).sort(sortOption);
  return location;
};

const updateLocation = async ({ locationId, requestBody }) => {
  const location = await Location.findByIdAndUpdate(locationId, requestBody, { new: true });
  return location;
};

const deleteLocation = async (locationId) => {
  await updateLocation({ locationId, requestBody: { status: 'disabled' } });
};

module.exports = {
  createLocation,
  getLocationByLocationId,
  updateLocation,
  deleteLocation,
  getLocation,
};
