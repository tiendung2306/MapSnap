const commentController = require('../../controllers/comments.controller');
const express = require('express');

const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Comments
 *   description: Comment management
 */

/**
 * @swagger
 * /comments:
 *   post:
 *     summary: Create a comment
 *     tags: [Comments]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               userId:
 *                 type: string
 *                 example: "60d21b4667d0d8992e610c85"
 *               postId:
 *                 type: string
 *                 example: "60d21b4667d0d8992e610c85"
 *               content:
 *                 type: string
 *                 example: "This is a comment"
 *               createdAt:
 *                 type: number
 *                 example: 1624545454
 *               updatedAt:
 *                 type: number
 *                 example: 1624545454
 *     responses:
 *       201:
 *         description: Comment created successfully
 *         content:
 *           application/json:
 *             schema:
 *               example:
 *                 _id: 60d21b4667d0d8992e610c85
 *                 userId: 60d21b4667d0d8992e610c85
 *                 postId: 60d21b4667d0d8992e610c85
 *                 content: "This is a comment"
 *                 createdAt: 1624545454
 *                 updatedAt: 1624545454
 *       400:
 *         description: Invalid input
 */
router.
    route('/')
    .post(commentController.createComment);

/**
 * @swagger
 * /comments/{commentId}:
 *   get:
 *     summary: Get a comment by ID
 *     tags: [Comments]
 *     parameters:
 *       - in: path
 *         name: commentId
 *         schema:
 *           type: string
 *         required: true
 *         description: The comment ID
 *     responses:
 *       200:
 *         description: Comment retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               example:
 *                 _id: 60d21b4667d0d8992e610c85
 *                 userId: 60d21b4667d0d8992e610c85
 *                 postId: 60d21b4667d0d8992e610c85
 *                 content: "This is a comment"
 *                 createdAt: 1624545454
 *                 updatedAt: 1624545454
 *       404:
 *         description: Comment not found
 *   patch:
 *     summary: Update a comment by ID
 *     tags: [Comments]
 *     parameters:
 *       - in: path
 *         name: commentId
 *         schema:
 *           type: string
 *         required: true
 *         description: The comment ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               userId:
 *                 type: string
 *                 example: "60d21b4667d0d8992e610c85"
 *               postId:
 *                 type: string
 *                 example: "60d21b4667d0d8992e610c85"
 *               content:
 *                 type: string
 *                 example: "This is a comment"
 *               createdAt:
 *                 type: number
 *                 example: 1624545454
 *               updatedAt:
 *                 type: number
 *                 example: 1624545454
 *     responses:
 *       200:
 *         description: Comment updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               example:
 *                 _id: 60d21b4667d0d8992e610c85
 *                 userId: 60d21b4667d0d8992e610c85
 *                 postId: 60d21b4667d0d8992e610c85
 *                 content: "This is a comment"
 *                 createdAt: 1624545454
 *                 updatedAt: 1624545454 
 *       404:
 *         description: Comment not found
 *   delete:
 *     summary: Delete a comment by ID
 *     tags: [Comments]
 *     parameters:
 *       - in: path
 *         name: commentId
 *         schema:
 *           type: string
 *         required: true
 *         description: The comment ID
 *     responses:
 *       200:
 *         description: Comment deleted successfully
 *       404:
 *         description: Comment not found
 */
router.
    route('/:commentId')
    .get(commentController.getCommentById)
    .patch(commentController.updateCommentById)
    .delete(commentController.deleteCommentById);

/**
 * @swagger
 * /comments/post/{postId}:
 *   get:
 *     summary: Get comments by post ID
 *     tags: [Comments]
 *     parameters:
 *       - in: path
 *         name: postId
 *         schema:
 *           type: string
 *         required: true
 *         description: The post ID
 *     responses:
 *       200:
 *         description: Comments retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 example:
 *                   _id: 60d21b4667d0d8992e610c85
 *                   userId: 60d21b4667d0d8992e610c85
 *                   postId: 60d21b4667d0d8992e610c85
 *                   content: "This is a comment"
 *                   createdAt: 1624545454
 *                   updatedAt: 1624545454 
 *       404:
 *         description: Post not found
 */
router.
    route('/post/:postId')
    .get(commentController.getCommentsByPostId);

module.exports = router;

