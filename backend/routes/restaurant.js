const router = require('express').Router();
const restaurantController = require('../controllers/restaurantController');

router.post("/addrestaurant", restaurantController.createRestaurant);
router.get("/byId/:id", restaurantController.getRestaurantById);
router.get("/all/:code", restaurantController.getAllNearByRestaurants)

module.exports = router;