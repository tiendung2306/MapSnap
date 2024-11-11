const httpStatus = require('http-status');
// const mongoose = require('mongoose');
// const _ = require('lodash');
const Position = require('../models/position.model');
const ApiError = require('../utils/ApiError');
const Message = require('../utils/Message');
// const UserModel = require('../models/user.model');

const createPosition = async (requestBody) => {
  const existedPosition = await Position.findOne(requestBody);
  if (existedPosition) {
    throw new ApiError(httpStatus.BAD_REQUEST, Message.positionMsg.nameExisted);
  }
  const position = await Position.create(requestBody);
  return position;
};

const deletePosition = async (positionId) => {
  const position = await Position.findByIdAndDelete(positionId);
  return position;
};

module.exports = {
  createPosition,
  deletePosition,
};
