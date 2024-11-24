const mongoose = require('mongoose');
const { toJSON } = require('./plugins');

const { Schema } = mongoose;

// Define the City schema
const citySchema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  createdAt: {
    type: Number,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  visitedTime: {
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

citySchema.plugin(toJSON);
// Create the City model
const City = mongoose.model('City', citySchema);

module.exports = City;
