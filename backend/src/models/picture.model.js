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
  JourneyId: {
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

// Create the Picture model
const Picture = mongoose.model('Picture', pictureSchema);

module.exports = Picture;
