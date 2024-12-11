const mongoose = require('mongoose');

const { Schema } = mongoose;

// Define the HistoryLog schema
const historyLogSchema = new Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Users',
    required: true,
  },
  activityType: {
    type: String,
    required: true,
  },
  modelImpact: {
    type: String,
    required: true,
  },
  objectIdImpact: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
  },
  createdAt: {
    type: Number,
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

// Create the HistoryLog model
const HistoryLog = mongoose.model('HistoryLog', historyLogSchema);

module.exports = HistoryLog;
