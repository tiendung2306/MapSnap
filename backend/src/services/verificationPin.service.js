const { VerificationPin } = require('../models');

const generatePin = () => {
    return Math.floor(1000 + Math.random() * 9000);
}

const savePin = async (pinCode, token, expires, isUsed = false) => {
    try {
        const pinDoc = await VerificationPin.create({
            pinCode,
            token,
            expires: expires.toDate(),
            isUsed,
        });
        return pinDoc;
    } catch (err) {
        console.error("Error saving PIN:", err);
        throw err;
    }
};

const verifyPin = async (pinCode, token) => {
    const pinDoc = await VerificationPin.findOne({ token: token, isUsed: false });
    if (!pinDoc) {
        throw new Error("PIN not found");
    }
    if (pinDoc.pinCode !== pinCode) {
        throw new Error("PIN does not match");
    }
    if (pinDoc.expires < Date.now()) {
        throw new Error("PIN has expired");
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