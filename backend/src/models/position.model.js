const mongoose = require('mongoose');
const { toJSON } = require('./plugins');

const { Schema } = mongoose;

// Define the Position schema
const positionSchema = new Schema({
  user_id: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  time_at: {
    type: Number,
    required: true,
  },
  coordinate_x: {
    type: Number,
    required: true,
  },
  coordinate_y: {
    type: Number,
    required: true,
  },
  location_id: {
    type: Schema.Types.ObjectId,
    ref: 'Location',
    required: true,
  },
});

positionSchema.plugin(toJSON);
// Create the Position model
const Position = mongoose.model('Position', positionSchema);

module.exports = Position;
