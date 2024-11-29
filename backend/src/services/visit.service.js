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
  if (!_.includes(journey.visitIds, visitId)) journey.visitIds.push(visitId);
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
  const journeyId = _.get(requestBody, 'journeyId');
  const visitId = _.get(visit, '_id');
  await _addVisitInJourney({ journeyId, visitId });
  return visit;
};

const getVisit = async (visitBody) => {
  const {
    userId,
    isAutomaticAdded,
    updatedByUser,
    sortType = 'desc',
    sortField = 'createdAt',
    journeyId,
    locationId,
    from,
    to,
    searchText,
  } = visitBody;
  const filter = { userId };
  if (isAutomaticAdded !== undefined) filter.isAutomaticAdded = isAutomaticAdded;
  if (updatedByUser !== undefined) filter.updatedByUser = updatedByUser;
  if (journeyId) filter.journeyId = journeyId;
  if (locationId) filter.locationId = locationId;
  if (searchText) {
    filter.$or = [{ title: { $regex: searchText, $options: 'i' } }, { name: { $regex: searchText, $options: 'i' } }];
  }
  if (from) {
    filter.startedAt = {};
    filter.startedAt.$gte = from;
  }
  if (to) {
    filter.endedAt = {};
    filter.endedAt.$lte = to;
  }
  const sortOption = { [sortField]: sortType === 'asc' ? 1 : -1 };
  const visit = await Visit.find(filter).sort(sortOption);
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
    if (nextJourneyId) await _addVisitInJourney({ journeyId: nextJourneyId, visitId });
    if (lastJourneyId) await _deleteVisitInJourney({ journeyId: lastJourneyId, visitId });
  }
  const visit = await Visit.findByIdAndUpdate(visitId, requestBody, { new: true });
  return visit;
};

const deleteVisit = async (visitId) => {
  await updateVisit({ visitId, requestBody: { status: 'disabled' } });
};

module.exports = {
  createVisit,
  getVisit,
  getVisitByVisitId,
  updateVisit,
  deleteVisit,
};
