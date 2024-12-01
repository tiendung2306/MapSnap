const likesService = require('../services/likes.service');
const httpStatus = require('http-status');
const ApiError = require('../utils/ApiError');
const catchAsync = require('../utils/catchAsync');

const addLike = catchAsync(async (req, res) => {
    const like = await likesService.addLike(req.body);
    res.status(httpStatus.CREATED).send(like);
});

const removeLike = catchAsync(async (req, res) => {
    await likesService.removeLike(req.params.likeId);
    res.sendStatus(httpStatus.NO_CONTENT);
});

const getLikeById = catchAsync(async (req, res) => {
    const like = await likesService.getLikeById(req.params.likeId);
    if (!like) {
        throw new ApiError(httpStatus.NOT_FOUND, 'Like not found');
    }
    res.status(httpStatus.OK).send(like);
});

const getLikesByPostId = catchAsync(async (req, res) => {
    const likes = await likesService.getLikesByPostId(req.params.postId);
    res.status(httpStatus.OK).send(likes);
});

module.exports = {
    addLike,
    removeLike,
    getLikeById,
    getLikesByPostId,
}