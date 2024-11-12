const express = require('express');
const pictureController = require('../../controllers/picture.controller');
const pictureValidation = require('../../validations/picture.validation');

const router = express.Router();

router
    .route('/')
    .post(pictureController.createPicture);

module.exports = router;
