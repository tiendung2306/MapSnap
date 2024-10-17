const mongoose = require('mongoose');
const { toJSON } = require('./plugins');
const Schema = mongoose.Schema;

// Define the Location schema
const locationSchema = new Schema({
    location_name: {
        type: String,
        required: true
    },
    role: {
        type: String,
        required: true
    },
    visited_time: {
        type: Number,
        required: true
    }
});

locationSchema.plugin(toJSON);
// Create the Location model
const Location = mongoose.model('Location', locationSchema);

module.exports = Location;
