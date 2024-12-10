// const mongoose = require('mongoose');
// const _ = require('lodash');
const HistoryLog = require('../models/historyLog.model');
// const UserModel = require('../models/user.model');

const createHistoryLog = async (historyLogBody) => {
  const historyLog = await HistoryLog.create(historyLogBody);
  return historyLog;
};

const getHistoryLogs = async (visitBody) => {
  const { userId, isAutomaticAdded, updatedByUser, from, to } = visitBody;
  const filter = { userId };
  if (isAutomaticAdded !== undefined) filter.isAutomaticAdded = isAutomaticAdded;
  if (updatedByUser !== undefined) filter.updatedByUser = updatedByUser;
  if (from || to) {
    filter.createdAt = {};
    if (from) filter.createdAt.$gte = from;
    if (to) filter.createdAt.$lte = to;
  }
  const historyLog = await HistoryLog.find(filter).sort({ createdAt: -1 });
  return historyLog;
};

module.exports = {
  createHistoryLog,
  getHistoryLogs,
};
