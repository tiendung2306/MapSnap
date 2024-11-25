const httpStatus = require('http-status');
const Message = require('../utils/Message');
const catchAsync = require('../utils/catchAsync');
const locationCategoryService = require('../services/locationCategory.service');

const createLocationCategory = catchAsync(async (req, res) => {
  const requestBody = req.body;
  requestBody.userId = req.params.userId;
  const locationCategory = await locationCategoryService.createLocationCategory(requestBody);
  res.status(httpStatus.CREATED).send({
    code: httpStatus.CREATED,
    message: Message.locationCategoryMsg.created,
    result: locationCategory,
  });
});

const getLocationCategory = catchAsync(async (req, res) => {
  const request = req.body;
  request.userId = req.params.userId;
  const category = await locationCategoryService.getLocationCategory(request);
  res.send({ code: httpStatus.OK, message: Message.ok, result: category });
});

const getLocationCategoryById = catchAsync(async (req, res) => {
  const locationCategory = await locationCategoryService.getLocationCategoryById(req.params.locationCategoryId);
  res.send({ code: httpStatus.OK, message: Message.ok, result: locationCategory });
});

const updateLocationCategory = catchAsync(async (req, res) => {
  const { locationCategoryId } = req.params;
  const requestBody = req.body;
  await locationCategoryService.updateLocationCategory({ locationCategoryId, requestBody });
  res.send({
    code: httpStatus.OK,
    message: Message.locationCategoryMsg.updated,
  });
});

const deleteLocationCategory = catchAsync(async (req, res) => {
  await locationCategoryService.deleteLocationCategory(req.params.locationCategoryId);
  res.send({
    code: httpStatus.OK,
    message: Message.locationCategoryMsg.deleted,
  });
});

module.exports = {
  createLocationCategory,
  getLocationCategory,
  getLocationCategoryById,
  updateLocationCategory,
  deleteLocationCategory,
};
