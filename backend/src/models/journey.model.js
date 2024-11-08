const mongoose = require('mongoose');

const { Schema } = mongoose;

// Define the Journey schema
const journeySchema = new Schema({
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Users',
    required: true,
  },
  trip_id: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Trip',
    },
  ],
  title: {
    type: String,
  },
  started_at: {
    type: Number,
    required: true,
  },
  ended_at: {
    type: Number,
    required: true,
  },
  updated_at: {
    type: Number,
    required: true,
  },
  status: {
    type: Boolean,
    required: true,
  },
});

// Create the Journey model
const Journey = mongoose.model('Journey', journeySchema);

module.exports = Journey;
