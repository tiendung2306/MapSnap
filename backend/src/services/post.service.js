const Post = require('../models/post.model');

const createPost = async (postBody) => {
    const post = Post.create(postBody);
    return post;
}

const getPostById = async (postId) => {
    return Post.findById(postId);
}

const queryPost = async (filter, options) => {
    const posts = Post.paginate(filter, options);
    return posts;
}

const updatePostById = async (postId, updateBody) => {
    const post = await getPostById(postId);
    if (!post) {
        throw new Error('Post not found');
    }
    Object.assign(post, updateBody);
    await post.save();
    return post;
}

const deletePost = async (postId) => {
    const post = await getPostById(postId);
    if (!post) {
        throw new Error('Post not found');
    }
    await post.remove();
    return post;
}

module.exports = {
    createPost,
    getPostById,
    queryPost,
    updatePostById,
    deletePost,
}