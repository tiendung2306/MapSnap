const httpStatus = require('http-status');
const catchAsync = require('../utils/catchAsync');
const { pictureService } = require('../services');
const ApiError = require('../utils/ApiError');

const createPicture = catchAsync(async (req, res) => {
  await pictureService.createPicture(req, res);
});

const getPictureById = catchAsync(async (req, res) => {
  const { id } = req.params;
  const picture = await pictureService.getPictureById(id);
  if (!picture) throw new ApiError(httpStatus.NOT_FOUND, 'Picture not found!');
  res.send(picture);
});

const getPictures = catchAsync(async (req, res) => {
  const pictures = await pictureService.getPictures(req, res);
  if (!pictures) throw new ApiError(httpStatus.NOT_FOUND, 'Picture not found!');
  res.send(pictures);
});

const deletePicture = catchAsync(async (req, res) => {
  const picture = await pictureService.deletePictureById(req.params.id);
  res.status(httpStatus.NO_CONTENT).send(picture);
});

module.exports = {
  createPicture,
  getPictureById,
  getPictures,
  deletePicture,
};
