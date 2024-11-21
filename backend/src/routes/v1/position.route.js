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
 *               positionName:
 *                 type: string
 *                 description: Reverse Geocoding of position
 *             example:
 *               longitude: 3
 *               latitude: 4
 *               createdAt: 1731319800
 *               locationId: "60c72b2f5f1b2c001f8e4e39"
 *               positionName: "24 Hoa Lu District"
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
