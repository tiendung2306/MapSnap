const mongoose = require('mongoose');
const { toJSON } = require('./plugins');

const { Schema } = mongoose;

// Define the Picture schema
const pictureSchema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true,
  },
  locationId: {
    type: Schema.Types.ObjectId,
    ref: 'Location',
    required: true,
  },
  visitId: {
    type: Schema.Types.ObjectId,
    ref: 'Visit',
    required: true,
  },
  journeyId: {
    type: Schema.Types.ObjectId,
    ref: 'Journey',
    required: true,
  },
  link: {
    type: String,
    required: true,
  },
  createdAt: {
    type: Number,
    required: true,
  },
});

pictureSchema.plugin(toJSON);

/**
 * check if picture is already exist
 */
pictureSchema.statics.isPictureExists = async function (link) {
  // eslint-disable-next-line no-useless-catch
  try {
    const picture = await this.findOne({ link });
    return picture !== null;
  } catch (error) {
    throw error;
  }
};
// Create the Picture model
const Picture = mongoose.model('Picture', pictureSchema);

module.exports = Picture;
