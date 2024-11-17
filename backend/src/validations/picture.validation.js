const Joi = require('joi');
const { objectId } = require('./custom.validation');

const getPictures = {
  query: Joi.object().keys({
    userId: Joi.string(),
    locationId: Joi.string(),
    visitId: Joi.string(),
    journeyId: Joi.string(),
    link: Joi.string(),
    createdAt: Joi.date(),
  }),
};

const getPictureById = {
  params: Joi.object().keys({
    id: Joi.required().custom(objectId),
  }),
};

const deletePicture = {
  params: Joi.object().keys({
    id: Joi.required().custom(objectId),
  }),
};

module.exports = {
  getPictures,
  getPictureById,
  deletePicture,
};
