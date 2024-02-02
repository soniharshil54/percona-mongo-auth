const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const app = express();
const port = process.env.PORT || 3000;

// Body-parser middleware
app.use(bodyParser.json());

// MongoDB and Mongoose setup
// const mongoDB = 'mongodb://mongo-percona:27017/nexusDB';
const mongoDB = 'mongodb://nexusUser:X3H44wQA8c@mongo-percona:27017/nexusDB?authSource=admin';
mongoose.connect(mongoDB, { useNewUrlParser: true, useUnifiedTopology: true });
mongoose.Promise = global.Promise;
const db = mongoose.connection;
db.on('error', console.error.bind(console, 'MongoDB connection error:'));

// Mongoose Schema and Model
const Schema = mongoose.Schema;
const TestSchema = new Schema({
    name: String,
    value: String
});
const TestModel = mongoose.model('TestModel', TestSchema, 'TestCollection');

// Function to add default records
const addDefaultRecords = async () => {
    try {
        const count = await TestModel.countDocuments();
        if (count === 0) {
            const defaultItems = [
                { name: 'Item1', value: 'Value1' },
                { name: 'Item2', value: 'Value2' },
                { name: 'Item3', value: 'Value3' }
            ];
            await TestModel.insertMany(defaultItems);
            console.log('Default items added successfully');
        }
    } catch (err) {
        console.error('Error adding default items:', err);
    }
};

// Add default records when server starts
db.once('open', () => {
    addDefaultRecords();
});

// GET API - Retrieve all records
app.get('/api/items', async (req, res) => {
    try {
        const items = await TestModel.find({});
        res.status(200).send(items);
    } catch (err) {
        res.status(500).send(err);
    }
});

// POST API - Create a new record
app.post('/api/item', async (req, res) => {
    try {
        let newItem = new TestModel(req.body);
        const item = await newItem.save();
        res.status(201).send(item);
    } catch (err) {
        res.status(500).send(err);
    }
});

// Server listening
app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
