const httpStatus = require('http-status');
const Message = require('../utils/Message');
const catchAsync = require('../utils/catchAsync');
const journeyService = require('../services/journey.service');

const createJourney = catchAsync(async (req, res) => {
  const requestBody = req.body;
  requestBody.userId = req.params;
  const journey = await journeyService.createJourney(requestBody);
  res.status(httpStatus.CREATED).send({
    code: httpStatus.CREATED,
    message: Message.journeyMsg.created,
    result: journey,
  });
});

const getJourneysByUserId = catchAsync(async (req, res) => {
  const { userId } = req.params;
  const journeys = await journeyService.getJourneysByUserId({ userId });
  res.send({ code: httpStatus.OK, message: Message.ok, results: journeys });
});

const getJourneyByJourneyId = catchAsync(async (req, res) => {
  const { journeyId } = req.params;
  const journey = await journeyService.getJourneyByJourneyId(journeyId);
  res.send({ code: httpStatus.OK, message: Message.ok, result: journey });
});

const updateJourney = catchAsync(async (req, res) => {
  const { journeyId } = req.params;
  const requestBody = req.body;
  await journeyService.updateJourney({ journeyId, requestBody });
  res.send({
    code: httpStatus.OK,
    message: Message.journeyMsg.update,
  });
});

const deleteJourney = catchAsync(async (req, res) => {
  const { journeyId } = req.params;
  await journeyService.deleteJourney(journeyId);
  res.send({
    code: httpStatus.OK,
    message: Message.journeyMsg.delete,
  });
});

const getJourneysToday = catchAsync(async (req, res) => {
  const journeys = await journeyService.getJourneysToday(req.params.userId);
  res.send({ code: httpStatus.OK, message: Message.ok, results: journeys });
});

const getJourneysCreatedByUser = catchAsync(async (req, res) => {
  const journeys = await journeyService.getJourneysCreatedByUser(req.params.userId);
  res.send({ code: httpStatus.OK, message: Message.ok, results: journeys });
});

module.exports = {
  createJourney,
  getJourneysByUserId,
  getJourneyByJourneyId,
  updateJourney,
  deleteJourney,
  getJourneysToday,
  getJourneysCreatedByUser,
};
