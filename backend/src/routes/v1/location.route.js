const express = require('express');
const locationController = require('../../controllers/location.controller');
// const auth = require('../../middlewares/auth');
// const permissionType = require('../../utils/constant');

const router = express.Router();

router
  .route('/closest-location')
  .get(locationController.getClosestLocation);

router
  .route('/reverse-geocoding')
  .get(locationController.reverseGeocoding);
/**
 * @swagger
 * /location/reverse-geocoding:
 *   get:
 *     summary: Reverse geocoding
 *     tags: [Locations]
 *     parameters:
 *       - in: query
 *         name: lat
 *         required: true
 *         schema:
 *           type: number
 *         description: Latitude
 *       - in: query
 *         name: lng
 *         required: true
 *         schema:
 *           type: number
 *         description: Longitude
 *       - in: query
 *         name: userId
 *         required: true
 *         schema: 
 *           type: string
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
 *                   example: tự chạy postman mà xem chứ swagger này không đúng đâu =)))
 *                 result:
 *                   type: object
 *                   properties:
 *                     address:
 *                       type: string
 *                       example: "24 Hoa Lu Phuong Le Dai Hanh"
 *                     country:
 *                       type: string
 *                       example: "Viet Nam"
 *                     district:
 *                       type: string
 *                       example: "Hoa Lu"
 *                     city:
 *                       type: string
 *                       example: "Hanoi"
 *       "400":
 *         description: Bad Request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 code:
 *                   type: integer
 *                   example: 400
 *                 message:
 *                   type: string
 *                   example: Invalid parameters
 */

// create location
router.post(
  '/:userId/create-location',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  locationController.createLocation
);

router.post(
  '/:userId/get-location',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  locationController.getLocation
);

router.delete(
  '/:locationId/delete-hard-location',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  locationController.deleteHardLocation
);

router
  .route('/:locationId')
  .get(locationController.getLocationByLocationId)
  .patch(locationController.updateLocation)
  .delete(locationController.deleteLocation);


module.exports = router;

/**
 * @swagger
 * /location/{userId}/create-location:
 *   post:
 *     summary: Create a location
 *     description: Only admins can create other locations.
 *     tags: [Locations]
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
 *               - address
 *               - cityId
 *               - categoryId
 *               - title
 *               - visitedTime
 *               - longitude
 *               - latitude
 *               - createdAt
 *               - status
 *               - updatedByUser
 *               - isAutomaticAdded
 *             properties:
 *               address:
 *                 type: string
 *                 description: Address of Location
 *               country:
 *                 type: string
 *                 description: Belong to which country
 *               district:
 *                 type: string
 *                 description: Belong to which district
 *               homeNumber:
 *                 type: number
 *                 description: Belong to which homeNumber
 *               cityId:
 *                 type: string
 *                 description: Belong to which city
 *               categoryId:
 *                 type: string
 *                 description: Belong to which category
 *               classify:
 *                 type: string
 *                 description: Which one is this location?
 *               title:
 *                 type: string
 *                 description: Title
 *               createdAt:
 *                 type: number
 *                 description: Epoch time started at
 *               longitude:
 *                 type: number
 *                 description: Longitude of location
 *               latitude:
 *                 type: number
 *                 description: Latitude of location
 *               status:
 *                 type: boolean
 *                 description: status of location (enabled/ disabled)
 *               updatedByUser:
 *                 type: boolean
 *                 description: define if user have updated or not
 *               isAutomaticAdded:
 *                 type: boolean
 *                 description: define if this location add by user or BE
 *             example:
 *               address: "24 Hoa Lu Phuong Le Dai Hanh"
 *               country: "Viet Nam"
 *               district: "Hoa Lu"
 *               homeNumber: 24
 *               cityId: 6742a4e6f7e0193cf08162ef
 *               categoryId: 6742a5cced0e2c4a0430085d
 *               classify: "Restaurant"
 *               title: "Ngayhomnayemcuoiroii"
 *               visitedTime: 2
 *               longitude: 3
 *               latitude: 4
 *               createdAt: 1731319800
 *               status: "enabled"
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
 *                   example: tạo điểm cố định thành công
 *                 result:
 *                   $ref: '#/components/schemas/Location'
 *       "400":
 *         $ref: '#/components/responses/DuplicateLocation'
 */

/**
 * @swagger
 * /location/{userId}/get-location:
 *   post:
 *     summary: Get locations
 *     tags: [Locations]
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
 *               cityId:
 *                 type: string
 *                 description: Belong to which city
 *               categoryId:
 *                 type: string
 *                 description: Belong to which category
 *               status:
 *                 type: boolean
 *                 description: status of location (enabled/ disabled)
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
 *               cityId: 6742a4e6f7e0193cf08162ef
 *               categoryId: 6742a5cced0e2c4a0430085d
 *               status: "enabled"
 *               sortType: asc
 *               sortField: visitedTime
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
 *                   example: lấy điểm cố định thành công
 *                 result:
 *                   $ref: '#/components/schemas/Location'
 */

/**
 * @swagger
 * /location/{id}:
 *   get:
 *     summary: Get a location
 *     tags: [Locations]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Location ID
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
 *                   $ref: '#/components/schemas/Location'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 *
 *   patch:
 *     summary: Update a location
 *     tags: [Locations]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Location ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               title:
 *                 type: string
 *                 description: Title
 *               createdAt:
 *                 type: number
 *                 description: Epoch time started at
 *               longitude:
 *                 type: number
 *                 description: Longitude of location
 *               latitude:
 *                 type: number
 *                 description: Latitude of location
 *               status:
 *                 type: boolean
 *                 description: status of location (enabled/ disabled)
 *               updatedByUser:
 *                 type: boolean
 *                 description: define if user have updated or not
 *               isAutomaticAdded:
 *                 type: boolean
 *                 description: define if this location add by user or BE
 *             example:
 *               cityId: 6742a4e6f7e0193cf08162ef
 *               categoryId: 6742a5cced0e2c4a0430085d
 *               title: "Ngayhomnayemcuoiroii"
 *               visitedTime: 213
 *               longitude: 123
 *               latitude: 123
 *               createdAt: 17313198000
 *               status: "disabled"
 *               updatedByUser: true
 *               isAutomaticAdded: false

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
 *                   $ref: '#/components/schemas/Location'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 *
 *   delete:
 *     summary: Delete a location
 *     tags: [Locations]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Location ID
 *     responses:
 *       "200":
 *         description: Delete location successful
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
 *                   example: xóa điểm cố định thành công
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 */
