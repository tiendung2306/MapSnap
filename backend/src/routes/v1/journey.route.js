const express = require('express');
const journeyController = require('../../controllers/journey.controller');
const auth = require('../../middlewares/auth');
const permissionType = require('../../utils/constant');

const router = express.Router();

// get all journey of user
router.get('/', journeyController.getJourneysByUserId);
// create journey
router.post(
  '/',
  //auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  journeyController.createJourney
);

router
  .route('/:journeyId')
  .get(journeyController.getJourneyByJourneyId)
  .patch(journeyController.updateJourney)
  .delete(journeyController.deleteJourney);

module.exports = router;
