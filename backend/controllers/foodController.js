const Food = require('../models/Food');

module.exports = {
    addFood: async (req, res) =>{
        console.log(req.body)
        const {title, code, restaurant, time, description, price, additives, imageUrl} = req.body;

        if(!title || !code || !restaurant || !time || !description || !price || !additives || !imageUrl)
            return res.status(400).json({status: false, message: "Missing dependencies"});
        
        const newFood = new Food(req.body);
        try {
            await newFood.save();
            return res.status(201).json({status: true, message: "new food is added"});

        } catch (error) {
            return res.status(500).json({status: false, message: "Error in addFood function"});
        }
    },

    getFoodById: async (req,res) =>{
        const id = req.params.id;
        try {
            const food = await Food.findById(id);
            return res.status(200).json(food)
        } catch (error) {
             return res.status(500).json({status: false, message: "Error in getFoodById function"});
        }
    },

    getFoodByRestaurant: async (req, res) =>{
        const id = req.params.id;
        console.log(id)
        try {
            const restaurantFoods=  await Food.find({restaurant: id});
            console.log(restaurantFoods);
            return res.status(200).json(restaurantFoods)
        } catch (error) {
            return res.status(500).json({status: false, message: "Error in getFoodByRestaurant function"});
        }
    },

    getFoodByCategory: async (req,res) =>{
        try {
            const {category, code} = req.params;
            const foods = await Food.aggregate([
                {$match: {category: category, code: code, isAvailable: true}},
                {$project: {__v:0}},
            ])
            return res.status(200).json(foods);
        } catch (error) {
            return res.status(500).json({status: false, message: "Error in getFoodByCategory function"});
        }
    }
}