const express = require('express');
const positionController = require('../../controllers/position.controller');
// const auth = require('../../middlewares/auth');
// const permissionType = require('../../utils/constant');

const router = express.Router();

// create position
router.post(
  '/:userId/create-position',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  positionController.createPosition
);

router.post(
  '/:userId/get-position',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  positionController.getPosition
);

router.post(
  '/:userId/get-nearest-position',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  positionController.getNearestPosition
);

router.route('/:positionId').delete(positionController.deletePosition);

module.exports = router;

/**
 * @swagger
 * /position/{userId}/create-position:
 *   post:
 *     summary: Create a position
 *     description: Only admins can create other positions.
 *     tags: [Positions]
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
 *               - longitude
 *               - latitude
 *               - createdAt
 *             properties:
 *               locationId:
 *                 type: string
 *                 description: Which location is this?
 *               createdAt:
 *                 type: number
 *                 description: Epoch time started at
 *               longitude:
 *                 type: number
 *                 description: Longitude of position
 *               latitude:
 *                 type: number
 *                 description: Latitude of position
 *               address:
 *                 type: string
 *                 description: Reverse Geocoding of position
 *               country:
 *                 type: string
 *                 description: Belong to which country
 *               district:
 *                 type: string
 *                 description: Belong to which district
 *               homeNumber:
 *                 type: number
 *                 description: Belong to which homeNumber
 *               classify:
 *                 type: string
 *                 description: Which one is this location?
 *             example:
 *               longitude: 3
 *               latitude: 4
 *               createdAt: 1731319800
 *               locationId: "60c72b2f5f1b2c001f8e4e39"
 *               cityId: 6742a4e6f7e0193cf08162ef
 *               address: "24 Hoa Lu Phuong Le Dai Hanh"
 *               country: "Viet Nam"
 *               district: "Hoa Lu"
 *               homeNumber: 24
 *               classify: "Restaurant"
 *     responses:
 *       "201":
 *         description: Created
 *         content:
 *           application/json:
 *             schema:
 *                type: object
 *                properties:
 *                  code:
 *                    type: integer
 *                    example: 201
 *                  message:
 *                    type: string
 *                    example: tạo vị trí người dùng thành công
 *                  results:
 *                    $ref: '#/components/schemas/Position'
 */

/**
 * @swagger
 * /position/{userId}/get-position:
 *   post:
 *     summary: Get positions
 *     tags: [Positions]
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
 *               locationId:
 *                 type: string
 *                 description: Belong to which category
 *               from:
 *                 type: number
 *                 description: Filter the start time of Position
 *               to:
 *                 type: number
 *                 description: Filter the end time of Position
 *             example:
 *               from: 1731072409
 *               to: 1731073000
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
 *                   example: lấy chuỗi tọa độ thành công
 *                 result:
 *                   $ref: '#/components/schemas/Position'
 */

/**
 * @swagger
 * /position/{userId}/get-nearest-position:
 *   post:
 *     summary: Get nearest positions
 *     tags: [Positions]
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
 *               longitude:
 *                 type: number
 *                 description: Which coordinate to query
 *               latitude:
 *                 type: number
 *                 description: Which coordinate to query
 *               locationId:
 *                 type: string
 *                 description: Belong to which category
 *               from:
 *                 type: number
 *                 description: Filter the start time of Position
 *               to:
 *                 type: number
 *                 description: Filter the end time of Position
 *             example:
 *               longitude: 3
 *               latitude: 4
 *               from: 1731072000
 *               to: 1731073000
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
 *                   example: lấy chuỗi tọa độ thành công
 *                 result:
 *                   $ref: '#/components/schemas/Position'
 */

/**
 * @swagger
 * /position/{id}:
 *   delete:
 *     summary: Delete a position
 *     tags: [Positions]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Position Id
 *     responses:
 *       "200":
 *         description: Delete position successful
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
 *                   example: xóa thành công
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 */
