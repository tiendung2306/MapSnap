const express = require('express');
const journeyController = require('../../controllers/journey.controller');
// const auth = require('../../middlewares/auth');
// const permissionType = require('../../utils/constant');

const router = express.Router();

// create journey
router.post(
  '/:userId/create-journey',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  journeyController.createJourney
);

// get all journey of user
router.get('/:userId/get-journeys', journeyController.getJourneysByUserId);

// get all journey of user today
router.route('/:userId/get-journeys-today').get(journeyController.getJourneysToday);

// get all journey of user today
router.route('/:userId/get-journeys-updated-by-user').get(journeyController.getJourneysCreatedByUser);

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
 *               - startedAt
 *               - endedAt
 *               - status
 *               - updatedByUser
 *               - isAutomaticAdded
 *             properties:
 *               title:
 *                 type: string
 *                 description: title
 *               startedAt:
 *                 type: number
 *                 description: Epoch time started at
 *               endedAt:
 *                 type: number
 *                 description: Epoch time ended at
 *               status:
 *                 type: boolean
 *                 description: status of journey (enabled/ disabled)
 *               updatedByUser:
 *                 type: boolean
 *                 description: define if user have updated or not
 *               isAutomaticAdded:
 *                 type: boolean
 *                 description: define if this journey add by user or BE
 *             example:
 *               title: Ngayhomnayemcuoiroi
 *               startedAt: 1731072409
 *               endedAt: 1731072409
 *               updatedAt: 1731072409
 *               status: enabled
 *               updatedByUser: true
 *               isAutomaticAdded: true
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
 * @swagger
 * /journey/get-journeys:
 *   get:
 *     summary: Get all journeys of user
 *     description: Get all journeys of user.
 *     tags: [Journeys]
 *     security:
 *       - bearerAuth: []
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
 *
 * @swagger
 * /journey/get-journeys-today:
 *   get:
 *     summary: Get all journeys of user today
 *     description: Get all journeys of user today.
 *     tags: [Journeys]
 *     security:
 *       - bearerAuth: []
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
 *
 * @swagger
 * /journey/get-journeys-created-by-user:
 *   get:
 *     summary: Get all journeys that user created
 *     description: Get all journeys that user created.
 *     tags: [Journeys]
 *     security:
 *       - bearerAuth: []
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
 *
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
 *               startedAt:
 *                 type: number
 *                 description: Epoch time started at
 *               endedAt:
 *                 type: number
 *                 description: Epoch time ended at
 *               updatedAt:
 *                 type: number
 *                 description: Epoch time updated at
 *               status:
 *                 type: boolean
 *                 description: status
 *               updatedByUser:
 *                 type: boolean
 *                 description: status
 *               isAutomaticAdded:
 *                 type: boolean
 *                 description: status
 *             example:
 *               title: emcuoiroia
 *               startedAt: 1731072409
 *               endedAt: 1731072409
 *               updatedAt: 1731072409
 *               status: disabled
 *               updatedByUser: false
 *               isAutomaticAdded: true
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
 *       "204":
 *         description: No content
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 */
