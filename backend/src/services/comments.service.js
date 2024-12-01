const commentModel = require('../models/comments.model');

const createComment = async (comment) => {
    return await commentModel.create(comment);
}

const getCommentById = async (commentId) => {
    return await commentModel.findById(commentId);
}

const getCommentsByPostId = async (postId) => {
    comments = await commentModel.find({ postId });
    return comments;
}

const updateCommentById = async (commentId, commentBody) => {
    const comment = await getCommentById(commentId);
    if (!comment) {
        throw new Error('Comment not found');
    }
    Object.assign(comment, commentBody);
    return await comment.save();
}

const deleteCommentById = async (commentId) => {
    const comment = await getCommentById(commentId);
    if (!comment) {
        throw new Error('Comment not found');
    }
    await comment.remove();
}

module.exports = {
    createComment,
    getCommentById,
    getCommentsByPostId,
    updateCommentById,
    deleteCommentById,
}