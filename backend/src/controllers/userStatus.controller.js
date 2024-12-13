const httpStatus = require('http-status');
const Message = require('../utils/Message');
const catchAsync = require('../utils/catchAsync');
const userStatusService = require('../services/userStatus.service');

const createUserStatus = catchAsync(async (req, res) => {
  const requestBody = req.body;
  requestBody.userId = req.params.userId;
  const userStatus = await userStatusService.createUserStatus(requestBody);
  res.status(httpStatus.CREATED).send({
    code: httpStatus.CREATED,
    message: Message.ok,
    result: userStatus,
  });
});

const getUserStatus = catchAsync(async (req, res) => {
  const request = req.body;
  request.userId = req.params.userId;
  const userStatus = await userStatusService.getUserStatus(request);
  res.send({ code: httpStatus.OK, message: Message.ok, result: userStatus });
});

const updateUserStatus = catchAsync(async (req, res) => {
  const { userStatusId } = req.params;
  const requestBody = req.body;
  const userStatus = await userStatusService.updateUserStatus({ userStatusId, requestBody });
  res.send({
    code: httpStatus.OK,
    message: Message.ok,
    result: userStatus,
  });
});

const periodicallyAutomaticFeature = catchAsync(async (req, res) => {
  const { userId } = req.params;
  const userStatus = await userStatusService.periodicallyAutomaticFeature(userId);
  res.send({
    code: httpStatus.OK,
    message: Message.ok,
    result: userStatus,
  });
});

module.exports = {
  createUserStatus,
  getUserStatus,
  updateUserStatus,
  periodicallyAutomaticFeature,
};
