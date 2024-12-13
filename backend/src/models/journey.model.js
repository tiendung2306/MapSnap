const mongoose = require('mongoose');

const { Schema } = mongoose;

// Define the Journey schema
const journeySchema = new Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Users',
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
  },
  updatedAt: {
    type: Number,
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
