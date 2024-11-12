const Joi = require('joi');

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

module.exports = {
    createPicture,
}