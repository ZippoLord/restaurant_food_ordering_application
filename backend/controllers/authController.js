const User = require('../models/User')
const cryptoJS = require('crypto-js')
const { decrypting } = require('dotenv')
const jwt = require('jsonwebtoken')



module.exports ={
    createUser: async(req, res) => {
        console.log(req.body);
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/

        if(!emailRegex.test(req.body.email)){
            return res.status(400).json({status: false, message: "Email is not valid"})
        }

        const minPasswordLength = 6;
        if(req.body.password.length < minPasswordLength){
            return res.status(400).json({status: false, message: "Password should be at least "+ minPasswordLength+" characters long"}) 
        }

        try {
            const emailExist = await User.findOne({email: req.body.email});

            if(emailExist){
            return res.status(400).json({status: false, message: "Email already exists"})
            }

            const newUser = User({
                username: req.body.username,
                email: req.body.email,
                userType: "Client",
                password: cryptoJS.AES.encrypt(req.body.password, process.env.SECRET).toString(),
            })

            await newUser.save();
            return res.status(201).json({status: true, message: "The user is created"})
        } catch (error) {
            return res.status(500).json({status: false, message:error.message || "Error in the createUser function"})
        }

    },
    loginUser: async(req, res) => {
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;

    if (!emailRegex.test(req.body.email)) {
        return res.status(400).json({ status: false, message: "Email is not valid" });
    }

    const minPasswordLength = 6;
    if (!req.body.password || req.body.password.length < minPasswordLength) {
        return res.status(400).json({ status: false, message: "Password should be at least " + minPasswordLength + " characters long" });
    }

    try {
        const user = await User.findOne({ email: req.body.email });
        
        if (!user) {
            return res.status(400).json({ status: false, message: "Account not found" });
        }
   
        const decryptedPassword = cryptoJS.AES.decrypt(user.password, process.env.SECRET);
        const converted = decryptedPassword.toString(cryptoJS.enc.Utf8);

        if (converted !== req.body.password) {
            return res.status(400).json({ status: false, message: "Wrong password" });
        }

        const userToken = jwt.sign({
            id: user._id,
            userType: user.userType,
            email: user.email
        }, process.env.JWT_SECRET, { expiresIn: "1d" });

        const { password, ...others } = user._doc;
        
        return res.status(200).json({ status: true, ...others, userToken });

    } catch (error) {
        console.error("loginUser error:", error); 
        return res.status(500).json({ status: false, message: error.message || "Error in the loginUser function" });
    }
}

}