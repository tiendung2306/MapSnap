const httpStatus = require('http-status');
const Message = require('../utils/Message');
const catchAsync = require('../utils/catchAsync');
const visitService = require('../services/visit.service');

const createVisit = catchAsync(async (req, res) => {
  const requestBody = req.body;
  requestBody.userId = req.params.userId;
  const visit = await visitService.createVisit(requestBody);
  res.status(httpStatus.CREATED).send({
    code: httpStatus.CREATED,
    message: Message.visitMsg.created,
    result: visit,
  });
});

const getVisitByVisitId = catchAsync(async (req, res) => {
  const { visitId } = req.params.visitId;
  const visit = await visitService.getVisitByVisitId(visitId);
  res.send({ code: httpStatus.OK, message: Message.ok, result: visit });
});

const updateVisit = catchAsync(async (req, res) => {
  const { visitId } = req.params.visitId;
  const requestBody = req.body;
  await visitService.updateVisit({ visitId, requestBody });
  res.send({
    code: httpStatus.OK,
    message: Message.visitMsg.update,
  });
});

const deleteVisit = catchAsync(async (req, res) => {
  const { visitId } = req.params.visitId;
  await visitService.deleteVisit(visitId);
  res.send({
    code: httpStatus.OK,
    message: Message.visitMsg.delete,
  });
});

module.exports = {
  createVisit,
  getVisitByVisitId,
  updateVisit,
  deleteVisit,
};
