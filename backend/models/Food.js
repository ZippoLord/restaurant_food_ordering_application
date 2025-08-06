const mongoose = require('mongoose')

const FoodSchema = new mongoose.Schema({
    title: {type: String, required: true},
    time: {type: String, required: true},
    description: {type: String, required: true},
    category: {type: String, required: true},
    code: {type: String, required: true},
    imageUrl: {type: String, required: true},
    restaurant: {type: mongoose.Schema.Types.ObjectId, ref:'Restaurant', required: true},
    rating: {type: Number, min: 1, max:5, default: 3},
    ratingCount:{type: String, default:"267"},
    price: {type: Number, required: true, validate:{validator: Number.isInteger}},
    additives: [{type: mongoose.Schema.Types.ObjectId, required: false, ref:"Additive"}],
    
})

module.exports = mongoose.model('Food', FoodSchema)