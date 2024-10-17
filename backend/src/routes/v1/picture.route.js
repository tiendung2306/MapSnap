const express = require('express');
const pictureController = require('../../controllers/picture.controller');

const router = express.Router();

router
    .route('/')
    .post(pictureController.createPicture)
// .post((req, res) => {
//     res.send('Hello World from picture route');
// })

module.exports = router;