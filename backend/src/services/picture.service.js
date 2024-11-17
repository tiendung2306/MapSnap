const httpStatus = require('http-status');
const ApiError = require('../utils/ApiError');
const { Picture } = require('../models'); // Đường dẫn tới file chứa model Picture
const { updatePicture } = require('../middlewares/upload');

/**
 * Create a user
 * @param {Object} pictureBody
 * @returns {Promise<Picture>}
 */
const createPicture = async (req, res) => {
  updatePicture(req, res, async (err) => {
    if (err) {
      return res.status(httpStatus.BAD_REQUEST).send({ message: 'Invalid file' });
    }
    if (!req.files) {
      return res.status(httpStatus.BAD_REQUEST).send({ message: 'No file uploaded' });
    }

    try {
      const { userId, locationId, visitId, journeyId, createdAt } = req.body;

      const pictures = await Promise.all(
        req.files.map((file) => {
          const filePath = `/uploads/pictures/${file.filename}`;
          const picture = Picture.create({
            userId,
            locationId,
            visitId,
            journeyId,
            link: filePath,
            createdAt,
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
  await picture.remove();
  return picture;
};

module.exports = {
  createPicture,
  getPictureById,
  getPictures,
  deletePictureById,
};

// const newPicture = new Picture({
//     user_id: '60c72b2f9af1b8124cf74c9a', // ID giả định
//     location_id: '60c72b2f9af1b8124cf74c9b', // ID giả định
//     visit_id: '60c72b2f9af1b8124cf74c9c', // ID giả định
//     journey_id: '60c72b2f9af1b8124cf74c9d', // ID giả định
//     link: 'http://example.com/image1.jpg',
//     createdAt: new Date()
// });

// newPicture.save()
//     .then((doc) => {
//         console.log('Picture saved successfully:', doc);
//     })
//     .catch((err) => {
//         console.error('Error saving picture:', err);
//     });
