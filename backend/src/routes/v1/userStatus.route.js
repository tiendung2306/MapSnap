const express = require('express');
const userStatusController = require('../../controllers/userStatus.controller');
// const auth = require('../../middlewares/auth');
// const permissionType = require('../../utils/constant');

const router = express.Router();

// create user status
router.post(
  '/:userId/create-user-status',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  userStatusController.createUserStatus
);

router.route('/:userId').get(userStatusController.getUserStatus).patch(userStatusController.updateUserStatus);

router.post(
  '/:userId/periodically-automatic-feature',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  userStatusController.periodicallyAutomaticFeature
);

module.exports = router;

/**
 * @swagger
 * /userStatus/{userId}/periodically-automatic-feature:
 *   post:
 *     summary: Automatic check periodically
 *     tags: [User Status]
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
 *       "201":
 *         description: User Status updated successfully
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
 *                   example: tính năng tự động thành công
 *                 result:
 *                   $ref: '#/components/schemas/UserStatus'
 */
