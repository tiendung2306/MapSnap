const express = require('express');
const tripController = require('../../controllers/trip.controller');
// const auth = require('../../middlewares/auth');
// const permissionType = require('../../utils/constant');

const router = express.Router();

// create trip
router.post(
  '/create-trip',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  tripController.createTrip
);

router
  .route('/:locationId')
  .get(tripController.getTripByTripId)
  .patch(tripController.updateTrip)
  .delete(tripController.deleteTrip);

module.exports = router;

/**
 * @swagger
 * /trip/create-trip:
 *   post:
 *     summary: Create a trip
 *     description: Only admins can create other trips.
 *     tags: [Trips]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - journeyId
 *               - startedAt
 *               - endedAt
 *               - status
 *               - updatedByUser
 *               - isAutomaticAdded
 *             properties:
 *               journeyId:
 *                 type: string
 *                 description: Journey Id
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
 *                 description: status of trip (enabled/ disabled)
 *               updatedByUser:
 *                 type: boolean
 *                 description: define if user have updated or not
 *               isAutomaticAdded:
 *                 type: boolean
 *                 description: define if this trip add by user or BE
 *             example:
 *               journeyId: 123432423141234
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
 *                $ref: '#/components/schemas/Trip'
 *       "400":
 *         $ref: '#/components/responses/DuplicateTrip'
 *
 *   get:
 *     summary: Get all trips of user
 *     description: Get all trips of user.
 *     tags: [Trips]
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
 *                     $ref: '#/components/schemas/Trip'
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
 * /trip/{id}:
 *   get:
 *     summary: Get a trip
 *     tags: [Trips]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Trip ID
 *     responses:
 *       "200":
 *         description: OK
 *         content:
 *           application/json:
 *             schema:
 *                $ref: '#/components/schemas/Trip'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 *
 *   patch:
 *     summary: Update a trip
 *     tags: [Trips]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Trip ID
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
 *                $ref: '#/components/schemas/Trip'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 *
 *   delete:
 *     summary: Delete a trip
 *     tags: [Trips]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Trip ID
 *     responses:
 *       "204":
 *         description: No content
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 */
