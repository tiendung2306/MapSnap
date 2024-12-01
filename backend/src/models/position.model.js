const mongoose = require('mongoose');
const { toJSON } = require('./plugins');

const { Schema } = mongoose;

// Define the Position schema
const positionSchema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  createdAt: {
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
  address: {
    type: String,
  },
  country: {
    type: String,
  },
  cityId: {
    type: String,
  },
  district: {
    type: String,
  },
  homeNumber: {
    type: Number,
  },
  classify: {
    type: String,
  },
  locationId: {
    type: Schema.Types.ObjectId,
    ref: 'Location',
  },
});

positionSchema.plugin(toJSON);
// Create the Position model
const Position = mongoose.model('Position', positionSchema);

module.exports = Position;
