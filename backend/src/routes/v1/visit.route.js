const express = require('express');
const visitController = require('../../controllers/visit.controller');
// const auth = require('../../middlewares/auth');
// const permissionType = require('../../utils/constant');

const router = express.Router();

// create visit
router.post(
  '/:userId/create-visit',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  visitController.createVisit
);

// get all journey of user
router.post(
  '/:userId/get-visits',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  visitController.getVisit
);

router.delete(
  '/:visitId/delete-hard-visit',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  visitController.deleteHardVisit
);

router
  .route('/:visitId')
  .get(visitController.getVisitByVisitId)
  .patch(visitController.updateVisit)
  .delete(visitController.deleteVisit);

module.exports = router;

/**
 * @swagger
 * /visit/{userId}/create-visit:
 *   post:
 *     summary: Create a visit
 *     description: Only admins can create other vitits.
 *     tags: [Visits]
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
 *                 description: status of visit (enabled/ disabled)
 *               updatedByUser:
 *                 type: boolean
 *                 description: define if user have updated or not
 *               isAutomaticAdded:
 *                 type: boolean
 *                 description: define if this visit add by user or BE
 *             example:
 *               journeyId: 6731d86e2745d6189c244932
 *               locationId: 6731d0bbdf4673b3683eb7a5
 *               title: Ngayhomnayemcuoiroi
 *               startedAt: 1731072409000
 *               endedAt: 1731072409000
 *               updatedAt: 1731072409000
 *               status: enabled
 *               updatedByUser: true
 *               isAutomaticAdded: true
 *     responses:
 *       "201":
 *         description: Created
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
 *                   example: tạo điểm thăm thành công
 *                 result:
 *                   $ref: '#/components/schemas/Visit'
 *       "400":
 *         $ref: '#/components/responses/DuplicateVisit'
 */

/**
 * @swagger
 * /visit/{userId}/get-visits:
 *   post:
 *     summary: Get visits
 *     tags: [Visits]
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
 *               journeyId:
 *                 type: string
 *                 description: Belong to which Journey
 *               locationId:
 *                 type: string
 *                 description: Belong to which Location
 *               from:
 *                 type: number
 *                 description: Filter the start time of Visit
 *               to:
 *                 type: number
 *                 description: Filter the end time of Visit
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
 *               from: 1731072409
 *               to: 1731073000
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
 * /visit/{id}:
 *   get:
 *     summary: Get a visit
 *     tags: [Visits]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Visit ID
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
 *                   $ref: '#/components/schemas/Visit'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 *
 *   patch:
 *     summary: Update a visit
 *     tags: [Visits]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Visit ID
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
 *                   $ref: '#/components/schemas/Visit'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 *
 *   delete:
 *     summary: Delete a visit
 *     tags: [Visits]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Visit ID
 *     responses:
 *       "200":
 *         description: Delete visit successful
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
 *                   example: xóa điểm thăm thành công
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 */
