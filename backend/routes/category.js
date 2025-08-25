const router = require('express').Router();
const categoryController = require('../controllers/categoryController');
const {verifyAdmin} = require('../middleware/verifyToken')

router.post("/", verifyAdmin, categoryController.createCategory);
router.get("/", verifyAdmin, categoryController.getAllCategories);

module.exports = router;
