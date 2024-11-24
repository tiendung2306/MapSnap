const mongoose = require('mongoose');
const { toJSON } = require('./plugins');

const { Schema } = mongoose;

// Define the Location Category schema
const locationCategorySchema = new Schema({
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
  title: {
    type: String,
  },
  status: {
    type: String,
    required: true,
  },
});

locationCategorySchema.plugin(toJSON);
// Create the Location Category model
const LocationCategory = mongoose.model('LocationCategory', locationCategorySchema);

module.exports = LocationCategory;
