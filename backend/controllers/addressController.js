const Address = require('../models/Address');
const User = require('../models/User');

module.exports ={
    addAddress: async (req,res) =>{
        const newAddress = new Address({
            userId: req.user.id,
            addressLine1 : req.body.addressLine1,
            postalCode : req.body.postalCode,
            default : req.body.default,
            floorNumber : req.body.floorNumber,
            doorNumber : req.body.doorNumber,
            latitude : req.body.latitude,
            longitude : req.body.longitude,
        })
        try {
            if(req.body.default === true)
            await Address.updateMany({userId: req.user.id}, {default: false})

            await newAddress.save();
            res.status(201).json({status: true, message: "Address added successfully"});
        } catch (error) {
            res.status(500).json({status: false, message: "Error in the addAddress function"});
        }

    },

    getAddresses: async (req,res) =>{
        try {
            const addresses = await Address.find({userId: req.user.id});
             res.status(200).json({status: true, addresses});
        } catch (error) {
            res.status(500).json({status: false, message: "Error in the getAddresses function"});
        }
    },

    removeAddress: async (req,res) =>{
         try {
            await Address.findOneAndDelete(req.params.id);
            res.status(200).json({status: true, message: "Address is deleted"});
        } catch (error) {
            res.status(500).json({status: false, message: "Error in the removeAddress function"});
        }
    },

    setDefaultAddress: async (req,res) =>{
         try {
            const addressId = req.params.id; 
            const userId = req.user.id; 
            await Address.updateMany({userId: userId}, {default: false});
            const updatedAddress = await Address.findByIdAndUpdate(addressId, {default: true})
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
            const defAddress = await Address.findOne({userId: req.user.id, default: true})
             res.status(200).json({status: true, defAddress});
        } catch (error) {
            res.status(500).json({status: false, message: "Error in the getDefaultAddress function"});
        }
    }
}