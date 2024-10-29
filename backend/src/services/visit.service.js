const httpStatus = require('http-status');
const mongoose = require('mongoose');
// const _ = require('lodash');
const JourneyModel = require('../models/journey.model');
const VisitModel = require('../models/visit.model');
const ApiError = require('../utils/ApiError');
const Message = require('../utils/Message');
// const UserModel = require('../models/user.model');

const createVisit = async (visitBody) => {
  await updateJourneyByCreateVisit(visitBody);
  const visitModel = await VisitModel.create(visitBody);
  return visitModel;
};

const updateJourneyByCreateVisit = async (visitBody) => {
  const journeyId = _.get(visitBody.journeyId);
  const journey = await JourneyModel.findById(journeyId);
  if (!journey) {
    throw new ApiError(httpStatus.BAD_REQUEST, Message.journeyMsg.notFound);
  }
};

const getVisitByVisitId = async (visitId) => {
  const visit = await VisitModel.findById(visitId);
  if (!visit) {
    throw new ApiError(httpStatus.NOT_FOUND, Message.notFound);
  }
  return visit;
};

const updateVisit = async (visitId, requestBody) => {
  updateJourneyByUpdateVisit(visitId, requestBody);
  const VisitModel = await VisitModel.findByIdAndUpdate(visitId, requestBody, { new: true });
  return visitModel;
};

const updateJourneyByUpdateVisit = async (requestBody) => {
  const journeyId = _.get(requestBody.journeyId);
  const journey = await JourneyModel.findById(journeyId);
  if (!journey) {
    throw new ApiError(httpStatus.BAD_REQUEST, Message.journeyMsg.notFound);
  }
};

const deleteVisit = async (visitId) => {
    const requestBody = VisitModel.findById(visitId);
    updateJourneyByUpdateVisit(requestBody);
  await updateVisit( requestBody: { status: 'disabled' } );
};

module.exports = {
  createVisit,
  getVisitByVisitId,
  updateVisit,
  deleteVisit,
};
