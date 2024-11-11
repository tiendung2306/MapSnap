const mongoose = require('mongoose');
const { toJSON } = require('./plugins');

const { Schema } = mongoose;

// Define the Picture schema
const pictureSchema = new Schema({
  link: {
    type: String,
    required: true,
  },
  createdAt: {
    type: Number,
    required: true,
  },
});

// Define the Location schema
const locationSchema = new Schema({
  locationName: {
    type: String,
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  role: {
    type: String,
    required: true,
  },
  visitedTime: {
    type: Number,
    required: true,
  },
  createdAt: {
    type: Number,
    required: true,
  },
  status: {
    type: Boolean,
    required: true,
  },
  updatedByUser: {
    type: Boolean,
    required: true,
  },
  isAutomaticAdded: {
    type: Boolean,
    required: true,
  },
  pictures: [pictureSchema],
});

locationSchema.plugin(toJSON);
// Create the Location model
const Location = mongoose.model('Location', locationSchema);

module.exports = Location;
