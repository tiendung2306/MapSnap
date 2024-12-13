const httpStatus = require('http-status');
const Message = require('../utils/Message');
const catchAsync = require('../utils/catchAsync');
const locationService = require('../services/location.service');
const goongService = require('../services/goong.service');
const cityService = require('../services/city.service');

const createLocation = catchAsync(async (req, res) => {
  const requestBody = req.body;
  requestBody.userId = req.params.userId;
  const location = await locationService.createLocation(requestBody);
  res.status(httpStatus.CREATED).send({
    code: httpStatus.CREATED,
    message: Message.locationMsg.created,
    result: location,
  });
});

const getLocation = catchAsync(async (req, res) => {
  const request = req.body;
  request.userId = req.params.userId;
  const location = await locationService.getLocation(request);
  res.send({ code: httpStatus.OK, message: Message.ok, result: location });
});

const getLocationByLocationId = catchAsync(async (req, res) => {
  const location = await locationService.getLocationByLocationId(req.params.locationId);
  res.send({ code: httpStatus.OK, message: Message.ok, result: location });
});

const updateLocation = catchAsync(async (req, res) => {
  const { locationId } = req.params;
  const requestBody = req.body;
  await locationService.updateLocation({ locationId, requestBody });
  res.send({
    code: httpStatus.OK,
    message: Message.locationMsg.updated,
  });
});

const deleteLocation = catchAsync(async (req, res) => {
  await locationService.deleteLocation(req.params.locationId);
  res.send({
    code: httpStatus.OK,
    message: Message.locationMsg.deleted,
  });
});

const deleteHardLocation = catchAsync(async (req, res) => {
  await locationService.deleteHardLocation(req.params.locationId);
  res.send({
    code: httpStatus.OK,
    message: Message.locationMsg.deleted,
  });
});

const reverseGeocoding = catchAsync(async (req, res) => {
  const { results } = await goongService.reverseGeocoding(req, res);
  // console.log(results);
  const address = results[0].formatted_address;
  const country = "Việt Nam";
  const district = results[0].compound.district;
  const classify = results[0].types[0];
  const homeNumber = results[0].address_components[0].long_name + (results[0].address_components[1].long_name !== results[0].compound.commune ? ', ' + results[0].address_components[1].long_name : '');
  const commune = results[0].compound.commune;
  const province = results[0].compound.province;
  const cities = await cityService.getCities({ userId: req.query.userId, searchText: province });
  const cityId = cities[0]._id;
  const location = {
    address,
    country,
    district,
    classify,
    homeNumber,
    commune,
    province,
    cityId,
  };
  // console.log(location);
  res.json(location);
});

const getClosestLocation = catchAsync(async (req, res) => {
  const { lat, lng } = req.query;
  const location = await locationService.getClosestLocation({ lat, lng });
  res.send({ code: httpStatus.OK, message: Message.ok, result: location });
});

module.exports = {
  createLocation,
  getLocation,
  getLocationByLocationId,
  updateLocation,
  deleteLocation,
  deleteHardLocation,
  reverseGeocoding,
  getClosestLocation,
};
