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

// Define the Visit schema
const visitSchema = new Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Users',
    required: true,
  },
  journeyId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Journeys',
    required: true,
  },
  locationId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Locations',
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  startedAt: {
    type: Number,
    required: true,
  },
  endedAt: {
    type: Number,
    required: true,
  },
  updatedAt: {
    type: Number,
    required: true,
  },
  status: {
    type: String,
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

visitSchema.plugin(toJSON);

// Create the Visit model
const Visit = mongoose.model('Visit', visitSchema);

module.exports = Visit;
