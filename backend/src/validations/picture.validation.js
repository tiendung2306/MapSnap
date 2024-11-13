const Joi = require('joi');
const { objectId } = require('./custom.validation');

const createPicture = {
    body: Joi.object().keys({
        user_id: Joi.string().required(),
        location_id: Joi.string().required(),
        visit_id: Joi.string().required(),
        journey_id: Joi.string().required(),
        link: Joi.string().required(),
        created_at: Joi.date().required()
    }),
};

const getPictures = {
    body: Joi.object().keys({
        user_id: Joi.string(),
        location_id: Joi.string(),
        visit_id: Joi.string(),
        journey_id: Joi.string(),
        link: Joi.string(),
        created_at: Joi.date()
    }),
}

const getPictureById = {
    params: Joi.object().keys({
        id: Joi.required().custom(objectId),
    }),
}

const deletePicture = {
    params: Joi.object().keys({
        id: Joi.required().custom(objectId),
    }),
}

module.exports = {
    createPicture,
    getPictures,
    getPictureById,
    deletePicture,
}