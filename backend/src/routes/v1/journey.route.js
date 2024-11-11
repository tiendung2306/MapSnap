const express = require('express');
const journeyController = require('../../controllers/journey.controller');
// const auth = require('../../middlewares/auth');
// const permissionType = require('../../utils/constant');

const router = express.Router();

// get all journey of user
router.get('/', journeyController.getJourneysByUserId);
// create journey
router.post(
  '/create-journey',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  journeyController.createJourney
);

router
  .route('/:journeyId')
  .get(journeyController.getJourneyByJourneyId)
  .patch(journeyController.updateJourney)
  .delete(journeyController.deleteJourney);

module.exports = router;

/**
 * @swagger
 * /journey/create-journey:
 *   post:
 *     summary: Create a journey
 *     description: Only admins can create other journeys.
 *     tags: [Journeys]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - started_at
 *               - ended_at
 *             properties:
 *               title:
 *                 type: string
 *                 description: title
 *               started_at:
 *                 type: number
 *                 description: Epoch time started at
 *               ended_at:
 *                 type: number
 *                 description: Epoch time ended at
 *               status:
 *                 type: boolean
 *                 description: status of journey (enabled/ disabled)
 *             example:
 *               title: Ngayhomnayemcuoiroi
 *               started_at: 1731072409
 *               ended_at: 1731072409
 *               updated_at: 1731072409
 *     responses:
 *       "200":
 *         description: Created
 *         content:
 *           application/json:
 *             schema:
 *                $ref: '#/components/schemas/Journey'
 *       "400":
 *         $ref: '#/components/responses/DuplicateJourney'
 *
 *   get:
 *     summary: Get all journeys of user
 *     description: Get all journeys of user.
 *     tags: [Journeys]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *        content:
 *         application/json:
 *           schema:git
 *             type: object
 *             required:
 *               - userId
 *             properties:
 *               userId:
 *                 type: string
 *                 description: Id of user
 *             example:
 *               userId: DkmthgSon
 *     responses:
 *       "200":
 *         description: OK
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 results:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Journey'
 *                 page:
 *                   type: integer
 *                   example: 1
 *                 limit:
 *                   type: integer
 *                   example: 10
 *                 totalPages:
 *                   type: integer
 *                   example: 1
 *                 totalResults:
 *                   type: integer
 *                   example: 1
 *       "401":
 *         $ref: '#/components/responses/Unauthorized'
 *       "403":
 *         $ref: '#/components/responses/Forbidden'
 */

/**
 * @swagger
 * /journeys/{id}:
 *   get:
 *     summary: Get a journey
 *     tags: [Journeys]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Journey ID
 *     responses:
 *       "200":
 *         description: OK
 *         content:
 *           application/json:
 *             schema:
 *                $ref: '#/components/schemas/Journey'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 *
 *   patch:
 *     summary: Update a journey
 *     tags: [Journeys]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Journey ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               title:
 *                 type: string
 *               started_at:
 *                 type: number
 *                 description: Epoch time started at
 *               ended_at:
 *                 type: number
 *                 description: Epoch time ended at
 *               updated_at:
 *                 type: number
 *                 description: Epoch time updated at
 *               status:
 *                 type: boolean
 *                 description: status
 *             example:
 *               title: emcuoiroia
 *               started_at: 1731072409
 *               ended_at: 1731072409
 *               updated_at: 1731072409
 *               status: disabled
 *     responses:
 *       "200":
 *         description: OK
 *         content:
 *           application/json:
 *             schema:
 *                $ref: '#/components/schemas/Journey'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 *
 *   delete:
 *     summary: Delete a journey
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Journey ID
 *     responses:
 *       "204":
 *         description: No content
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 */

/**
 * @swagger
 * /users/avatar/{userId}:
 *   post:
 *     summary: Upload user avatar
 *     description: Uploads an avatar image for the specified user.
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         description: The ID of the user to update the avatar for.
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               avatar:
 *                 type: string
 *                 format: binary
 *                 description: The avatar image file to upload.
 *     responses:
 *       '200':
 *         description: Avatar uploaded successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 avatar:
 *                   type: string
 *                   description: The URL of the uploaded avatar image
 *       '400':
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *       '500':
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 */
