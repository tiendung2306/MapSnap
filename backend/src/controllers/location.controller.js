const httpStatus = require('http-status');
const Message = require('../utils/Message');
const catchAsync = require('../utils/catchAsync');
const locationService = require('../services/location.service');

const createLocation = catchAsync(async (req, res) => {
  const location = await locationService.createLocation(req.body);
  res.status(httpStatus.CREATED).send({
    code: httpStatus.CREATED,
    message: Message.locationMsg.created,
    result: location,
  });
});

const getLocationByLocationId = catchAsync(async (req, res) => {
  const { locationId } = req.params;
  const location = await locationService.getLocationByLocationId(locationId);
  res.send({ code: httpStatus.OK, message: Message.ok, result: location });
});

const updateLocation = catchAsync(async (req, res) => {
  const { locationId } = req.params;
  const requestBody = req.body;
  await locationService.updateLocation({ locationId, requestBody });
  res.send({
    code: httpStatus.OK,
    message: Message.locationMsg.update,
  });
});

const deleteLocation = catchAsync(async (req, res) => {
  const { locationId } = req.params;
  await locationService.deleteLocation(locationId);
  res.send({
    code: httpStatus.OK,
    message: Message.locationMsg.delete,
  });
});

module.exports = {
  createLocation,
  getLocationByLocationId,
  updateLocation,
  deleteLocation,
};
