const router = require('express').Router()
const userController = require('../controllers/userController')
const {verifyTokenAuthorization} = require('../middleware/verifyToken')

router.get("/", verifyTokenAuthorization, userController.getUser)
router.delete("/",verifyTokenAuthorization, userController.deleteUser)

router.get("/verify", verifyTokenAuthorization, userController.verifyAccount)

module.exports = router;