const express = require("express");
const cors = require("cors");
const db = require("./database");
const authRoutes = require("./routes/auth");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/auth", authRoutes);

let sensorData = {
heartRate: 75,
stress: 20,
riskLevel: "LOW",
};

app.post("/sensor", (req, res) => {
sensorData = req.body;

console.log("Sensor Updated:");
console.log(sensorData);

res.json({
success: true,
data: sensorData,
});
});

app.get("/sensor", (req, res) => {
res.json(sensorData);
});

app.get("/", (req, res) => {
res.send("ShieldHer Backend Running");
});

const PORT = 5000;

app.listen(PORT, () => {
console.log(`Server running on port ${PORT}`);
});
