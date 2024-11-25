const express = require('express');
const locationController = require('../../controllers/location.controller');
// const auth = require('../../middlewares/auth');
// const permissionType = require('../../utils/constant');

const router = express.Router();

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
 *               - name
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
 *               name:
 *                 type: string
 *                 description: Location Name
 *               cityId:
 *                 type: string
 *                 description: Belong to which city
 *               categoryId:
 *                 type: string
 *                 description: Belong to which category
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
 *               name: "Emcuoiroia"
 *               cityId: 6742a4e6f7e0193cf08162ef
 *               categoryId: 6742a5cced0e2c4a0430085d
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
 *               name:
 *                 type: string
 *                 description: Location Name
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
 *               name: "Emcuoiroia"
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
 *               name:
 *                 type: string
 *                 description: Location Name
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
 *               name: "Emcuoiroiaaa"
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
