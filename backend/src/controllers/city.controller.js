const httpStatus = require('http-status');
const Message = require('../utils/Message');
const catchAsync = require('../utils/catchAsync');
const cityService = require('../services/city.service');

const createCity = catchAsync(async (req, res) => {
  const requestBody = req.body;
  requestBody.userId = req.params.userId;
  const city = await cityService.createCity(requestBody);
  res.status(httpStatus.CREATED).send({
    code: httpStatus.CREATED,
    message: Message.cityMsg.created,
    result: city,
  });
});

const getCities = catchAsync(async (req, res) => {
  const request = req.body;
  request.userId = req.params.userId;
  const city = await cityService.getCities(request);
  res.send({ code: httpStatus.OK, message: Message.ok, result: city });
});

const getCityByCityId = catchAsync(async (req, res) => {
  const city = await cityService.getCityByCityId(req.params.cityId);
  res.send({ code: httpStatus.OK, message: Message.ok, result: city });
});

const updateCity = catchAsync(async (req, res) => {
  const { cityId } = req.params;
  const requestBody = req.body;
  await cityService.updateCity({ cityId, requestBody });
  res.send({
    code: httpStatus.OK,
    message: Message.cityMsg.updated,
  });
});

const deleteCity = catchAsync(async (req, res) => {
  await cityService.deleteCity(req.params.cityId);
  res.send({
    code: httpStatus.OK,
    message: Message.cityMsg.deleted,
  });
});

const deleteHardCity = catchAsync(async (req, res) => {
  await cityService.deleteHardCity(req.params.cityId);
  res.send({
    code: httpStatus.OK,
    message: Message.cityMsg.deleted,
  });
});

module.exports = {
  createCity,
  getCities,
  getCityByCityId,
  updateCity,
  deleteCity,
  deleteHardCity,
};
