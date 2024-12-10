const express = require('express');
const historyLogController = require('../../controllers/historyLog.controller');
// const auth = require('../../middlewares/auth');
// const permissionType = require('../../utils/constant');

const router = express.Router();

// create history log
router.post(
  '/:userId/create-history-log',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  historyLogController.createHistoryLog
);

router.post(
  '/:userId/get-history-logs',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  historyLogController.getHistoryLogs
);

module.exports = router;

/**
 * @swagger
 * /historyLog/{userId}/create-history-log:
 *   post:
 *     summary: Create History Log
 *     tags: [History Log]
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
 *               - activityType
 *               - modelImpact
 *               - createdAt
 *               - updatedByUser
 *               - isAutomaticAdded
 *             properties:
 *               activityType:
 *                 type: string
 *                 description: CRUD
 *               createdAt:
 *                 type: number
 *                 description: Epoch time started at
 *               modelImpact:
 *                 type: boolean
 *                 description: Activity on which model
 *               updatedByUser:
 *                 type: boolean
 *                 description: define if user have updated or not
 *               isAutomaticAdded:
 *                 type: boolean
 *                 description: define if this history log add by user or BE
 *             example:
 *               activityType: "Create"
 *               modelImpact: "Journey"
 *               createdAt: 1731319800
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
 *                   example: tạo lịch sử thành công
 *                 result:
 *                   $ref: '#/components/schemas/HistoryLog'
 *       "400":
 *         $ref: '#/components/responses/DuplicateHistoryLog'
 */

/**
 * @swagger
 * /history log/{userId}/get-history-logs:
 *   post:
 *     summary: Get history logs
 *     tags: [History Log]
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
 *               activityType:
 *                 type: string
 *                 description: CRUD
 *               modelImpact:
 *                 type: string
 *                 description: Activity on which model
 *               updatedByUser:
 *                 type: boolean
 *                 description: Activity on which model
 *               isAutomaticAdded:
 *                 type: boolean
 *                 description: Activity on which model
 *               from:
 *                 type: number
 *                 description: time Epoch
 *               to:
 *                 type: number
 *                 description: time Epoch
 *             example:
 *               isAutomaticAdded: true
 *               updatedByUser: true
 *               activityType: "Create"
 *               from: 1731072409
 *               to: 1731073000
 *               modelImpact: "Visit"
 *     responses:
 *       "200":
 *         description: Created
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
 *                   example: lấy thành phố thành công
 *                 result:
 *                   $ref: '#/components/schemas/HistoryLog'
 */
