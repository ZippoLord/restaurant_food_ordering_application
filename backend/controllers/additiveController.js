const Additives = require('../models/Additives');


module.exports ={
    addAdditives: async (req,res) =>{
        const {title, price} = req.body;
        try {
            if(title == ''||price == 0)
                {
                    return res.status(400).json({ message: 'All fields are required' });
                }
                else{
                        const newAdditives = new Additives({
                       title,
                       price,
                    })
                    await newAdditives.save();
                    res.status(201).json({status: true, message: "Additive added successfully"});
                }
        } catch (error) {
            res.status(500).json({status: false, message: error.message});
        }

    },

        getAdditives: async (req, res) => {
    try {
        const additives = await Additives.find();
        res.status(200).json({ status: true, additives });
    } catch (error) {
        res.status(500).json({ status: false, message: error.message });
    }
    },

    getAllAdditives: async (req, res) => {
    try {
        const additives = await Additives.find();
        res.status(200).json({ status: true, additives });
    } catch (error) {
        res.status(500).json({ status: false, message: error.message });
    }
    }


}