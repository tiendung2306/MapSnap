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

router
  .route('/:locationId')
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
 *                $ref: '#/components/schemas/Visit'
 *       "400":
 *         $ref: '#/components/responses/DuplicateVisit'
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
 *                $ref: '#/components/schemas/Visit'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 *
 *   patch:
 *     summary: Update a visit
 *     tags: [Visits]
 *     security:
 *       - bearerAuth: []
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
 *                $ref: '#/components/schemas/Visit'
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
 *       "204":
 *         description: No content
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 */
