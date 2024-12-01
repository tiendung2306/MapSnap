const httpStatus = require('http-status');
// const mongoose = require('mongoose');
// const _ = require('lodash');
const City = require('../models/city.model');
const ApiError = require('../utils/ApiError');
const Message = require('../utils/Message');
// const UserModel = require('../models/user.model');

const createCity = async (cityBody) => {
  const existedCity = await City.findOne(cityBody);
  if (existedCity) {
    throw new ApiError(httpStatus.BAD_REQUEST, Message.cityMsg.nameExisted);
  }
  const city = await City.create(cityBody);
  return city;
};

const getCities = async (cityBody) => {
  const { userId, searchText, status = 'enabled' } = cityBody;
  const filter = { userId, status };
  if (searchText) {
    filter.name = { $regex: searchText, $options: 'i' };
  }
  const city = await City.find(filter);
  return city;
};

const getCityByCityId = async (cityId) => {
  const city = await City.findById(cityId);
  if (!city) {
    throw new ApiError(httpStatus.NOT_FOUND, Message.notFound);
  }
  return city;
};

const updateCity = async ({ cityId, requestBody }) => {
  const city = await City.findByIdAndUpdate(cityId, requestBody, { new: true });
  return city;
};

const deleteCity = async (cityId) => {
  await updateCity({ cityId, requestBody: { status: 'disabled' } });
};

const deleteHardCity = async (cityId) => {
  await City.findByIdAndDelete(cityId);
};

module.exports = {
  createCity,
  getCities,
  getCityByCityId,
  updateCity,
  deleteCity,
  deleteHardCity,
};
