const express = require('express');
const locationController = require('../../controllers/location.controller');
// const auth = require('../../middlewares/auth');
// const permissionType = require('../../utils/constant');

const router = express.Router();

// create location
router.post(
  '/create-location',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  locationController.createLocation
);

router
  .route('/:locationId')
  .get(locationController.getLocationByLocationId)
  .patch(locationController.updateLocation)
  .delete(locationController.deleteLocation);

module.exports = router;
