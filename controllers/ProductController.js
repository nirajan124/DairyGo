const Product = require("../models/Product");

// Create a new dairy product
exports.createProduct = async (req, res) => {
  try {
    const { 
      name, 
      description, 
      category, 
      price, 
      stockQuantity, 
      unit, 
      brand, 
      isOrganic, 
      expiryDate,
      nutritionalInfo 
    } = req.body;
    
    const image = req.file ? req.file.filename : null;

    const newProduct = new Product({
      name,
      description,
      category,
      price,
      stockQuantity,
      unit,
      image,
      brand,
      isOrganic: isOrganic === 'true' || isOrganic === true,
      expiryDate: new Date(expiryDate),
      nutritionalInfo: nutritionalInfo ? JSON.parse(nutritionalInfo) : {}
    });

    const savedProduct = await newProduct.save();
    res.status(201).json(savedProduct);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get all dairy products
exports.getAllProducts = async (req, res) => {
  try {
    const { category, isOrganic, isAvailable } = req.query;
    let filter = {};
    
    if (category) filter.category = category;
    if (isOrganic !== undefined) filter.isOrganic = isOrganic === 'true';
    if (isAvailable !== undefined) filter.isAvailable = isAvailable === 'true';
    
    const products = await Product.find(filter);
    res.status(200).json(products);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get a single product by ID
exports.getProductById = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).json({ message: "Product not found" });
    res.status(200).json(product);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update a product
exports.updateProduct = async (req, res) => {
  try {
    const { nutritionalInfo, expiryDate } = req.body;
    
    // Parse nutritional info if provided as string
    if (nutritionalInfo && typeof nutritionalInfo === 'string') {
      req.body.nutritionalInfo = JSON.parse(nutritionalInfo);
    }
    
    // Convert expiry date if provided
    if (expiryDate) {
      req.body.expiryDate = new Date(expiryDate);
    }
    
    // Convert boolean fields
    if (req.body.isOrganic !== undefined) {
      req.body.isOrganic = req.body.isOrganic === 'true' || req.body.isOrganic === true;
    }
    
    if (req.body.isAvailable !== undefined) {
      req.body.isAvailable = req.body.isAvailable === 'true' || req.body.isAvailable === true;
    }

    const updatedProduct = await Product.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!updatedProduct) return res.status(404).json({ message: "Product not found" });
    res.status(200).json(updatedProduct);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Delete a product
exports.deleteProduct = async (req, res) => {
  try {
    const deletedProduct = await Product.findByIdAndDelete(req.params.id);
    if (!deletedProduct) return res.status(404).json({ message: "Product not found" });
    res.status(200).json({ message: "Product deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update stock quantity
exports.updateStock = async (req, res) => {
  try {
    const { stockQuantity } = req.body;
    const product = await Product.findById(req.params.id);
    
    if (!product) return res.status(404).json({ message: "Product not found" });
    
    product.stockQuantity = stockQuantity;
    product.isAvailable = stockQuantity > 0;
    
    const updatedProduct = await product.save();
    res.status(200).json(updatedProduct);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get products by category
exports.getProductsByCategory = async (req, res) => {
  try {
    const { category } = req.params;
    const products = await Product.find({ category, isAvailable: true });
    res.status(200).json(products);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get products expiring soon (within 7 days)
exports.getExpiringProducts = async (req, res) => {
  try {
    const sevenDaysFromNow = new Date();
    sevenDaysFromNow.setDate(sevenDaysFromNow.getDate() + 7);
    
    const products = await Product.find({
      expiryDate: { $lte: sevenDaysFromNow },
      isAvailable: true
    });
    
    res.status(200).json(products);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}; 