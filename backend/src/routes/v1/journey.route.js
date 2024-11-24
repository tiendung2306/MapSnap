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

// get journey
router.post(
  '/:userId/get-journeys',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  journeyController.getJourney
);

// get all journey of user today
router.route('/:userId/get-journeys-today').get(journeyController.getJourneysToday);

router
  .route('/:journeyId')
  .get(journeyController.getJourneyByJourneyId)
  .patch(journeyController.updateJourney)
  .delete(journeyController.deleteJourney);

module.exports = router;

/**
 * @swagger
 * /journey/{userId}/create-journey:
 *   post:
 *     summary: Create a journey
 *     description: Only admins can create other journeys.
 *     tags: [Journeys]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: User ID
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
 *               startedAt: 1731072409000
 *               endedAt: 1731072409000
 *               updatedAt: 1731072409000
 *               status: enabled
 *               updatedByUser: true
 *               isAutomaticAdded: true
 *     responses:
 *       "201":
 *         description: Journey created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 code:
 *                   type: integer
 *                   example: 201
 *                 message:
 *                   type: string
 *                   example: tạo hành trình thành công
 *                 result:
 *                   $ref: '#/components/schemas/Journey'
 *       "400":
 *         $ref: '#/components/responses/DuplicateJourney'
 */

/**
 * @swagger
 * /location/{userId}/get-journeys:
 *   post:
 *     summary: Get journeys
 *     tags: [Journeys]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: User ID
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               isAutomaticAdded:
 *                 type: boolean
 *                 description: Add by BE or User
 *               updatedByUser:
 *                 type: boolean
 *                 description: Has user updated this?
 *               status:
 *                 type: string
 *                 description: What status wanna filter?
 *               sortType:
 *                 type: string
 *                 description: Which type? (asc or desc)
 *               sortField:
 *                 type: string
 *                 description: Which field wanna sort?
 *               searchText:
 *                 type: string
 *                 description: Using Search
 *             example:
 *               isAutomaticAdded: true
 *               updatedByUser: true
 *               status: enabled
 *               sortType: asc
 *               sortField: startedAt
 *               searchText: Emcuoiroi
 *     responses:
 *       "200":
 *         description: Success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 code:
 *                   type: integer
 *                   example: 200
 *                 message:
 *                   type: string
 *                   example: lấy hành trình thành công
 *                 result:
 *                   $ref: '#/components/schemas/Journey'
 */

/**
 * @swagger
 * /journey/{userId}/get-journeys-today:
 *   get:
 *     summary: Get all journeys of user created today
 *     description: Get all journeys of user created today.
 *     tags: [Journeys]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: User ID
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
 *                 code:
 *                   type: integer
 *                   example: 200
 *                 message:
 *                   type: string
 *                   example: ok
 *                 results:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Journey'
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
 *               type: object
 *               properties:
 *                 code:
 *                   type: integer
 *                   example: 200
 *                 message:
 *                   type: string
 *                   example: ok
 *                 results:
 *                   $ref: '#/components/schemas/Journey'
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
 *               startedAt: 1731072409000
 *               endedAt: 1731072409000
 *               updatedAt: 1731072409000
 *               status: disabled
 *               updatedByUser: false
 *               isAutomaticAdded: true
 *     responses:
 *       "200":
 *         description: OK
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 code:
 *                   type: integer
 *                   example: 200
 *                 message:
 *                   type: string
 *                   example: ok
 *                 results:
 *                   $ref: '#/components/schemas/Journey'
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
 *       "200":
 *         description: Delete journey successful
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 code:
 *                   type: integer
 *                   example: 200
 *                 message:
 *                   type: string
 *                   example: xóa thành công
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 */
