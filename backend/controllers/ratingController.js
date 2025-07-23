const Rating = require("../models/Rating")
const Restaurant = require("../models/Restaurant")
const Food = require("../models/Food")


module.exports = {
    addRating: async (req,res) =>{
        const newRating = new Rating({userId: req.user.id, 
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
                        await Food.findByIdAndUpdate(req.body.product, {rating: avgRating}, {new: true})
                    }
                }
                 response.status(200).json({status: true, message: "Rating updated."});
            } catch (error) {
                response.status(500).json({status: false, message: "Error in the addRating function"});
            }
    },

    checkUserRating: async(req,res) =>{
        const ratingType = req.query.ratingType;
        const product = req.query.product;
        try {
            const existingRating = await Rating.findOne({
                userId: req.user.id,
                product: product,
                ratingType: ratingType
            })

            if(existingRating){
                response.status(200).json({status: true, message: "You rated this restaurant"});
            }else{
                response.status(200).json({status: false, message: "You not rated this restaurant"});
            }

        } catch (error) {
             response.status(500).json({status: false, message: "Error in the checkUserRating function"});
        }
    }
}