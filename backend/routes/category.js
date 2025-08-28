const router = require('express').Router();
const categoryController = require('../controllers/categoryController');
const {verifyAdmin, verifyTokenAuthorization} = require('../middleware/verifyToken')

router.post("/", categoryController.createCategory);
router.get("/", categoryController.getAllCategories);

module.exports = router;
