const mongoose = require('mongoose');

const RestaurantSchema = new mongoose.Schema({
    title: {type: String, required: true},
    time: {type: String, required: true},
    imageUrl: {type: String, required: true},
    foods: {type: Array, default: []},
    delivery: {type: Boolean, required: true},
    isAvailable: {type: Boolean, required: true},
    code: {type: String, required: true},
    rating: {type: Number, min: 1, max: 5, default: 3},
    vertification: {type: String, default: "Pending", enum: ["Pending", "Verified", "Rejected"]},
    coords:{
        id: {type: String},
        latitude: {type: Number, required: true},
        longitude: {type: Number, required: true},
        latitudeDelta: {type: Number, required: 0.0122},
        longitudeDelta: {type: Number, required: 0.0122},
    }
})

module.exports = mongoose.model('Restaurant', RestaurantSchema);