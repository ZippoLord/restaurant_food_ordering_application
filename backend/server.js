const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const app = express();
const cors = require('cors');
const CategoryRoute = require('./routes/category');
const RestaurantRoute = require('./routes/restaurant');
const FoodRoute = require('./routes/food');
const RatingRoute = require('./routes/rating')
const authRoute = require('./routes/auth')
const userRoute = require('./routes/user')
const addressRoute = require('./routes/address')
const cartRoute = require('./routes/cart')
const orderRoute = require('./routes/order')
const additiveRoute = require('./routes/additive')

dotenv.config();

mongoose.connect(process.env.DBCONNECTION).then(() =>console.log("Connected to database"))
.catch(err => console.error('Database connection error:', err));

app.use(cors());
app.use(cors({
    origin: 'http://10.0.2.2:3000',
    credentials: true,
}))
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/api/auth', authRoute);
app.use('/api/address', addressRoute);
app.use('/api/users', userRoute);
app.use('/api/cart',cartRoute);
app.use('/api/category', CategoryRoute);
app.use('/api/restaurant', RestaurantRoute);
app.use('/api/food', FoodRoute);
app.use('/api/rating', RatingRoute);
app.use('/api/orders', orderRoute);
app.use('/api/additives', additiveRoute);


app.listen(process.env.PORT, () => console.log(`Server running at http://localhost:${process.env.PORT}`));