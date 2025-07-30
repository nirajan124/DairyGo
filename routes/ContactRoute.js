const express = require("express");
const router = express.Router();
const { saveMessage, getAllMessages } = require("../controllers/ContactController");
const { protect, authorize } = require("../middleware/auth");

// Public: Save a contact message
router.post("/", saveMessage);
// Admin only: Get all contact messages
router.get("/", protect, authorize("admin"), getAllMessages);

module.exports = router; 