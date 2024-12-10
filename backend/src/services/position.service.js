const httpStatus = require('http-status');
// const mongoose = require('mongoose');
const _ = require('lodash');
const Position = require('../models/position.model');
const Location = require('../models/location.model');
const { createLocation } = require('./location.service');
const ApiError = require('../utils/ApiError');
const Message = require('../utils/Message');
// const UserModel = require('../models/user.model');

const createPosition = async (requestBody) => {
  const existedPosition = await Position.findOne(requestBody);
  if (existedPosition) {
    throw new ApiError(httpStatus.BAD_REQUEST, Message.positionMsg.nameExisted);
  }
  const position = await Position.create(requestBody);
  return position;
};

const getPosition = async (positionBody) => {
  const { userId, locationId, from, to } = positionBody;
  const filter = { userId };
  if (locationId) filter.locationId = locationId;
  if (from || to) {
    filter.createdAt = {};
    if (from) filter.createdAt.$gte = from;
    if (to) filter.createdAt.$lte = to;
  }
  const positions = await Position.find(filter);
  return positions;
};

const deletePosition = async (positionId) => {
  const position = await Position.findByIdAndDelete(positionId);
  return position;
};

const _getDistance = (longitudeStart, latitudeStart, longitudeDes, latitudeDes) => {
  return (
    (longitudeDes - longitudeStart) * (longitudeDes - longitudeStart) +
    (latitudeDes - latitudeStart) * (latitudeDes - latitudeStart)
  );
};

const getNearestPosition = async (positionBody) => {
  const { userId, longitude, latitude, from, to, locationId } = positionBody;
  if (!longitude || !latitude) {
    throw new ApiError(httpStatus.BAD_REQUEST, Message.positionMsg.missingCoordinates);
  }
  const filter = { userId };
  if (locationId) filter.locationId = locationId;
  if (from || to) {
    filter.createdAt = {};
    if (from) filter.createdAt.$gte = from;
    if (to) filter.createdAt.$lte = to;
  }
  const positions = await Position.find(filter);
  let nearestPosition;
  _.forEach(positions, (position) => {
    if (
      !nearestPosition ||
      _getDistance(longitude, latitude, nearestPosition.longitude, nearestPosition.latitude) >
        _getDistance(longitude, latitude, position.longitude, position.latitude)
    )
      nearestPosition = position;
  });
  return nearestPosition;
};

const _getNearestLocation = async (positionBody) => {
  const { userId, longitude, latitude } = positionBody;
  if (!longitude || !latitude) {
    throw new ApiError(httpStatus.BAD_REQUEST, Message.locationMsg.missingCoordinates);
  }
  const filter = { userId };
  const locations = await Location.find(filter);
  let nearestLocation;
  _.forEach(locations, (location) => {
    if (
      !nearestLocation ||
      _getDistance(longitude, latitude, nearestLocation.longitude, nearestLocation.latitude) >
        _getDistance(longitude, latitude, location.longitude, location.latitude)
    )
      nearestLocation = location;
  });
  return nearestLocation;
};

const getLocationFromPosition = async (positionBody) => {
  // eslint-disable-next-line no-unused-vars
  const { userId, longitude, latitude, country, cityId, district, homeNumber, address } = positionBody;
  const filter = { userId, longitude, latitude };
  const nearestLocation = _getNearestLocation(filter);
  if (nearestLocation.country !== country || nearestLocation.cityId !== cityId || nearestLocation.district !== district) {
    const locationBody = positionBody;
    locationBody.visitedTime = 1;
    locationBody.status = 'enabled';
    locationBody.isAutomaticAdded = true;
    locationBody.updatedByUser = false;
    locationBody.title = address;
    const location = await createLocation(locationBody);
    return location;
  }
  return nearestLocation;
};

module.exports = {
  createPosition,
  getPosition,
  deletePosition,
  getNearestPosition,
  getLocationFromPosition,
};
