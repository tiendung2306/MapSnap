// const mongoose = require('mongoose');
// const _ = require('lodash');
const HistoryLog = require('../models/historyLog.model');
// const UserModel = require('../models/user.model');

const createHistoryLog = async (historyLogBody) => {
  const historyLog = await HistoryLog.create(historyLogBody);
  return historyLog;
};

const getHistoryLogs = async (historyLogBody) => {
  const { userId, searchText, status = 'enabled' } = historyLogBody;
  const filter = { userId, status };
  if (searchText) {
    filter.name = { $regex: searchText, $options: 'i' };
  }
  const historyLog = await HistoryLog.find(filter);
  return historyLog;
};

module.exports = {
  createHistoryLog,
  getHistoryLogs,
};
