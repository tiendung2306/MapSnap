const axios = require('axios');
const config = require('../config/config');

const reverseGeocoding = async (req, res) => {
    const { lat, lng } = req.query;
    const apiKey = config.goong.apiKey;
    const response = await axios.get(`https://rsapi.goong.io/Geocode?latlng=${lat},${lng}&api_key=${apiKey}`);
    const { plus_code, results } = response.data;
    return { plus_code, results };
};

const forwardGeocoding = async (req, res) => {
    const address = req.query.address;
    const apiKey = config.goong.apiKey;
    console.log(apiKey);
    const response = await axios.get(`https://rsapi.goong.io/geocode?address=${address}&api_key=${apiKey}`);
    return response.data;
};

module.exports = {
    reverseGeocoding,
    forwardGeocoding
}