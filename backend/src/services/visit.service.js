const httpStatus = require('http-status');
// const _ = require('lodash');
const VisitModel = require('../models/visit.model');
const ApiError = require('../utils/ApiError');
const Message = require('../utils/Message');

const createVisit = async (visitBody) => {
  const visitModel = await VisitModel.create(visitBody);
  return visitModel;
};

const getVisitByVisitId = async (visitId) => {
  const visit = await VisitModel.findById(visitId);
  if (!visit) {
    throw new ApiError(httpStatus.NOT_FOUND, Message.visitMsg.notFound);
  }
  return visit;
};

const updateVisit = async (visitId, requestBody) => {
  const visitModel = await VisitModel.findByIdAndUpdate(visitId, requestBody, { new: true });
  return visitModel;
};

const deleteVisit = async (visitId) => {
  const visitModel = await VisitModel.findByIdAndUpdate(visitId, { status: 'disabled' });
  return visitModel;
};

module.exports = {
  createVisit,
  getVisitByVisitId,
  updateVisit,
  deleteVisit,
};
