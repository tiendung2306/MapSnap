const express = require('express');
const postController = require('../../controllers/post.controller');
const router = express.Router();

router
    .route('/')
    .post(postController.createPost)
    .get(postController.getPosts);

router
    .route('/:postId')
    .get(postController.getPost)
    .patch(postController.updatePost)
    .delete(postController.deletePost);

module.exports = router;

/**
 * @swagger
 * tags:
 *   name: Posts
 *   description: Post management and retrieval
 */

/**
 * @swagger
 * /posts:
 *   post:
 *     summary: Create a post
 *     tags: [Posts]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             example:
 *               userId: 5f8a5e7f575d7a2b9c0d47e5
 *               content: "Thích cậu từ Xuân Hạ\nThích tới tận Thu Đông.\nCó một câu hỏi nhỏ\nCậu có thích tớ không?"
 *               media: [{"type": "image", "url": "https://scontent.fhan2-5.fna.fbcdn.net/v/t39.30808-6/468719634_3825302851117569_5554540526716892179_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=aa7b47&_nc_eui2=AeEKDL0hsk_frBsEg8ytor-66fZsNtesiKfp9mw216yIp8icPZb4Dfzh9a6OWjx85IO-eRSVGK6UBhSmfzRbCdFo&_nc_ohc=PBpyvPfDiBkQ7kNvgEGx4IH&_nc_zt=23&_nc_ht=scontent.fhan2-5.fna&_nc_gid=AQerMs57l17sW1EzaJ6X0uJ&oh=00_AYCb8OHhDz_hUabOQ8-E0LDQLxmz4DEH2-y1XOEDoCS3Lg&oe=6751077A"}]
 *               journeyId: 5f8a5e7f575d7a2b9c0d47e5
 *               createdAt: 1633632000
 *               updatedAt: 1633632000
 *               commentsCount: 0
 *               likesCount: 0
 *     responses:
 *       201:
 *         description: Created
 *         content:
 *           application/json:
 *             schema:
 *               example:
 *                 _id: 5f8a5e7f575d7a2b9c0d47e5
 *                 userId: 5f8a5e7f575d7a2b9c0d47e5
 *                 content: "Thích cậu từ Xuân Hạ\nThích tới tận Thu Đông.\nCó một câu hỏi nhỏ\nCậu có thích tớ không?"
 *                 media: [{"type": "image", "url": "https://scontent.fhan2-5.fna.fbcdn.net/v/t39.30808-6/468719634_3825302851117569_5554540526716892179_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=aa7b47&_nc_eui2=AeEKDL0hsk_frBsEg8ytor-66fZsNtesiKfp9mw216yIp8icPZb4Dfzh9a6OWjx85IO-eRSVGK6UBhSmfzRbCdFo&_nc_ohc=PBpyvPfDiBkQ7kNvgEGx4IH&_nc_zt=23&_nc_ht=scontent.fhan2-5.fna&_nc_gid=AQerMs57l17sW1EzaJ6X0uJ&oh=00_AYCb8OHhDz_hUabOQ8-E0LDQLxmz4DEH2-y1XOEDoCS3Lg&oe=6751077A"}]
 *                 journeyId: 5f8a5e7f575d7a2b9c0d47e5 
 *                 createdAt: 1633632000
 *                 updatedAt: 1633632000
 *                 commentsCount: 0
 *                 likesCount: 0
 *   get:
 *     summary: Get all posts
 *     tags: [Posts]
 *     parameters:
 *       - in: query
 *         name: userId
 *         schema:
 *           type: string
 *         description: User ID
 *       - in: query
 *         name: createdAt
 *         schema:
 *           type: string
 *         description: Creation date
 *       - in: query
 *         name: likesCount
 *         schema:
 *           type: integer
 *         description: Number of likes
 *       - in: query
 *         name: commentsCount
 *         schema:
 *           type: integer
 *         description: Number of comments
 *       - in: query
 *         name: sortBy
 *         schema:
 *           type: string
 *         description: Sort by field
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *         description: Maximum number of results per page
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *         description: Page number
 *     responses:
 *       200:
 *         description: OK
 *         content:
 *           application/json:
 *             schema:
 *               
 * paths:
 *   /posts:
 *     get:
 *       summary: Get posts
 *       description: Retrieve a list of posts
 *       responses:
 *         200:
 *           description: OK
 *           content:
 *             application/json:
 *               schema:
 *                 type: object
 *                 properties:
 *                   results:
 *                     type: array
 *                     items:
 *                       type: object
 *                       properties:
 *                         commentsCount:
 *                           type: integer
 *                           example: 0
 *                         likesCount:
 *                           type: integer
 *                           example: 1
 *                         _id:
 *                           type: string
 *                           example: 674b5b60f102e75058911a88
 *                         userId:
 *                           type: string
 *                           example: 671bdc6e2fc15621bca5741a
 *                         content:
 *                           type: string
 *                           example: "Thích cậu từ Xuân Hạ\nThích tới tận Thu Đông.\nCó một câu hỏi nhỏ\nCậu có thích tớ không?"
 *                         media:
 *                           type: array
 *                           items:
 *                             type: object
 *                             properties:
 *                               type:
 *                                 type: string
 *                                 enum: ['image', 'video']
 *                                 example: 'image'
 *                               url:
 *                                 type: string
 *                                 example: "https://scontent.fhan2-5.fna.fbcdn.net/v/t39.30808-6/468719634_3825302851117569_5554540526716892179_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=aa7b47&_nc_eui2=AeEKDL0hsk_frBsEg8ytor-66fZsNtesiKfp9mw216yIp8icPZb4Dfzh9a6OWjx85IO-eRSVGK6UBhSmfzRbCdFo&_nc_ohc=PBpyvPfDiBkQ7kNvgEGx4IH&_nc_zt=23&_nc_ht=scontent.fhan2-5.fna&_nc_gid=AQerMs57l17sW1EzaJ6X0uJ&oh=00_AYCb8OHhDz_hUabOQ8-E0LDQLxmz4DEH2-y1XOEDoCS3Lg&oe=6751077A"
 *                         journeyId:
 *                           type: string
 *                           example: 671bdc6e2fc15621bca5741a
 *                         createdAt:
 *                           type: integer
 *                           example: 3123131
 *                         updatedAt:
 *                           type: integer
 *                           example: 32131231231
 *                         __v:
 *                           type: integer
 *                           example: 0
 *                   page:
 *                     type: integer
 *                     example: 1
 *                   limit:
 *                     type: integer
 *                     example: 10
 *                   totalPages:
 *                     type: integer
 *                     example: 1
 *                   totalResults:
 *                     type: integer
 *                     example: 1
 */

