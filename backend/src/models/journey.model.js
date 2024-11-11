const mongoose = require('mongoose');

const { Schema } = mongoose;

// Define the Journey schema
const journeySchema = new Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Users',
    required: true,
  },
  tripId: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Trip',
    },
  ],
  title: {
    type: String,
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
});

// Create the Journey model
const Journey = mongoose.model('Journey', journeySchema);

module.exports = Journey;
