const mongoose = require('mongoose')

const AddressSchema = new mongoose.Schema({
    userId: {type: String, required: true},
    addressLine1: {type: String, required: true},
    floorNumber: {type: String, required: false},
    doorNumber: {type: String, required: false},
    postalCode: {type: String, required: true},
    defaultAddress: {type: Boolean, default: false},
    latitude: {type: String, required: false},
    longitude: {type: String, required: false}
})

module.exports = mongoose.model('Address', AddressSchema)