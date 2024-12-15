const httpStatus = require('http-status');
const { User } = require('../models');
const ApiError = require('../utils/ApiError');
const { uploadAvatar } = require('../middlewares/upload');
const cloudinary = require('../config/cloudinary'); // Import Cloudinary config
const userStatusService = require('./userStatus.service');

/**
 * Create a user
 * @param {Object} userBody
 * @returns {Promise<User>}
 */
const createUser = async (userBody) => {
  if (await User.isEmailTaken(userBody.email)) {
    throw new ApiError(httpStatus.BAD_REQUEST, 'Email already taken');
  }
  const user = User.create(userBody);
  const userStatus = { userId: user._id, createdAt: Date.now() };
  await userStatusService.createUserStatus(userStatus);
  return user;
};

/**
 * Query for users
 * @param {Object} filter - Mongo filter
 * @param {Object} options - Query options
 * @param {string} [options.sortBy] - Sort option in the format: sortField:(desc|asc)
 * @param {number} [options.limit] - Maximum number of results per page (default = 10)
 * @param {number} [options.page] - Current page (default = 1)
 * @returns {Promise<QueryResult>}
 */
const queryUsers = async (filter, options) => {
  const users = await User.paginate(filter, options);
  return users;
};

/**
 * Get user by id
 * @param {ObjectId} id
 * @returns {Promise<User>}
 */
const getUserById = async (id) => {
  return User.findById(id);
};

/**
 * Get user by email
 * @param {string} email
 * @returns {Promise<User>}
 */
const getUserByEmail = async (email) => {
  return User.findOne({ email });
};

/**
 * Update user by id
 * @param {ObjectId} userId
 * @param {Object} updateBody
 * @returns {Promise<User>}
 */
const updateUserById = async (userId, updateBody) => {
  const user = await getUserById(userId);
  if (!user) {
    throw new ApiError(httpStatus.NOT_FOUND, 'User not found');
  }
  if (updateBody.email && (await User.isEmailTaken(updateBody.email, userId))) {
    throw new ApiError(httpStatus.BAD_REQUEST, 'Email already taken');
  }
  Object.assign(user, updateBody);
  await user.save();
  return user;
};

const updateUserAvatarByID = async (req, res) => {
  uploadAvatar(req, res, async (err) => {
    if (err) {
      return res.status(httpStatus.BAD_REQUEST).send({ message: 'Invalid file' });
    }
    if (!req.file) {
      return res.status(httpStatus.BAD_REQUEST).send({ message: 'No file uploaded' });
    }

    try {
      const { userId } = req.params;

      // Validate user
      const user = await getUserById(userId);
      if (!user) {
        return res.status(httpStatus.NOT_FOUND).send({ message: 'User not found' });
      }

      // Delete old avatar in cloudinary
      try {
        let result = null;
        if (user.avatar_public_id !== 'default_avatar/default_avatar')
          result = await cloudinary.uploader.destroy(user.avatar_public_id); // Xóa bằng public_id
        if (!!result && result.result !== 'ok') {
          throw new ApiError(httpStatus.INTERNAL_SERVER_ERROR, 'Failed to delete user avatar from Cloudinary');
        }
      } catch (error) {
        throw new ApiError(httpStatus.INTERNAL_SERVER_ERROR, 'Error while deleting user avatar from Cloudinary');
      }

      // Update avatar field with the path of the uploaded image
      const filePath = req.file.path;
      user.avatar = filePath;
      user.avatar_public_id = req.file.filename;
      await user.save();

      // Return the updated avatar URL
      return res.status(httpStatus.OK).send({ avatar: user.avatar });
    } catch (error) {
      return res.status(httpStatus.INTERNAL_SERVER_ERROR).send({ message: 'Server Error' });
    }
  });
};

/**
 * Delete user by id
 * @param {ObjectId} userId
 * @returns {Promise<User>}
 */
const deleteUserById = async (userId) => {
  const user = await getUserById(userId);
  if (!user) {
    throw new ApiError(httpStatus.NOT_FOUND, 'User not found');
  }
  await user.remove();
  return user;
};

module.exports = {
  createUser,
  queryUsers,
  getUserById,
  getUserByEmail,
  updateUserById,
  deleteUserById,
  updateUserAvatarByID,
};
