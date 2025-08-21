const {Order} = require('../models/Order')


async function generateUniqueOrderNumber() {
  const min = 100;
  const max = 999;
  let unique = false;
  let number;

  while (!unique) {
    number = Math.floor(Math.random() * (max - min + 1)) + min;
    const exists = await Order.findOne({ orderNumber: number });
    if (!exists) {
      unique = true;
    }
  }
  return number;
}

module.exports = {
    placeOrder: async (req,res) =>{
    try {
    const orderNumber = await generateUniqueOrderNumber();
        const order = new Order({
            ...req.body,
            userId: req.user.id,
            orderNumber: orderNumber,
        });
        await order.save();
        res.status(200).json({status: true, message: order._id});
    } catch (error) {
        res.status(500).json({status: false, message: error.message});
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