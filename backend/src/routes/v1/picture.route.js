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

/**
 * @swagger
 * tags:
 *   name: Pictures
 *   description: Picture management and retrieval
 */

/**
 * @swagger
 * /pictures:
 *   post:
 *     summary: Create some pictures
 *     description: Upload new pictures.
 *     tags: [Pictures]
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             required:
 *               - userId
 *               - capturedAt
 *             properties:
 *               userId:
 *                 type: Schema.Types.ObjectId
 *                 description: ID of the user uploading the picture
 *               locationId:
 *                 type: Schema.Types.ObjectId
 *                 description: ID of the location where the picture was taken
 *               visitId:
 *                 type: Schema.Types.ObjectId
 *                 description: ID of the visit during which the picture was taken
 *               journeyId:
 *                 type: Schema.Types.ObjectId
 *                 description: ID of the journey associated with the picture
 *               capturedAt:
 *                 type: number
 *                 description: The date and time when the picture was created
 *               picture:
 *                 type: string
 *                 format: binary
 *                 description: The picture files to upload
 *     responses:
 *       "200":
 *         description: Pictures uploaded successfully
 *         content:
 *           application/json:
 *             schema:
 *                type: array
 *                items:
 *                  $ref: '#/components/schemas/Picture'
 *       "400":
 *         $ref: '#/components/responses/BadRequest'
 *       "500":
 *         $ref: '#/components/responses/InternalError'
 *
 *   get:
 *     summary: Get all pictures
 *     description: Retrieve a list of all pictures.
 *     tags: [Pictures]
 *     parameters:
 *       - in: query
 *         name: userId
 *         schema:
 *           type: string
 *         description: ID of the user
 *       - in: query
 *         name: locationId
 *         schema:
 *           type: string
 *         description: ID of the location
 *       - in: query
 *         name: visitId
 *         schema:
 *           type: string
 *         description: ID of the visit
 *       - in: query
 *         name: journeyId
 *         schema:
 *           type: string
 *         description: ID of the journey
 *       - in: query
 *         name: link
 *         schema:
 *           type: string
 *         description: Link to the picture
 *       - in: query
 *         name: captureddAt
 *         schema:
 *           type: string
 *       - in: query
 *         name: public_id
 *         schema:
 *           type: string
 *     responses:
 *       "200":
 *         description: A list of pictures
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Picture'
 *       "400":
 *         $ref: '#/components/responses/BadRequest'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 */

/**
 * @swagger
 * /pictures/{id}:
 *   get:
 *     summary: Get a picture by ID
 *     description: Retrieve details about a specific picture by its ID.
 *     tags: [Pictures]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Picture ID
 *     responses:
 *       "200":
 *         description: Picture details
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Picture'
 *       "400":
 *         $ref: '#/components/responses/BadRequest'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 *
 *   delete:
 *     summary: Delete a picture by ID
 *     description: Remove a picture from the database by its ID.
 *     tags: [Pictures]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Picture ID
 *     responses:
 *       "204":
 *         description: No content, picture deleted successfully
 *       "400":
 *         $ref: '#/components/responses/BadRequest'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 */

/**
 * @swagger
 * components:
 *   schemas:
 *     Picture:
 *       type: object
 *       required:
 *         - userId
 *         - locationId
 *         - visitId
 *         - journeyId
 *         - link
 *         - capturedAt
 *         - public_id
 *       properties:
 *         userId:
 *           type: string
 *           description: ID of the user who uploaded the picture
 *         locationId:
 *           type: string
 *           description: ID of the location where the picture was taken
 *         visitId:
 *           type: string
 *           description: ID of the visit during which the picture was taken
 *         journeyId:
 *           type: string
 *           description: ID of the journey associated with the picture
 *         link:
 *           type: string
 *           description: URL link to the picture
 *         capturedAt:
 *           type: string
 *           format: date-time
 *           description: The date and time when the picture was created
 *         public_id:
 *           type: string
 *           description: Public ID in cloudinary
 *         id:
 *           type: string
 *           description: Picture ID
 *       example:
 *         userId: "60c72b2f9af1b8124cf74c9a"
 *         locationId: "60c72b2f9af1b8124cf74c9b"
 *         visitId: "60c72b2f9af1b8124cf74c9c"
 *         journeyId: "60c72b2f9af1b8124cf74c9d"
 *         link: "http://example.com/image1.jpg"
 *         capturedAt: "2023-04-12T10:00:00.000Z"
 *         public_id: "uploads/picture-77380651-f817-4123-b879-8fe8ab8f5771"
 *         id: "6734dab6bb4a94160c1f419a"
 *   responses:
 *     BadRequest:
 *       description: Invalid request
 *     NotFound:
 *       description: Resource not found
 *     InternalError:
 *       description: Internal server error
 */
