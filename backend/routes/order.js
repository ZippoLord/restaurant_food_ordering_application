const router = require('express').Router()
const orderController = require('../controllers/orderController')
const {verifyTokenAuthorization} = require('../middleware/verifyToken')

router.post("/placeOrder",verifyTokenAuthorization, orderController.placeOrder)
router.get("/getUserOrders",verifyTokenAuthorization, orderController.getUserOrders)


module.exports = router