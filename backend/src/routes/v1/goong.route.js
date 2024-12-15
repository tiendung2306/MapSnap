const express = require('express');
const goongController = require('../../controllers/goong.controller');
const router = express.Router();

router
    .route('/reverse-geocoding')
    .get(goongController.reverseGeocoding);

router
    .route('/forward-geocoding')
    .get(goongController.forwardGeocoding);

module.exports = router;

/**
 * @swagger
 * /reverse-geocoding:
 *   get:
 *     summary: Reverse geocoding to get address from coordinates
 *     tags: [Goong]
 *     parameters:
 *       - in: query
 *         name: lat
 *         schema:
 *           type: number
 *         required: true
 *         description: Latitude of the location
 *       - in: query
 *         name: lng
 *         schema:
 *           type: number
 *         required: true
 *         description: Longitude of the location
 *     responses:
 *       200:
 *         description: Successful response
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 plus_code:
 *                   type: string
 *                 results:
 *                   type: array
 *                   items:
 *                     type: object
 *       400:
 *         description: Bad request
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /forward-geocoding:
 *   get:
 *     summary: Forward geocoding to get coordinates from address
 *     tags: [Goong]
 *     parameters:
 *       - in: query
 *         name: address
 *         schema:
 *           type: string
 *         required: true
 *         description: Address to get coordinates for
 *     responses:
 *       200:
 *         description: Successful response
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *       400:
 *         description: Bad request
 *       500:
 *         description: Internal server error
 */
