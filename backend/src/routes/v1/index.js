const express = require('express');
const authRoute = require('./auth.route');
const userRoute = require('./user.route');
const docsRoute = require('./docs.route');
const journeyRoute = require('./journey.route');
const pictureRoute = require('./picture.route');
const locationRoute = require('./location.route');
const positionRoute = require('./position.route');
const visitRoute = require('./visit.route');
const config = require('../../config/config');

const router = express.Router();

const defaultRoutes = [
  {
    path: '/auth',
    route: authRoute,
  },
  {
    path: '/users',
    route: userRoute,
  },
  {
    path: '/pictures',
    route: pictureRoute,
  },
  {
    path: '/journey',
    route: journeyRoute,
  },
  {
    path: '/visit',
    route: visitRoute,
  },
  {
    path: '/location',
    route: locationRoute,
  },
  {
    path: '/position',
    route: positionRoute,
  },
];

const devRoutes = [
  // routes available only in development mode
  {
    path: '/docs',
    route: docsRoute,
  },
];

defaultRoutes.forEach((route) => {
  router.use(route.path, route.route);
});

/* istanbul ignore next */
if (config.env === 'development') {
  devRoutes.forEach((route) => {
    router.use(route.path, route.route);
  });
}

module.exports = router;
