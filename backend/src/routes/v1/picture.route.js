const express = require('express');
const pictureController = require('../../controllers/picture.controller');
const pictureValidation = require('../../validations/picture.validation');
const validate = require('../../middlewares/validate');

const router = express.Router();

router
    .route('/')
    .post(pictureController.createPicture)
    .get(validate(pictureValidation.getPictures), pictureController.getPictures);

router
    .route('/:id')
    .get(validate(pictureValidation.getPictureById), pictureController.getPictureById)
    .delete(validate(pictureValidation.deletePicture), pictureController.deletePicture);

module.exports = router;
