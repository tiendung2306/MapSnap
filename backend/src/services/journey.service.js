const httpStatus = require('http-status');
const mongoose = require('mongoose');
// const _ = require('lodash');
const JourneyModel = require('../models/journey.model');
const ApiError = require('../utils/ApiError');
const Message = require('../utils/Message');
// const UserModel = require('../models/user.model');

const createJourney = async (journeyBody) => {
  const journey = await JourneyModel.findOne(journeyBody);
  if (journey) {
    throw new ApiError(httpStatus.BAD_REQUEST, Message.journeyMsg.nameExisted);
  }
  const journeyModel = await JourneyModel.create(journeyBody);
  return journeyModel;
};

const getJourneysByUserId = async ({ userId }) => {
  const filter = { userId: mongoose.Types.ObjectId(userId), status: { $ne: 'enable' } };
  return JourneyModel.find(filter);
};

const getJourneyByJourneyId = async (journeyId) => {
  const journey = await JourneyModel.findById(journeyId);
  if (!journey) {
    throw new ApiError(httpStatus.NOT_FOUND, Message.notFound);
  }
  return journey;
};

const updateJourney = async ({ journeyId, requestBody }) => {
  const journeyModel = await JourneyModel.findByIdAndUpdate(journeyId, requestBody, { new: true });
  return journeyModel;
};

const deleteJourney = async (journeyId) => {
  await updateJourney({ journeyId, requestBody: { status: 'disabled' } });
};

module.exports = {
  createJourney,
  getJourneysByUserId,
  getJourneyByJourneyId,
  updateJourney,
  deleteJourney,
};
