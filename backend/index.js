const express = require("express");
const cors = require("cors");
const { MongoClient, ObjectId } = require("mongodb");

const app = express();
const PORT = 3000;
const uri = "mongodb://localhost:27017";
const client = new MongoClient(uri);
const dbName = "Todo_Internship";

app.use(cors());
app.use(express.json());

let db, todos;

client.connect().then(() => {
	db = client.db(dbName);
	todos = db.collection("todos");
});

app.get("/todos", async (req, res) => {
	const result = await todos.find().toArray();
	return res.json(result);
});

app.get("/todos/:id", async (req, res) => {
	const result = await todos.findOne({ _id: new ObjectId(req.params.id) });
	return res.json(result);
});

app.post("/todos", async (req, res) => {
	const { title, description, created } = req.body;
	const result = await todos.insertOne({
		title: title,
		description: description,
		created: created,
	});
	return res.json(result);
});

app.put("/todos/:id", async (req, res) => {
	const { title, description } = req.body;
	const result = await todos.updateOne(
		{ _id: new ObjectId(req.params.id) },
		{ $set: { title, description } }
	);
	return res.json(result);
});

app.delete("/todos/:id", async (req, res) => {
	const result = await todos.deleteOne({ _id: new ObjectId(req.params.id) });
	return res.json(result);
});

app.delete("/todos", async (req, res) => {
	const { ids } = req.body;

	const result = await todos.deleteMany({
		_id: { $in: [...ids].map((id) => new ObjectId(id)) },
	});

	return res.json(result);
});

app.listen(PORT, () =>
	console.log(`Server running on port http://localhost:${PORT}`)
);
