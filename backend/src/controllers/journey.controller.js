const httpStatus = require('http-status');
const Message = require('../utils/Message');
const catchAsync = require('../utils/catchAsync');
const journeyService = require('../services/journey.service');

const createJourney = catchAsync(async (req, res) => {
  const requestBody = req.body;
  requestBody.userId = req.params.userId;
  const journey = await journeyService.createJourney(requestBody);
  res.status(httpStatus.CREATED).send({
    code: httpStatus.CREATED,
    message: Message.journeyMsg.created,
    result: journey,
  });
});

const getJourneysByUserId = catchAsync(async (req, res) => {
  const journeys = await journeyService.getJourneysByUserId(req.params.userId);
  res.send({ code: httpStatus.OK, message: Message.ok, results: journeys });
});

const getJourneyByJourneyId = catchAsync(async (req, res) => {
  const journey = await journeyService.getJourneyByJourneyId(req.params.journeyId);
  res.send({ code: httpStatus.OK, message: Message.ok, result: journey });
});

const updateJourney = catchAsync(async (req, res) => {
  const { journeyId } = req.params;
  const requestBody = req.body;
  const journey = await journeyService.updateJourney({ journeyId, requestBody });
  res.send({
    code: httpStatus.OK,
    message: Message.journeyMsg.updated,
    result: journey,
  });
});

const deleteJourney = catchAsync(async (req, res) => {
  await journeyService.deleteJourney(req.params.journeyId);
  res.send({
    code: httpStatus.OK,
    message: Message.journeyMsg.deleted,
  });
});

const getJourneysToday = catchAsync(async (req, res) => {
  const journeys = await journeyService.getJourneysToday(req.params.userId);
  res.send({ code: httpStatus.OK, message: Message.ok, results: journeys });
});

module.exports = {
  createJourney,
  getJourneysByUserId,
  getJourneyByJourneyId,
  updateJourney,
  deleteJourney,
  getJourneysToday,
};
