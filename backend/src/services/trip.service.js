const httpStatus = require('http-status');
// const mongoose = require('mongoose');
// const _ = require('lodash');
const TripModel = require('../models/trip.model');
const ApiError = require('../utils/ApiError');
const Message = require('../utils/Message');
// const UserModel = require('../models/user.model');

const createTrip = async (tripBody) => {
  const trip = await TripModel.findOne(tripBody);
  if (trip) {
    throw new ApiError(httpStatus.BAD_REQUEST, Message.tripMsg.nameExisted);
  }
  const tripModel = await TripModel.create(tripBody);
  return tripModel;
};

const getTripByTripId = async (tripId) => {
  const trip = await TripModel.findById(tripId);
  if (!trip) {
    throw new ApiError(httpStatus.NOT_FOUND, Message.notFound);
  }
  return trip;
};

const updateTrip = async ({ tripId, requestBody }) => {
  const tripModel = await TripModel.findByIdAndUpdate(tripId, requestBody, { new: true });
  return tripModel;
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
