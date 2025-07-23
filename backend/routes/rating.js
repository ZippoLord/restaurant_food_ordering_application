const router = require('express').Router()
const ratingController = require('../controllers/ratingController')
const {verifyTokenAuthorization} = require('../middleware/verifyToken')

router.post("/",verifyTokenAuthorization, ratingController.addRating)
router.get("/",verifyTokenAuthorization, ratingController.checkUserRating)


module.exports = router