const Category = require('../models/Category');


module.exports = {
    createCategory: async (req, res) =>{
        const newCategory = new Category(req.body);
        try {
            await newCategory.save();
            res.status(201).json({ message: 'Category created successfully', category: newCategory });
        } catch (error) {
            res.status(500).json({ message: 'Error creating category', error });
        }
    },

    getAllCategories: async (req,res) =>{
        try{
            const categories = await Category.find({title: {$ne: "More"}}, {__v: 0})
            res.status(201).json(categories)
        }catch(error){
            res.status(500).json({ message: 'Error fetching categories', error: error.message });
        }
    },
}