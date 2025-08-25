const router = require('express').Router();
const foodController = require('../controllers/foodController')
const {verifyAdmin} = require('../middleware/verifyToken')

router.post('/', verifyAdmin, foodController.addFood);
router.get('/restaurant-foods/:id', foodController.getFoodByRestaurant);
router.get('/:category', foodController.getFoodByCategory);
router.get('/:id', foodController.getFoodById);

module.exports = router;
