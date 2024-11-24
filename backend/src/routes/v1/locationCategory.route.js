const express = require('express');
const locationCategoryController = require('../../controllers/locationCategory.controller');
// const auth = require('../../middlewares/auth');
// const permissionType = require('../../utils/constant');

const router = express.Router();

// create locationCategory
router.post(
  '/:userId/create-category',
  // auth(permissionType.USER_RIGHT, permissionType.USER_ADMIN),
  locationCategoryController.createLocationCategory
);

router
  .route('/:locationCategoryId')
  .get(locationCategoryController.getLocationCategoryById)
  .patch(locationCategoryController.updateLocationCategory)
  .delete(locationCategoryController.deleteLocationCategory);

module.exports = router;

/**
 * @swagger
 * /locationCategory/{userId}/create-category:
 *   post:
 *     summary: Create a locationCategory
 *     description: Only admins can create other location categories.
 *     tags: [LocationCategory]
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
 *               - createdAt
 *               - status
 *             properties:
 *               name:
 *                 type: string
 *                 description: Location Category Name
 *               createdAt:
 *                 type: number
 *                 description: Epoch time started at
 *               title:
 *                 type: boolean
 *                 description: Title of locationCategory
 *               status:
 *                 type: boolean
 *                 description: status of locationCategory (enabled/ disabled)
 *             example:
 *               name: "Home"
 *               title: "Son Hyung Min"
 *               createdAt: 1731319800
 *               status: "enabled"
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
 *                   example: tạo danh mục địa điểm thành công
 *                 result:
 *                   $ref: '#/components/schemas/LocationCategory'
 *       "400":
 *         $ref: '#/components/responses/DuplicateLocationCategory'
 */

/**
 * @swagger
 * /locationCategory/{id}:
 *   get:
 *     summary: Get a locationCategory
 *     tags: [LocationCategory]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Location Category ID
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
 *                   $ref: '#/components/schemas/LocationCategory'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 *
 *   patch:
 *     summary: Update a locationCategory
 *     tags: [LocationCategory]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Location Category ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 description: Location Category Name
 *               createdAt:
 *                 type: number
 *                 description: Epoch time started at
 *               status:
 *                 type: boolean
 *                 description: status of locationCategory (enabled/ disabled)
 *             example:
 *               name: "Home"
 *               title: "Son Hyung Min"
 *               createdAt: 17313198000
 *               status: "disabled"
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
 *                   $ref: '#/components/schemas/LocationCategory'
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 *
 *   delete:
 *     summary: Delete a locationCategory
 *     tags: [LocationCategory]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Location Category ID
 *     responses:
 *       "200":
 *         description: Delete locationCategory successful
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
 *                   example: xóa danh mục địa điểm thành công
 *       "404":
 *         $ref: '#/components/responses/NotFound'
 */
