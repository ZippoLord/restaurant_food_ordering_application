const mongoose = require('mongoose')

const AdditiveSchema = new mongoose.Schema({
  title: {type: String, required: true},  
  price: {type: Number, required: true},  
})


module.exports = mongoose.model('Additive', AdditiveSchema)