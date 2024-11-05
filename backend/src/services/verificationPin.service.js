const { VerificationPin } = require('../models');

const generatePin = () => {
  return Math.floor(1000 + Math.random() * 9000);
};

const savePin = async (pinCode, token, expires, isUsed = false) => {
  // eslint-disable-next-line no-useless-catch
  try {
    const pinDoc = await VerificationPin.create({
      pinCode,
      token,
      expires: expires.toDate(),
      isUsed,
    });
    return pinDoc;
  } catch (err) {
    throw err;
  }
};

const verifyPin = async (pinCode, token) => {
  const pinDoc = await VerificationPin.findOne({ token, isUsed: false });
  if (!pinDoc) {
    throw new Error('PIN not found');
  }
  if (pinDoc.pinCode !== pinCode) {
    throw new Error('PIN does not match');
  }
  if (pinDoc.expires < Date.now()) {
    throw new Error('PIN has expired');
  }
  pinDoc.isUsed = true;
  await pinDoc.save();
  return pinDoc;
};

module.exports = {
  generatePin,
  savePin,
  verifyPin,
};
