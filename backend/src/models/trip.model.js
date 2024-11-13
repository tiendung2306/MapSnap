const mongoose = require('mongoose');

const { Schema } = mongoose;

// Define the Trip schema
const tripSchema = new Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Users',
    required: true,
  },
  journeyId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Journey',
    required: true,
  },
  visitIds: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Visit',
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
    default: Date.now,
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
});

// Create the Trip model
const Trip = mongoose.model('Trip', tripSchema);

module.exports = Trip;
