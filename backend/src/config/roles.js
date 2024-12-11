const allRoles = {
  user: ['userRights', 'manageUser', 'getUser'],
  admin: ['adminRights', 'manageUser', 'getUser'],
};

const roles = Object.keys(allRoles);
const roleRights = new Map(Object.entries(allRoles));

module.exports = {
  roles,
  roleRights,
};
