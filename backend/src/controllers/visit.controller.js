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
  const visit = await visitService.getVisitByVisitId(req.params.visitId);
  res.send({ code: httpStatus.OK, message: Message.ok, result: visit });
});

const updateVisit = catchAsync(async (req, res) => {
  const { visitId } = req.params;
  const requestBody = req.body;
  const visit = await visitService.updateVisit({ visitId, requestBody });
  res.send({
    code: httpStatus.OK,
    message: Message.visitMsg.update,
    result: visit,
  });
});

const deleteVisit = catchAsync(async (req, res) => {
  await visitService.deleteVisit(req.params.visitId);
  res.send({
    code: httpStatus.OK,
    message: Message.visitMsg.deleted,
  });
});

module.exports = {
  createVisit,
  getVisitByVisitId,
  updateVisit,
  deleteVisit,
};
