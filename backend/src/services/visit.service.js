const httpStatus = require('http-status');
// const mongoose = require('mongoose');
const _ = require('lodash');
const Visit = require('../models/visit.model');
const Journey = require('../models/journey.model');
const ApiError = require('../utils/ApiError');
const Message = require('../utils/Message');
// const UserModel = require('../models/user.model');

const _addVisitInJourney = async ({ journeyId, visitId }) => {
  const journey = await Journey.findById(journeyId);
  if (!_.includes(journey.visitIds, visitId)) _.push(journey.visitIds, visitId);
  await journey.save();
};

const _deleteVisitInJourney = async ({ journeyId, visitId }) => {
  const journey = await Journey.findById(journeyId);
  if (_.includes(journey.visitIds, visitId)) _.pull(journey.visitIds, visitId);
  await journey.save();
};

const createVisit = async (requestBody) => {
  const existedVisit = await Visit.findOne(requestBody);
  if (existedVisit) {
    throw new ApiError(httpStatus.BAD_REQUEST, Message.visitMsg.nameExisted);
  }
  const visit = await Visit.create(requestBody);
  await _addVisitInJourney(requestBody);
  return visit;
};

const getVisitByVisitId = async (visitId) => {
  const visit = await Visit.findById(visitId);
  if (!visit) {
    throw new ApiError(httpStatus.NOT_FOUND, Message.notFound);
  }
  return visit;
};

const updateVisit = async ({ visitId, requestBody }) => {
  const existedVisit = await Visit.findById(visitId);
  const lastJourneyId = _.get(existedVisit, 'journeyId');
  const nextJourneyId = _.get(requestBody, 'journeyId');
  if (lastJourneyId !== nextJourneyId || requestBody.status === 'disabled') {
    await _addVisitInJourney({ nextJourneyId, visitId });
    await _deleteVisitInJourney({ lastJourneyId, visitId });
  }
  const visit = await Visit.findByIdAndUpdate(visitId, requestBody, { new: true });
  return visit;
};

const deleteVisit = async (visitId) => {
  await updateVisit({ visitId, requestBody: { status: 'disabled' } });
};

module.exports = {
  createVisit,
  getVisitByVisitId,
  updateVisit,
  deleteVisit,
};
