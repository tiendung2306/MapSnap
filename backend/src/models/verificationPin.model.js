const mongoose = require('mongoose');
const { toJSON } = require('./plugins');

const verificationPinSchema = mongoose.Schema(
  {
    pinCode: {
      type: String,
      required: true,
      validator(value) {
        if (!value.match(/\d/)) {
          throw new Error('Pin code must contain only numbers');
        }
        if (value.length !== 4) {
          throw new Error('Pin code must contain 4 numbers');
        }
      },
    },
    token: {
      type: String,
      required: true,
    },
    expires: {
      type: Date,
      required: true,
    },
    isUsed: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);
verificationPinSchema.plugin(toJSON);

const VerificationPin = mongoose.model('VerificationPin', verificationPinSchema);
module.exports = VerificationPin;
