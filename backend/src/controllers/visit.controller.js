const httpStatus = require('http-status');
const Message = require('../utils/Message');
const catchAsync = require('../utils/catchAsync');
const visitService = require('../services/visit.service');

const createVisit = catchAsync(async (req, res) => {
  const visit = await visitService.createVisit(req.body);
  res.status(httpStatus.CREATED).send({
    code: httpStatus.CREATED,
    message: Message.visitMsg.created,
    result: visit,
  });
});

const getVisitByVisitId = catchAsync(async (req, res) => {
  const { visitId } = req.params;
  const visit = await visitService.getVisitByVisitId(visitId);
  res.send({ code: httpStatus.OK, message: Message.ok, result: visit });
});

const updateVisit = catchAsync(async (req, res) => {
  const { visitId } = req.params;
  const requestBody = req.body;
  await visitService.updateVisit({ visitId, requestBody });
  res.send({
    code: httpStatus.OK,
    message: Message.visitMsg.update,
  });
});

const deleteVisit = catchAsync(async (req, res) => {
  const { visitId } = req.params;
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