/**
 * @swagger
 * /posts/{postId}:
 *   get:
 *     summary: Get a post by ID
 *     tags: [Posts]
 *     parameters:
 *       - in: path
 *         name: postId
 *         required: true
 *         schema:
 *           type: string
 *         description: Post ID
 *     responses:
 *       200:
 *         description: OK
 *         content:
 *           application/json:
 *             schema:
 *               example:
 *                 _id: 5f8a5e7f575d7a2b9c0d47e5
 *                 userId: 5f8a5e7f575d7a2b9c0d47e5
 *                 content: "Thích cậu từ Xuân Hạ\nThích tới tận Thu Đông.\nCó một câu hỏi nhỏ\nCậu có thích tớ không?"
 *                 media: [{"type": "image", "url": "https://scontent.fhan2-5.fna.fbcdn.net/v/t39.30808-6/468719634_3825302851117569_5554540526716892179_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=aa7b47&_nc_eui2=AeEKDL0hsk_frBsEg8ytor-66fZsNtesiKfp9mw216yIp8icPZb4Dfzh9a6OWjx85IO-eRSVGK6UBhSmfzRbCdFo&_nc_ohc=PBpyvPfDiBkQ7kNvgEGx4IH&_nc_zt=23&_nc_ht=scontent.fhan2-5.fna&_nc_gid=AQerMs57l17sW1EzaJ6X0uJ&oh=00_AYCb8OHhDz_hUabOQ8-E0LDQLxmz4DEH2-y1XOEDoCS3Lg&oe=6751077A"}]
 *                 journeyId: 5f8a5e7f575d7a2b9c0d47e5 
 *                 createdAt: 1633632000
 *                 updatedAt: 1633632000
 *                 commentsCount: 0
 *                 likesCount: 0
 *       404:
 *         description: Post not found
 *   patch:
 *     summary: Update a post
 *     tags: [Posts]
 *     parameters:
 *       - in: path
 *         name: postId
 *         required: true
 *         schema:
 *           type: string
 *         description: Post ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
  *               example:
 *                 userId: 5f8a5e7f575d7a2b9c0d47e5
 *                 content: "Thích cậu từ Xuân Hạ\nThích tới tận Thu Đông.\nCó một câu hỏi nhỏ\nCậu có thích tớ không?"
 *                 media: [{"type": "image", "url": "https://scontent.fhan2-5.fna.fbcdn.net/v/t39.30808-6/468719634_3825302851117569_5554540526716892179_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=aa7b47&_nc_eui2=AeEKDL0hsk_frBsEg8ytor-66fZsNtesiKfp9mw216yIp8icPZb4Dfzh9a6OWjx85IO-eRSVGK6UBhSmfzRbCdFo&_nc_ohc=PBpyvPfDiBkQ7kNvgEGx4IH&_nc_zt=23&_nc_ht=scontent.fhan2-5.fna&_nc_gid=AQerMs57l17sW1EzaJ6X0uJ&oh=00_AYCb8OHhDz_hUabOQ8-E0LDQLxmz4DEH2-y1XOEDoCS3Lg&oe=6751077A"}]
 *                 journeyId: 5f8a5e7f575d7a2b9c0d47e5
 *                 createdAt: 1633632000
 *                 updatedAt: 1633632000
 *                 commentsCount: 0
 *                 likesCount: 0
 *     responses:
 *       200:
 *         description: OK
 *         content:
 *           application/json:
 *             schema:
 *               example:
 *                 _id: 5f8a5e7f575d7a2b9c0d47e5
 *                 userId: 5f8a5e7f575d7a2b9c0d47e5
 *                 content: "Thích cậu từ Xuân Hạ\nThích tới tận Thu Đông.\nCó một câu hỏi nhỏ\nCậu có thích tớ không?"
 *                 media: [{"type": "image", "url": "https://scontent.fhan2-5.fna.fbcdn.net/v/t39.30808-6/468719634_3825302851117569_5554540526716892179_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=aa7b47&_nc_eui2=AeEKDL0hsk_frBsEg8ytor-66fZsNtesiKfp9mw216yIp8icPZb4Dfzh9a6OWjx85IO-eRSVGK6UBhSmfzRbCdFo&_nc_ohc=PBpyvPfDiBkQ7kNvgEGx4IH&_nc_zt=23&_nc_ht=scontent.fhan2-5.fna&_nc_gid=AQerMs57l17sW1EzaJ6X0uJ&oh=00_AYCb8OHhDz_hUabOQ8-E0LDQLxmz4DEH2-y1XOEDoCS3Lg&oe=6751077A"}]
 *                 journeyId: 5f8a5e7f575d7a2b9c0d47e5
 *                 createdAt: 1633632000
 *                 updatedAt: 1633632000
 *                 commentsCount: 0
 *                 likesCount: 0
 *   delete:
 *     summary: Delete a post
 *     tags: [Posts]
 *     parameters:
 *       - in: path
 *         name: postId
 *         required: true
 *         schema:
 *           type: string
 *         description: Post ID
 *     responses:
 *       204:
 *         description: No Content
 */