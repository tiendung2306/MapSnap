const allRoles = {
  user: ['userRights'],
  admin: ['adminRights', 'manageUsers', 'getUsers'],
};

const roles = Object.keys(allRoles);
const roleRights = new Map(Object.entries(allRoles));

module.exports = {
  roles,
  roleRights,
};
