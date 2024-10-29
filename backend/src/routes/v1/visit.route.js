const express = require('express');
const visitController = require('../../controllers/visit.controller');
// const auth = require('../../middlewares/auth');
// const permissionType = require('../../utils/constant');

const router = express.Router();

// create visit
router.post(
  '/create-visit',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  visitController.createVisit
);

router
  .route('/:visitId')
  .get(visitController.getVisitByVisitId)
  .patch(visitController.updateVisit)
  .delete(visitController.deleteVisit);

module.exports = router;
