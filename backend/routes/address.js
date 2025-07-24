const router = require('express').Router()
const addressController = require('../controllers/addressController')
const {verifyTokenAuthorization} = require('../middleware/verifyToken')

router.post('/addAddress', verifyTokenAuthorization, addressController.addAddress)
router.get('/getAddress/:id', verifyTokenAuthorization, addressController.getAddresses)
router.delete('/deleteAddress/:id', verifyTokenAuthorization, addressController.removeAddress)
router.patch('/setDefaultAddress/:id', verifyTokenAuthorization, addressController.setDefaultAddress)
router.get('/DefaultAddress/:id', verifyTokenAuthorization, addressController.getDefaultAddress)

module.exports = router;