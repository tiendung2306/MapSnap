const { Picture } = require('../models'); // Đường dẫn tới file chứa model Picture

/**
 * Create a user
 * @param {Object} pictureBody
 * @returns {Promise<Picture>}
 */
const createPicture = async (pictureBody) => {
    if (await Picture.isPictureExists(pictureBody.link)) {
        throw new ApiError(httpStatus.BAD_REQUEST, 'Picture already exists');
    }
    return Picture.create(pictureBody);
};


module.exports = {
    createPicture,
}

// const newPicture = new Picture({
//     user_id: '60c72b2f9af1b8124cf74c9a', // ID giả định
//     location_id: '60c72b2f9af1b8124cf74c9b', // ID giả định
//     visit_id: '60c72b2f9af1b8124cf74c9c', // ID giả định
//     journey_id: '60c72b2f9af1b8124cf74c9d', // ID giả định
//     link: 'http://example.com/image1.jpg',
//     created_at: new Date()
// });

// newPicture.save()
//     .then((doc) => {
//         console.log('Picture saved successfully:', doc);
//     })
//     .catch((err) => {
//         console.error('Error saving picture:', err);
//     });
