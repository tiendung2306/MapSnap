const httpStatus = require('http-status');
// const mongoose = require('mongoose');
const _ = require('lodash');
const Trip = require('../models/trip.model');
const Journey = require('../models/journey.model');
const ApiError = require('../utils/ApiError');
const Message = require('../utils/Message');
// const UserModel = require('../models/user.model');

const _addTripInJourney = async ({ journeyId, tripId }) => {
  const journey = await Journey.findById(journeyId);
  if (!_.includes(journey.tripIds, tripId)) _.push(journey.tripIds, tripId);
  await journey.save();
};

const _deleteTripInJourney = async ({ journeyId, tripId }) => {
  const journey = await Journey.findById(journeyId);
  if (_.includes(journey.tripIds, tripId)) _.pull(journey.tripIds, tripId);
  await journey.save();
};

const createTrip = async (requestBody) => {
  const existedTrip = await Trip.findOne(requestBody);
  if (existedTrip) {
    throw new ApiError(httpStatus.BAD_REQUEST, Message.tripMsg.nameExisted);
  }
  const trip = await Trip.create(requestBody);
  await _addTripInJourney(requestBody);
  return trip;
};

const getTripByTripId = async (tripId) => {
  const trip = await Trip.findById(tripId);
  if (!trip) {
    throw new ApiError(httpStatus.NOT_FOUND, Message.notFound);
  }
  return trip;
};

const updateTrip = async ({ tripId, requestBody }) => {
  const existedTrip = await Trip.findById(tripId);
  const lastJourneyId = _.get(existedTrip, 'journeyId');
  const nextJourneyId = _.get(requestBody, 'journeyId');
  if (lastJourneyId !== nextJourneyId || requestBody.status === 'disabled') {
    await _addTripInJourney({ nextJourneyId, tripId });
    await _deleteTripInJourney({ lastJourneyId, tripId });
  }
  const trip = await Trip.findByIdAndUpdate(tripId, requestBody, { new: true });
  return trip;
};

const deleteTrip = async (tripId) => {
  await updateTrip({ tripId, requestBody: { status: 'disabled' } });
};

module.exports = {
  createTrip,
  getTripByTripId,
  updateTrip,
  deleteTrip,
};
