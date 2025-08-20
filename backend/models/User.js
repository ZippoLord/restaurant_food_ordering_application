const mongoose = require('mongoose')

const UserSchema = new mongoose.Schema({
    username: {type: String, required: true, default:""},
    email:{type: String, required: true, unique: true},
    password: {type: String, required: true},
    verification: {type:Boolean, default: true},
    phone: {type: String, default: "0123456789"},
    address:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "Address",
        required: false,
        default: null,
    },
    userType: {type: String, require: true, default:'Client', enum: ["Client", "Admin"]},
}, {timestamps: true})

module.exports = mongoose.model('User', UserSchema)