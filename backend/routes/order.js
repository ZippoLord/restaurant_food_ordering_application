const router = require('express').Router()
const orderController = require('../controllers/orderController')
const {verifyTokenAuthorization, verifyAdmin} = require('../middleware/verifyToken')

router.post("/placeOrder",verifyTokenAuthorization, orderController.placeOrder)
router.get("/getUserOrders",verifyTokenAuthorization, orderController.getUserOrders)
router.patch("/:id/status", verifyAdmin, orderController.patchUserOrder)


module.exports = router