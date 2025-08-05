const router = require('express').Router()
const additiveController = require('../controllers/additiveController')
const {verifyTokenAuthorization} = require('../middleware/verifyToken')

router.post('/addAdditive', verifyTokenAuthorization, additiveController.addAdditives)
router.get('/getAdditive/:id', verifyTokenAuthorization, additiveController.getAdditives)
router.get('/getAllAdditives', verifyTokenAuthorization, additiveController.getAllAdditives)

module.exports = router;