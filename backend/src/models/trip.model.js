const mongoose = require('mongoose');

const { Schema } = mongoose;

// Define the Trip schema
const tripSchema = new Schema({
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Users',
    required: true,
  },
  journey_id: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
  },
  title: {
    type: String,
  },
  started_at: {
    type: Date,
    required: true,
  },
  ended_at: {
    type: Date,
    required: true,
  },
  updated_at: {
    type: Date,
    default: Date.now,
  },
  status: {
    type: Boolean,
    required: true,
  },
});

// Create the Trip model
const Trip = mongoose.model('Trip', tripSchema);

module.exports = Trip;
