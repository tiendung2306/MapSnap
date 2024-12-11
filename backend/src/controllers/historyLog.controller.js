const httpStatus = require('http-status');
const Message = require('../utils/Message');
const catchAsync = require('../utils/catchAsync');
const historyLogService = require('../services/historyLog.service');

const createHistoryLog = catchAsync(async (req, res) => {
  const requestBody = req.body;
  requestBody.userId = req.params.userId;
  const historyLog = await historyLogService.createHistoryLog(requestBody);
  res.status(httpStatus.CREATED).send({
    code: httpStatus.CREATED,
    message: Message.historyLogMsg.created,
    result: historyLog,
  });
});

const getHistoryLogs = catchAsync(async (req, res) => {
  const request = req.body;
  request.userId = req.params.userId;
  const city = await historyLogService.getHistoryLogs(request);
  res.send({ code: httpStatus.OK, message: Message.ok, result: city });
});

module.exports = {
  createHistoryLog,
  getHistoryLogs,
};
