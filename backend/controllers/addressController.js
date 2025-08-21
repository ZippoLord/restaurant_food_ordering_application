const Address = require('../models/Address');
const User = require('../models/User');

module.exports ={
    addAddress: async (req,res) =>{
        console.log("Adding address for user:", req.user.id);
        console.log("Request body:", req.body);
        const newAddress = new Address({
            userId: req.user.id,
            addressLine1 : req.body.addressLine1,
            postalCode : req.body.postalCode,
            defaultAddress : req.body.defaultAddress,
            floorNumber : req.body.floorNumber,
            doorNumber : req.body.doorNumber,
            latitude : req.body.latitude,
            longitude : req.body.longitude,
        })
        try {
            if(req.body.defaultAddress === true)
            await Address.updateMany({userId: req.user.id}, {defaultAddress: false})

            await newAddress.save();
            await User.findByIdAndUpdate(req.user.id, 
                {
                $set: {firstSetup: true},    
                $push: { address: newAddress._id }
            }, {new: true});
            res.status(201).json({status: true, message: "Address added successfully"});
        } catch (error) {
            res.status(500).json({status: false, message: error.message});
        }

    },

    getAddresses: async (req,res) =>{
        try {
            const addresses = await Address.findById({userId: req.user.id});
             res.status(200).json({status: true, addresses});
        } catch (error) {
            res.status(500).json({status: false, message: "Error in the getAddresses function"});
        }
    },

     getAllAddresses: async (req,res) =>{
        try {
            const addresses = await Address.find({userId: req.user.id});
             res.status(200).json({status: true, addresses});
        } catch (error) {
            res.status(500).json({status: false, message: "Error in the getAllAddresses function"});
        }
    },


    removeAddress: async (req,res) =>{
         try {
            const addressId = req.params.id;
            await Address.findOneAndDelete(addressId);
            await User.updateMany(
                { address: addressId },        
                { $pull: { address: addressId } } 
                );
            res.status(200).json({status: true, message: "Address is deleted"});
        } catch (error) {
            res.status(500).json({status: false, message: "Error in the removeAddress function"});
        }
    },

    setDefaultAddress: async (req,res) =>{
         try {
            const addressId = req.params.id; 
            const userId = req.user.id; 
            await Address.updateMany({userId: userId}, {defaultAddress: false});
            const updatedAddress = await Address.findByIdAndUpdate(addressId, {defaultAddress: true})
            if(updatedAddress){
                await User.findByIdAndUpdate(userId, {address: addressId})
                res.status(200).json({status: true, message: "Address is updated"});
            }
            else
                res.status(400).json({status: false, message: "Address not found"});
        } catch (error) {
            res.status(500).json({status: false, message: "Error in the setDefaultAddress function"});
        }
    },
    
        getDefaultAddress: async (req,res) =>{
         try {
            const defAddress = await Address.findOne({userId: req.user.id, defaultAddress: true})
             res.status(200).json({status: true, defAddress});
        } catch (error) {
            res.status(500).json({status: false, message: "Error in the getDefaultAddress function"});
        }
    }
}