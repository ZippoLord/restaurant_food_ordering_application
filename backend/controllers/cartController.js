const Cart = require('../models/Cart')


module.exports = {
    addToCart: async (req,res) =>{ 
        const userId = req.user.userId;
        const {productId, totalPrice, quantity, additives} = req.body;
        try {
            const existingProduct = await Cart.findOne({userId: userId, productId: productId})
            const count = await Cart.countDocuments({userId: userId})
            if(existingProduct){
                existingProduct.totalPrice += totalPrice * quantity;
                existingProduct.quantity += quantity;
                await existingProduct.save();
                res.status(200).json({status: true, message: "Item added to cart"})
            }else{
                const newCartItem = new Cart({
                    userId: userId,
                    productId: productId,
                    totalPrice: totalPrice,
                    quantity: quantity,
                    additives: additives
                })
                await newCartItem.save();
                res.status(201).json({status: true, message: "Item added to cart"})
            }
        } catch (error) {
            res.status(500).json({status: false, message: error.message})
        }
    },

    removeFromCart: async (req,res) =>{ 
        const userId = req.user.id;
        const cartItemId = req.params.id;
        try {
            await Cart.findByIdAndDelete({_id: cartItemId})
            const count = await  Cart.countDocuments({userId: userId})
            res.status(200).json({status: true, count: count})
            
        } catch (error) {
            res.status(500).json({status: false, message: error.message})
        }
    }
}