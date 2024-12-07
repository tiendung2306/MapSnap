const httpStatus = require('http-status');
const ApiError = require('../utils/ApiError');
const { Picture } = require('../models'); // Đường dẫn tới file chứa model Picture
const { uploadPicture } = require('../middlewares/upload');
const cloudinary = require('../config/cloudinary'); // Import Cloudinary config

/**
 * Create a user
 * @param {Object} pictureBody
 * @returns {Promise<Picture>}
 */
const createPicture = async (req, res) => {
  uploadPicture(req, res, async (err) => {
    if (err) {
      console.log(err);
      return res.status(httpStatus.BAD_REQUEST).send({ message: err.message });
    }
    if (!req.files) {
      return res.status(httpStatus.BAD_REQUEST).send({ message: 'No file uploaded' });
    }

    try {
      const { userId, locationId, visitId, journeyId, capturedAt } = req.body;

      const pictures = await Promise.all(
        req.files.map((file) => {
          const filePath = file.path;
          const picture = Picture.create({
            userId,
            locationId,
            visitId,
            journeyId,
            link: filePath,
            capturedAt,
            public_id: file.filename,
          });
          return picture;
        })
      );
      return res.status(httpStatus.OK).send(pictures);
    } catch (error) {
      return res.status(httpStatus.INTERNAL_SERVER_ERROR).send({ message: 'Server Error' });
    }
  });
};

const getPictureById = async (id) => {
  return Picture.findById(id);
};

// eslint-disable-next-line no-unused-vars
const getPictures = async (req, res) => {
  return Picture.find(req.query);
};

const deletePictureById = async (id) => {
  const picture = await getPictureById(id);
  if (!picture) throw new ApiError(httpStatus.NOT_FOUND, 'Picture Not Found!');

  // Xóa ảnh từ Cloudinary
  try {
    const result = await cloudinary.uploader.destroy(picture.public_id); // Xóa bằng public_id
    if (result.result !== 'ok') {
      throw new ApiError(httpStatus.INTERNAL_SERVER_ERROR, 'Failed to delete picture from Cloudinary');
    }
  } catch (error) {
    throw new ApiError(httpStatus.INTERNAL_SERVER_ERROR, 'Error while deleting picture from Cloudinary');
  }
  await picture.remove();
  return picture;
};

module.exports = {
  createPicture,
  getPictureById,
  getPictures,
  deletePictureById,
};
