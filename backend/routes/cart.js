const router = require('express').Router()
const cartController = require('../controllers/cartController')
const {verifyTokenAuthorization} = require('../middleware/verifyToken')

router.post("/addToCart", verifyTokenAuthorization, cartController.addToCart)
router.delete("/removeFromCart/:id",verifyTokenAuthorization, cartController.removeFromCart)
router.get("/getCart",verifyTokenAuthorization, cartController.getCart)
router.get("/getCartCount", verifyTokenAuthorization, cartController.getCartCount)
router.get("/decrement/:id",verifyTokenAuthorization, cartController.decrementProdQty)

module.exports = router;