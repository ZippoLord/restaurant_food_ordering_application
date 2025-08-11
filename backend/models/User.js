const mongoose = require('mongoose')

const UserSchema = new mongoose.Schema({
    //username: {type: String, required: true},
    email: {type: String, required: true, unique: true},
    password: {type: String, required: true},
    passwordVerification: {type: String, required: true},
    verification: {type:Boolean, default: true},
    phone: {type: String, default: "0123456789"},
    address:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "Address",
        required: false,
    },
    userType: {type: String, require: true, default:'Client', enum: ["Client", "Admin"]},
    profile: {type: String, default: ''},
}, {timestamps: true})

module.exports = mongoose.model('User', UserSchema)