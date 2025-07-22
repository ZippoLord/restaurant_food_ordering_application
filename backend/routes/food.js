const router = require('express').Router();
const foodController = require('../controllers/foodController')

router.post('/', foodController.addFood);
router.get('/restaurant-foods/:id', foodController.getFoodByRestaurant);
router.get('/:category/:code', foodController.getFoodByCategory);
router.get('/:id', foodController.getFoodById);

module.exports = router;
