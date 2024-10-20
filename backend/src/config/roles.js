const allRoles = {
  user: ['userRights'],
  admin: ['adminRights'],
};

const roles = Object.keys(allRoles);
const roleRights = new Map(Object.entries(allRoles));

module.exports = {
  roles,
  roleRights,
};
