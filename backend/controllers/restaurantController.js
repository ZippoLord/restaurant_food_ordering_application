const Restaurant = require('../models/Restaurant'); 


module.exports = {
    createRestaurant:async (req, res) => {
        console.log(req.body);
        const {title, time, imageUrl, code, coords} = req.body;
        if(!title || !time || !imageUrl || !code || !coords || !coords.latitude || !coords.longitude) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        try {
            const newRestaurant = new Restaurant(req.body);
            await newRestaurant.save();            
            res.status(201).json({status: true, message: 'Restaurant created successfully', restaurant: newRestaurant });
        } catch (error) {
            res.status(500).json({ message: 'Error creating restaurant', error });
        }
    },
    getRestaurantById: async (req, res) =>{
        const id = req.params.id;
        try {
            const restaurant = await Restaurant.findById(id);
            res.status(200).json(restaurant);
        } catch (error) {
            res.status(500).json({ message: 'Error fetching restaurant', error: error.message });
        }
        
    },
    getAllNearByRestaurants: async (req, res) =>{
        const code = req.params.code;
        let restaurantsByCode = [];
        try {
            if(code){
                restaurantsByCode = await Restaurant.aggregate([
                    {$match: {code: code, isAvailable: true}},
                    {$project: {__v: 0}}
                ]) 
            }
            if(restaurantsByCode.length === 0){
                restaurantsByCode = await Restaurant.aggregate([
                    {$match: {code: code, isAvailable: true}},
                    {$project: {__v: 0}}
                ]) 
            }
            res.status(200).json(restaurantsByCode);
        } catch (error) {
            res.status(500).json({ message: 'Error fetching restaurants', error: error.message });
        }
        console.log(restaurantsByCode)
    }
}