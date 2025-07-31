const express = require("express");
const router = express.Router();
const productController = require("../controllers/ProductController");
const upload = require("../middleware/uploads");

// Basic CRUD operations
router.post("/", upload.single("image"), productController.createProduct);
router.get("/", productController.getAllProducts);
router.get("/:id", productController.getProductById);
router.put("/:id", productController.updateProduct);
router.delete("/:id", productController.deleteProduct);

// Additional dairy-specific routes
router.put("/:id/stock", productController.updateStock);
router.get("/category/:category", productController.getProductsByCategory);
router.get("/expiring/soon", productController.getExpiringProducts);

module.exports = router; 