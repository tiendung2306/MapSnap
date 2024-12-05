const express = require('express');
const likesController = require('../../controllers/likes.controller');
const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Likes
 *   description: Like management and retrieval
 */

/**
 * @swagger
 * /posts/likes:
 *   post:
 *     summary: Add a like
 *     tags: [Likes]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             example:
 *               postId: 5f8a5e7f575d7a2b9c0d47e5
 *               userId: 5f8a5e7f575d7a2b9c0d47e5
 *               createdAt: 13123123
 *     responses:
 *       201:
 *         description: Created
 *         content:
 *           application/json:
 *             schema:
 *               example:
 *                 postId: 5f8a5e7f575d7a2b9c0d47e5
 *                 userId: 5f8a5e7f575d7a2b9c0d47e5
 *                 createdAt: 13123123
 *                 _id: 5f8a5e7f575d7a2b9c0d47e5
 *
 *   delete:
 *     summary: Remove a like
 *     tags: [Likes]
 *     parameters:
 *       - in: path
 *         name: likeId
 *         schema:
 *           type: string
 *         description: Like ID
 *     responses:
 *       204:
 *         description: No Content
 */

router
    .route('/')
    .post(likesController.addLike);

router.get('/:postId', likesController.getLikesByPostId);

router.delete('/:likeId', likesController.removeLike);

/**
 * @swagger
 * /posts/likes/{postId}:
 *   get:
 *     summary: Get likes by post ID
 *     tags: [Likes]
 *     parameters:
 *       - in: path
 *         name: postId
 *         schema:
 *           type: string
 *         required: true
 *         description: Post ID
 *     responses:
 *       200:
 *         description: Successful operation
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               example:
 *                 likesCount: 2
 *                 likes:
 *                   - _id: 674b658ac94a5a439cbd3918
 *                     postId: 674b5b60f102e75058911a88
 *                     userId: 67235633159f8350fce83033
 *                     createdAt: 313123123
 *                     __v: 0
 *                   - _id: 674b7d59dd92af10047bf9cc
 *                     postId: 674b5b60f102e75058911a88
 *                     userId: 67235633159f8350fce83033
 *                     createdAt: 313123123
 *                     __v: 0
 *
 */

module.exports = router;

