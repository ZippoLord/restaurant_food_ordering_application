const router = require('express').Router();
const restaurantController = require('../controllers/restaurantController');
const {verifyTokenAuthorization} = require('../middleware/verifyToken')

router.post("/addrestaurant", verifyTokenAuthorization, restaurantController.createRestaurant);
router.get("/byId/:id", restaurantController.getRestaurantById);
router.get("/all/:code", restaurantController.getAllNearByRestaurants)

module.exports = router;