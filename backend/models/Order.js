const mongoose = require('mongoose')


const OrderItemSchema = new mongoose.Schema({
    foodId: {type: mongoose.Schema.Types.ObjectId, ref: 'Food', required: true},
    quantity: {type: Number, required: true},
    price: {type: Number, required: true},
    additives : {type: Array},
    //instructions : {type: String, default: ''}
})

const OrderSchema = new mongoose.Schema({
    userId: {type: mongoose.Schema.Types.ObjectId, ref:'User'},
    restaurantId: {type: mongoose.Schema.Types.ObjectId,  ref: 'Restaurant'},
    restaurantCoords: [Number],
    recipientCoords: [Number],
    driverId: {type: String, default: ''},
    rating: {type: Number, min: 1, max: 5,default: 3},
    feedback: {type: String},
    // promoCode:  {type: String},
    // discountAmount: {type: Number},
    // notes: {type: String},
    orderItems : [OrderItemSchema],
    orderTotal: {type: Number, required: true},
    Fee: {type: Number, required: true},
    grandTotal: {type: Number, required: true},    
    orderNumber: {type: Number, required: true},
    deliveryAddress:{ type: mongoose.Schema.Types.ObjectId, ref: 'Address', required: true},
    restaurantAddress:{ type: String, required: true},
    paymentMethod:{type: String, required:true},
    paymentStatus:{type: String, default: 'Pending', enum:['Pending', 'Completed', 'Failed']},
    deliveryStatus:{type: String, default: 'Pending', enum:['Pending', 'Accepted', 'Preparing', 'On the way', 'Delivered', 'Cancelled']},
}, {timestamps: true})


const Order = mongoose.model("Order", OrderSchema);
const OrderItem = mongoose.model("OrderItem", OrderItemSchema)

module.exports = {Order, OrderItem}