const catchAsync = require('../utils/catchAsync');
const goongService = require('../services/goong.service');

const reverseGeocoding = catchAsync(async (req, res) => {
    const { plus_code, results } = await goongService.reverseGeocoding(req, res);
    res.json({ plus_code, results });
});

const forwardGeocoding = catchAsync(async (req, res) => {
    const data = await goongService.forwardGeocoding(req, res);
    res.json(data);
});

module.exports = {
    reverseGeocoding,
    forwardGeocoding
}