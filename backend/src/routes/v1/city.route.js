const express = require('express');
const cityController = require('../../controllers/city.controller');
// const auth = require('../../middlewares/auth');
// const permissionType = require('../../utils/constant');

const router = express.Router();

// create city
router.post(
  '/:userId/create-city',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  cityController.createCity
);

router.post(
  '/:userId/get-cities',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  cityController.getCities
);

router.delete(
  '/:cityId/delete-hard-city',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  cityController.deleteHardCity
);

router
  .route('/:cityId')
  .get(cityController.getCityByCityId)
  .patch(cityController.updateCity)
  .delete(cityController.deleteCity);

module.exports = router;

/**
 * @swagger
 * /city/{userId}/create-city:
 *   post:
 *     summary: Create a city
 *     description: Only admins can create other cities.
 *     tags: [Cities]
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
 *               - visitedTime
 *               - createdAt
 *               - status
 *               - updatedByUser
 *               - isAutomaticAdded
 *             properties:
 *               name:
 *                 type: string
 *                 description: City Name
 *               createdAt:
 *                 type: number
 *                 description: Epoch time started at
 *               status:
 *                 type: boolean
 *                 description: status of city (enabled/ disabled)
 *               updatedByUser:
 *                 type: boolean
 *                 description: define if user have updated or not
 *               isAutomaticAdded:
 *                 type: boolean
 *                 description: define if this city add by user or BE
 *             example:
 *               name: "Vinh"
 *               visitedTime: 2
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
 *                   example: tạo thành phố thành công
 *                 result:
 *                   $ref: '#/components/schemas/City'
 *       "400":
 *         $ref: '#/components/responses/DuplicateCity'
 */

/**
 * @swagger
 * /city/{userId}/get-cities:
 *   post:
 *     summary: Get cities
 *     tags: [Cities]
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
 *               searchText:
 *                 type: string
 *                 description: Search Location Name
 *             example:
 *               searchText: "Ha Noi"
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
 *                   $ref: '#/components/schemas/City'
 */

/**
 * @swagger
 * /city/{id}:
 *   get:
 *     summary: Get a city
 *     tags: [Cities]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: City ID
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
 *                   $ref: '#/components/schemas/City'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 *
 *   patch:
 *     summary: Update a city
 *     tags: [Cities]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: City ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 description: City Name
 *               createdAt:
 *                 type: number
 *                 description: Epoch time started at
 *               status:
 *                 type: boolean
 *                 description: status of city (enabled/ disabled)
 *               updatedByUser:
 *                 type: boolean
 *                 description: define if user have updated or not
 *               isAutomaticAdded:
 *                 type: boolean
 *                 description: define if this city add by user or BE
 *             example:
 *               name: "Vinh"
 *               visitedTime: 213
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
 *                   $ref: '#/components/schemas/City'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 *
 *   delete:
 *     summary: Delete a city
 *     tags: [Cities]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: City ID
 *     responses:
 *       "200":
 *         description: Delete city successful
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
 *                   example: xóa thành phố thành công
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 */
