const ContactMessage = require("../models/ContactMessage");

// Save a new contact message
exports.saveMessage = async (req, res) => {
  try {
    const { name, email, phone, subject, message } = req.body;
    const newMessage = new ContactMessage({ name, email, phone, subject, message });
    await newMessage.save();
    res.status(201).json({ success: true, message: "Message sent successfully!" });
  } catch (err) {
    res.status(500).json({ success: false, message: "Failed to send message." });
  }
};

// Get all contact messages (admin only)
exports.getAllMessages = async (req, res) => {
  try {
    console.log("[DEBUG] GET /api/v1/contact called by user:", req.user);
    const messages = await ContactMessage.find().sort({ date: -1 });
    console.log("[DEBUG] Messages found:", messages);
    res.status(200).json(messages);
  } catch (err) {
    console.error("[DEBUG] Error in getAllMessages:", err);
    res.status(500).json({ success: false, message: "Failed to fetch messages." });
  }
}; 