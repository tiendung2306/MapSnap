const httpStatus = require('http-status');
const Message = require('../utils/Message');
const catchAsync = require('../utils/catchAsync');
const positionService = require('../services/position.service');

const createPosition = catchAsync(async (req, res) => {
  const requestBody = req.body;
  requestBody.userId = req.params.userId;
  const position = await positionService.createPosition(requestBody);
  res.status(httpStatus.CREATED).send({
    code: httpStatus.CREATED,
    message: Message.positionMsg.created,
    result: position,
  });
});

const getPosition = catchAsync(async (req, res) => {
  const request = req.body;
  request.userId = req.params.userId;
  const position = await positionService.getPosition(request);
  res.send({ code: httpStatus.OK, message: Message.ok, result: position });
});

const getNearestPosition = catchAsync(async (req, res) => {
  const request = req.body;
  request.userId = req.params.userId;
  const position = await positionService.getNearestPosition(request);
  res.send({ code: httpStatus.OK, message: Message.ok, result: position });
});

const deletePosition = catchAsync(async (req, res) => {
  await positionService.deletePosition(req.params.positionId);
  res.send({
    code: httpStatus.OK,
    message: Message.positionMsg.deleted,
  });
});

module.exports = {
  createPosition,
  getPosition,
  getNearestPosition,
  deletePosition,
};
