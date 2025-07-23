const User =require('../models/User')


module.exports ={
    getUser: async(req,res) =>{
        console.log("Logging in user ID:", user._id);
        try {
            const user = await User.findById(req.user.id);
            if (!user) {
                return res.status(404).json({ status: false, message: "User not found" });
            }
            const {password, __v, createdAt, ...userData} = user._doc;
            res.status(200).json(userData);

        } catch (error) {
            res.status(500).json({status: false, message: error.message});
        }
    },
     deleteUser: async(req,res) =>{
        try {
            await User.findByIdAndDelete(req.user.id);
            res.status(200).json({status: true, message: "User is deleted"});
        } catch (error) {
            res.status(500).json({status: false, message: error.message});
        }
    },

    verifyAccount: async (req, res) => {
    try {
        const user = await User.findById(req.user.id);
        if (!user) {
            return res.status(400).json({ status: false, message: "User not found" }); 
        } else {
            user.verification = true;
            await user.save();
            const { password, __v, createdAt, ...others } = user._doc;
            return res.status(200).json({ ...others });
        }
    } catch (error) {
        res.status(500).json({ status: false, message: error.message });
    }
}

}