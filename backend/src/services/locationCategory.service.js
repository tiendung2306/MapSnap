const httpStatus = require('http-status');
// const mongoose = require('mongoose');
// const _ = require('lodash');
const LocationCategory = require('../models/locationCategory.model');
const ApiError = require('../utils/ApiError');
const Message = require('../utils/Message');
// const UserModel = require('../models/user.model');

const createLocationCategory = async (locationCategoryBody) => {
  const existedLocationCategory = await LocationCategory.findOne(locationCategoryBody);
  if (existedLocationCategory) {
    throw new ApiError(httpStatus.BAD_REQUEST, Message.locationCategoryMsg.nameExisted);
  }
  const locationCategory = await LocationCategory.create(locationCategoryBody);
  return locationCategory;
};

const getLocationCategoryById = async (locationCategoryId) => {
  const locationCategory = await LocationCategory.findById(locationCategoryId);
  if (!locationCategory) {
    throw new ApiError(httpStatus.NOT_FOUND, Message.notFound);
  }
  return locationCategory;
};

const updateLocationCategory = async ({ locationCategoryId, requestBody }) => {
  const locationCategory = await LocationCategory.findByIdAndUpdate(locationCategoryId, requestBody, { new: true });
  return locationCategory;
};

const deleteLocationCategory = async (locationCategoryId) => {
  await updateLocationCategory({ locationCategoryId, requestBody: { status: 'disabled' } });
};

module.exports = {
  createLocationCategory,
  getLocationCategoryById,
  updateLocationCategory,
  deleteLocationCategory,
};
