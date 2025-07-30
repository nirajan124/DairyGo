const express = require("express")
const router = express.Router();
const { login, register, changePassword, getAdminProfile } = require("../controllers/AuthController");
const { protect } = require("../middleware/auth");


router.post("/login", login);
router.post("/register", register);
router.post("/change-password", protect, changePassword);
router.get("/me", protect, getAdminProfile);


module.exports = router;
