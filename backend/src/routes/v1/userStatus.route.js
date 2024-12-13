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
