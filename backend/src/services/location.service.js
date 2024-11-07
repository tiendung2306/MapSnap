const httpStatus = require('http-status');
// const mongoose = require('mongoose');
// const _ = require('lodash');
const LocationModel = require('../models/location.model');
const ApiError = require('../utils/ApiError');
const Message = require('../utils/Message');
// const UserModel = require('../models/user.model');

const createLocation = async (locationBody) => {
  const location = await LocationModel.findOne(locationBody);
  if (location) {
    throw new ApiError(httpStatus.BAD_REQUEST, Message.locationMsg.nameExisted);
  }
  const locationModel = await LocationModel.create(locationBody);
  return locationModel;
};

const getLocationByLocationId = async (locationId) => {
  const location = await LocationModel.findById(locationId);
  if (!location) {
    throw new ApiError(httpStatus.NOT_FOUND, Message.notFound);
  }
  return location;
};

const updateLocation = async ({ locationId, requestBody }) => {
  const locationModel = await LocationModel.findByIdAndUpdate(locationId, requestBody, { new: true });
  return locationModel;
};

const deleteLocation = async (locationId) => {
  await updateLocation({ locationId, requestBody: { status: 'disabled' } });
};

module.exports = {
  createLocation,
  getLocationByLocationId,
  updateLocation,
  deleteLocation,
};
