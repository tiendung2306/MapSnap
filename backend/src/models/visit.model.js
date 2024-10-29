const mongoose = require('mongoose');
const { toJSON } = require('./plugins');

const { Schema } = mongoose;

// Define the Picture schema
const pictureSchema = new Schema({
  link: {
    type: String,
    required: true,
  },
  created_at: {
    type: Date,
    default: Date.now,
  },
});

// Define the Visit schema
const visitSchema = new Schema({
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Users',
    required: true,
  },
  location_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Locations',
    required: true,
  },
  started_at: {
    type: Date,
    required: true,
  },
  ended_at: {
    type: Date,
    required: true,
  },
  pictures: [pictureSchema],
});

visitSchema.plugin(toJSON);

// Create the Journey model
const Visit = mongoose.model('Visit', visitSchema);

module.exports = Visit;
