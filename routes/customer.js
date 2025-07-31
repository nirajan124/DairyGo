const express = require("express");
const router = express.Router();
const { protect, authorize } = require("../middleware/auth");
const upload = require("../middleware/uploads");

const {
    getCustomers,
    getCustomer,
    register,
    login,
    uploadImage,
    updateCustomer,
    deleteCustomer
} = require("../controllers/customer");

// Routes
router.post("/register", upload.single("profilePicture"), register);
router.post("/login", login);

// Restrict these routes to logged-in users
router.get("/getAllCustomers", protect, authorize("admin"), getCustomers);
router.get("/getCustomer/:id", protect, authorize("admin", "customer"), getCustomer);
router.put("/updateCustomer/:id", protect, authorize("admin", "customer"), upload.single("profilePicture"), updateCustomer);
router.post("/uploadImage", protect, authorize("admin", "customer"), upload.single("profilePicture"), uploadImage);

// Add DELETE route for admin to delete a customer
router.delete("/deleteCustomer/:id", protect, authorize("admin"), deleteCustomer);

// Debug endpoint to fetch a customer by ID
router.get("/debug/:id", async (req, res) => {
  const customer = await require("../models/Customer").findById(req.params.id);
  res.json(customer);
});

module.exports = router;