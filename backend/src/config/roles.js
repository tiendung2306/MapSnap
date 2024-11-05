const allRoles = {
  user: ['userRights'],
  admin: ['adminRights', 'manageUser', 'getUser'],
};

const roles = Object.keys(allRoles);
const roleRights = new Map(Object.entries(allRoles));

module.exports = {
  roles,
  roleRights,
};
