const Cart = require('../models/Cart')


module.exports = {
    addToCart: async (req,res) =>{ 
        const userId = req.user.id;
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
                res.status(201).json({status: true, message: newCartItem.quantity})
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
    },

    getCart: async (req,res) =>{
        const userId = req.user.id
        try {
            const cart = await Cart.find({userId: userId}).populate({path: 'productId', select: 'imageUrl title restaurant rating ratingCount'})
             res.status(200).json({status: true, message: cart})
        } catch (error) {
            res.status(500).json({status: false, message: error.message})
        }
    },


    getCartCount: async(req,res) =>{
        try {
            const cartCount = await Cart.countDocuments({userId: req.user.id})
            res.status(200).json({status: true, message: cartCount})
        } catch (error) {
            res.status(500).json({status: false, message: error.message})
        }
    },

    decrementProdQty: async(req,res) =>{
        const cartId = req.params.id;
        try {
            const cartItem = await Cart.findById(cartId)
            if(cartItem){
                const productPrice = cartItem.totalPrice / cartItem.quantity;
                if(cartItem.quantity > 1){
                    cartItem.quantity -= 1;
                    cartItem.totalPrice -= productPrice;
                    await cartItem.save();
                     res.status(200).json({status: true, message: "Item decremented from cart"})
                }else{
                    await Cart.findOneAndDelete({_id: cartId})
                    res.status(200).json({status: true, message: "Item removed from cart"})
                }
            }else{
                res.status(400).json({status: false, message: "CartItem not found"})
            }
        } catch (error) {
            res.status(500).json({status: false, message: error.message})
        }
    }
}