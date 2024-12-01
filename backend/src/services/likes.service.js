const likesModel = require('../models/likes.model');
const postService = require('./post.service');

const addLike = async (likeBody) => {
    const like = likesModel.create(likeBody);
    const post = await postService.getPostById(likeBody.postId);
    post.addLike();
    return like;
}

const getLikeById = async (likeId) => {
    return likesModel.findById(likeId);
}

const removeLike = async (likeId) => {
    const like = await getLikeById(likeId);
    if (!like) {
        throw new Error('Like not found');
    }
    await like.remove();
    const post = await postService.getPostById(like.postId);
    post.removeLike();
    return like;
}

const getLikesByPostId = async (postId) => {
    const post = await postService.getPostById(postId);
    if (!post) {
        throw new Error('Post not found');
    }
    const likes = await likesModel.find({ postId: postId });
    return { "likesCount": post.likesCount, "likes": likes };
}

module.exports = {
    addLike,
    getLikeById,
    removeLike,
    getLikesByPostId,
}