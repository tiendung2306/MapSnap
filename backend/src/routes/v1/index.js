const express = require('express');
const authRoute = require('./auth.route');
const userRoute = require('./user.route');
const docsRoute = require('./docs.route');
const journeyRoute = require('./journey.route');
const pictureRoute = require('./picture.route');
const locationRoute = require('./location.route');
const tripRoute = require('./trip.route');
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
    path: '/trip',
    route: tripRoute,
  },
  {
    path: '/location',
    route: locationRoute,
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
