const httpStatus = require('http-status');
const Message = require('../utils/Message');
const catchAsync = require('../utils/catchAsync');
const tripService = require('../services/trip.service');

const createTrip = catchAsync(async (req, res) => {
  const trip = await tripService.createTrip(req.body);
  res.status(httpStatus.CREATED).send({
    code: httpStatus.CREATED,
    message: Message.tripMsg.created,
    result: trip,
  });
});

const getTripByTripId = catchAsync(async (req, res) => {
  const { tripId } = req.params;
  const trip = await tripService.getTripByTripId(tripId);
  res.send({ code: httpStatus.OK, message: Message.ok, result: trip });
});

const updateTrip = catchAsync(async (req, res) => {
  const { tripId } = req.params;
  const requestBody = req.body;
  await tripService.updateTrip({ tripId, requestBody });
  res.send({
    code: httpStatus.OK,
    message: Message.tripMsg.update,
  });
});

const deleteTrip = catchAsync(async (req, res) => {
  const { tripId } = req.params;
  await tripService.deleteTrip(tripId);
  res.send({
    code: httpStatus.OK,
    message: Message.tripMsg.delete,
  });
});

module.exports = {
  createTrip,
  getTripByTripId,
  updateTrip,
  deleteTrip,
};
