const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const app = express();
const CategoryRoute = require('./routes/category');
const RestaurantRoute = require('./routes/restaurant');
const FoodRoute = require('./routes/food');

dotenv.config();

mongoose.connect(process.env.DBCONNECTION).then(() =>console.log("Connected to database"))
.catch(err => console.error('Database connection error:', err));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/api/category', CategoryRoute);
app.use('/api/restaurant', RestaurantRoute);
app.use('/api/food', FoodRoute);


app.listen(process.env.PORT, () => console.log(`Server running at http://localhost:${process.env.PORT}`));