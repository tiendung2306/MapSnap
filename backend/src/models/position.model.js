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
  timeAt: {
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
  altitude: {
    type: Number,
    required: true,
  },
  locationId: {
    type: Schema.Types.ObjectId,
    ref: 'Location',
    required: true,
  },
});

positionSchema.plugin(toJSON);
// Create the Position model
const Position = mongoose.model('Position', positionSchema);

module.exports = Position;
