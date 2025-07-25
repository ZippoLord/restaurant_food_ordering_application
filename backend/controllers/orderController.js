const Order = require('../models/Order')

module.exports = {
    placeOrder: async (req,res) =>{
        const order = new Order({
            ...req.body,
            userId: req.user.id
        })

        try {
            await new Order.save();

            const orderId = order._id;

            res.status(200).json({status: true, message: orderId})
        } catch (error) {
             res.status(500).json({status: false, message: error.message})
        }
    },

    getUserOrders: async (req,res) =>{
        const userId  = req.user.id;
        const {paymentStatus, orderStatus} = req.query;

        let query = {userId};

        if(paymentStatus){
            query.paymentStatus = paymentStatus;
        }

        if(orderStatus){
            query.orderStatus = orderStatus;
        }

        try {
            const orders = await Order.find(query).populate({path: 'orderItems', select:"imageUrl title rating time"})
            res.status(200).json({status: true, message: orders})
        } catch (error) {
            res.status(500).json({status: false, message: error.message})
        }
    },
}