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
