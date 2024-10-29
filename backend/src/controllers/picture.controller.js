const httpStatus = require('http-status');
const catchAsync = require('../utils/catchAsync');
const { pictureService } = require('../services');

const createPicture = catchAsync(async (req, res) => {
  const picture = await pictureService.createPicture(req.body);
  res.status(httpStatus.CREATED).send(picture);
});

module.exports = {
  createPicture,
};
