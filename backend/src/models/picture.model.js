const mongoose = require('mongoose');
const { toJSON } = require('./plugins');

const { Schema } = mongoose;

// Define the Picture schema
const pictureSchema = new Schema({
  user_id: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true,
  },
  location_id: {
    type: Schema.Types.ObjectId,
    ref: 'Location',
    required: true,
  },
  visit_id: {
    type: Schema.Types.ObjectId,
    ref: 'Visit',
    required: true,
  },
  journey_id: {
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
