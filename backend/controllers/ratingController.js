const Rating = require("../models/Rating")
const Restaurant = require("../models/Restaurant")
const Food = require("../models/Food")


module.exports = {
    addRating: async (req,res) =>{
        const newRating = new Rating({userId: req.body.id, 
            rating: req.body.rating, 
            product: req.body.rating, 
            ratingType: req.body.ratingType})
    
            try {
                await newRating.save();

                if(req.body.ratingType === "Restaurant")
                {
                    const restaurant = await Rating.aggregate([
                        {$match: {ratingType: req.body.ratingType, product: req.body.product}},
                        {$group: {_id: '$product'}, averageRating: {$avg: 'rating'}}
                    ])

                    if(restaurant.length > 0){
                        const avgRating = restaurant[0].averageRating;
                        await Restaurant.findByIdAndUpdate(req.body.product, {rating: avgRating}, {new: true})
                    }
                }else if(req.body.ratingType === "Food"){
                    const food = await Rating.aggregate([
                        {$match: {ratingType: req.body.ratingType, product: req.body.product}},
                        {$group: {_id: '$product'}, averageRating: {$avg: 'rating'}}
                    ])

                    if(food.length > 0){
                        const avgRating = food[0].averageRating;
                        await Restaurant.findByIdAndUpdate(req.body.product, {rating: avgRating}, {new: true})
                    }
                }

            } catch (error) {
                response.status(500).json({status: false, message: "Error in the addRating fucntion"});
            }
    }
}