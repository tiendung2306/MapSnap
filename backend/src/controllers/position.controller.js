const httpStatus = require('http-status');
const Message = require('../utils/Message');
const catchAsync = require('../utils/catchAsync');
const positionService = require('../services/position.service');

const createPosition = catchAsync(async (req, res) => {
  const position = await positionService.createPosition(req.body);
  res.status(httpStatus.CREATED).send({
    code: httpStatus.CREATED,
    message: Message.positionMsg.created,
    result: position,
  });
});

const deletePosition = catchAsync(async (req, res) => {
  const { positionId } = req.params;
  await positionService.deletePosition(positionId);
  res.send({
    code: httpStatus.OK,
    message: Message.positionMsg.delete,
  });
});

module.exports = {
  createPosition,
  deletePosition,
};
