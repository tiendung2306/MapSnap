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
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Users',
    required: true,
  },
  cityId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'City',
  },
  categoryId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'LocationCategory',
  },
  categoryName: {
    type: String,
  },
  address: {
    type: String,
  },
  country: {
    type: String,
  },
  district: {
    type: String,
  },
  homeNumber: {
    type: String,
  },
  classify: {
    type: String,
  },
  title: {
    type: String,
    required: true,
  },
  visitedTime: {
    type: Number,
    required: true,
  },
  longitude: {
    type: Number,
    required: true,
  },
  latitude: {
    type: Number,
    required: true,
  },
  createdAt: {
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

locationSchema.plugin(toJSON);
// Create the Location model
const Location = mongoose.model('Location', locationSchema);

module.exports = Location;
