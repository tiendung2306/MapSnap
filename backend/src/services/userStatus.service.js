const httpStatus = require('http-status');
// const mongoose = require('mongoose');
const _ = require('lodash');
const UserStatus = require('../models/userStatus.model');
const Position = require('../models/position.model');
const Location = require('../models/position.model');
const Visit = require('../models/visit.model');
const Journey = require('../models/journey.model');
const journeyService = require('./journey.service');
const visitService = require('./visit.service');
const locationService = require('./location.service');
const ApiError = require('../utils/ApiError');
const Message = require('../utils/Message');
// const UserModel = require('../models/user.model');

const createUserStatus = async (userStatusBody) => {
  const userStatus = await UserStatus.findOne(userStatusBody);
  if (userStatus) {
    throw new ApiError(httpStatus.BAD_REQUEST, Message.userStatusMsg.nameExisted);
  }
  const userStatusModel = await UserStatus.create(userStatusBody);
  return userStatusModel;
};

const getUserStatus = async (userId) => {
  const userStatus = await UserStatus.findOne({ userId });
  return userStatus;
};

const updateUserStatus = async ({ userStatusId, requestBody }) => {
  const userStatus = await UserStatus.findOneAndUpdate({ userStatusId }, requestBody, { new: true });
  return userStatus;
};

const _getDistance = (longitudeStart, latitudeStart, longitudeDes, latitudeDes) => {
  const latitudeStartKm = latitudeStart * 111.57;
  const longitudeStartKm = longitudeStart * 111.32 * Math.cos(latitudeStartKm);
  const latitudeDesKm = latitudeDes * 111.57;
  const longitudeDesKm = longitudeDes * 111.32 * Math.cos(latitudeDesKm);
  return Math.sqrt(
    (longitudeDesKm - longitudeStartKm) * (longitudeDesKm - longitudeStartKm) +
      (latitudeDesKm - latitudeStartKm) * (latitudeDesKm - latitudeStartKm)
  );
};

const periodicallyAutomaticFeature = async (userId) => {
  const userStatus = await getUserStatus(userId);
  const userStatusId = _.get(userStatus, '_id');
  const position = await Position.findOne({ userId }).sort({ createdAt: -1 });
  if (!_.get(userStatus, 'journeyId')) {
    // Người dùng đang không ở bất kỳ Journey nào
    const location = await Location.findById(_.get(userStatus, 'locationId'));

    if (_.get(location, 'categoryName') === 'Home') {
      // Nếu người dùng vừa rời đi, và địa điểm gần nhất là Home thì bắt đầu một Journey mới
      const newJourney = {
        userId,
        title: 'Daily Routine',
        startedAt: Date.now(),
        updatedAt: Date.now(),
        status: 'enabled',
        updatedByUser: false,
        isAutomaticAdded: true,
      };
      const journey = await journeyService.createJourney(newJourney);
      const newUserStatus = await updateUserStatus({
        userStatusId,
        requestBody: {
          journeyId: journey._id,
          locationId: location._id,
          longitude: position.longitude,
          latitude: position.latitude,
        },
      });
      return newUserStatus;
    }
  } else {
    // Người dùng đang ở trong một Journey
    const journey = await Journey.findById(_.get(userStatus, 'journeyId'));

    if (_.get(userStatus, 'visitId')) {
      // Người dùng đang ở trong một Visit

      if (_getDistance(userStatus.longitude, userStatus.latitude, position.longitude, position.latitude) < 0.05) {
        // Nếu vị trí hiện tại so với thời điểm gần nhất được lưu không vượt quá 50m, người dùng vẫn đang ở trong Visit ấy
        const newUserStatus = await updateUserStatus({
          userStatusId,
          requestBody: { longitude: position.longitude, latitude: position.latitude },
        });
        return newUserStatus;
      }

      const visit = await Visit.findOne({ userId, status: 'enabled' }).sort({ createdAt: -1 });

      // Không xử lý với trường hợp Journey hiện tại chưa có Visit
      if (_.get(visit, 'journeyId') === journey._id) {
        // Xử lý trường hợp người dùng vừa rời khỏi Visit
        await visitService.updateVisit({ visitId: visit._id, requestBody: { endedAt: Date.now() } });
        const newUserStatus = await updateUserStatus({
          userStatusId,
          requestBody: { visitId: undefined, longitude: position.longitude, latitude: position.latitude },
        });
        return newUserStatus;
      }
    } else {
      // Người dùng đang không trong một Visit
      // eslint-disable-next-line no-lonely-if
      if (_getDistance(userStatus.longitude, userStatus.latitude, position.longitude, position.latitude) < 0.05) {
        if (_.get(position, 'locationId')) {
          // Điểm thăm tiếp theo đã được xác định Location
          const location = await Location.findById(_.get(position, 'locationId'));
          if (_.get(location, 'categoryName') === 'Home') {
            // Kết thúc Journey Daily Routine khi điểm thăm tiếp theo là nhà
            await journeyService.updateJourney({ journey, requestBody: { endedAt: Date.now() } });
            const newUserStatus = await updateUserStatus({
              userStatusId,
              requestBody: { journeyId: undefined, longitude: position.longitude, latitude: position.latitude },
            });
            return newUserStatus;
          }
          // Xác định đây là điểm thăm mới
          const newVisit = {
            userId,
            locationId: _.get(position, 'locationId'),
            journeyId: journey._id,
            title: 'Daily Routine',
            startedAt: Date.now(),
            updatedAt: Date.now(),
            status: 'enabled',
            updatedByUser: false,
            isAutomaticAdded: true,
          };
          await visitService.createVisit(newVisit);
        } else {
          // Điểm thăm tiếp theo chưa xác định Location, tạo Location mới
          const newLocation = {
            userId,
            cityId: _.get(position, 'cityId'),
            country: _.get(position, 'country'),
            district: _.get(position, 'district'),
            homeNumber: _.get(position, 'homeNumber'),
            classify: _.get(position, 'classify'),
            longitude: _.get(position, 'longitude'),
            latitude: _.get(position, 'latitude'),
            address: _.get(position, 'address'),
            title: _.get(position, 'address'),
            visitedTime: 1,
            status: 'enabled',
            createdAt: Date.now(),
            updatedByUser: false,
            isAutomaticAdded: true,
          };
          const location = await locationService.createLocation(newLocation);
          const newVisit = {
            userId,
            locationId: _.get(newLocation, '_id'),
            journeyId: journey._id,
            title: 'Daily Routine',
            startedAt: Date.now(),
            updatedAt: Date.now(),
            status: 'enabled',
            updatedByUser: false,
            isAutomaticAdded: true,
          };
          const visit = await visitService.createVisit(newVisit);
          const newUserStatus = await updateUserStatus({
            userStatusId,
            requestBody: {
              locationId: location._id,
              visitId: visit._id,
              longitude: position.longitude,
              latitude: position.latitude,
            },
          });
          return newUserStatus;
        }
      }
    }
  }
  const newUserStatus = await updateUserStatus({
    userStatusId,
    requestBody: {
      longitude: position.longitude,
      latitude: position.latitude,
    },
  });
  return newUserStatus;
};

module.exports = {
  createUserStatus,
  getUserStatus,
  updateUserStatus,
  periodicallyAutomaticFeature,
};
