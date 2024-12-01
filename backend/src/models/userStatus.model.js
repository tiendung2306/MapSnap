const mongoose = require('mongoose');
const { toJSON } = require('./plugins');

const { Schema } = mongoose;

// Define the Picture schema
const userStatusSchema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true,
  },
  locationId: {
    type: Schema.Types.ObjectId,
    ref: 'Location',
  },
  visitId: {
    type: Schema.Types.ObjectId,
    ref: 'Visit',
  },
  journeyId: {
    type: Schema.Types.ObjectId,
    ref: 'Journey',
  },
  timeStandStill: {
    type: Number,
    required: true,
  },
  instantSpeed: {
    type: Number,
    required: true,
  },
  longitude: {
    type: Number,
    required: true,
  },
  latitude: {
    type: Number.EPSILON,
    required: true,
  },
});

userStatusSchema.plugin(toJSON);

// Create the User Status model
const UserStatus = mongoose.model('UserStatus', userStatusSchema);

module.exports = UserStatus;