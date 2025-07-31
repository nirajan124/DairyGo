const Wishlist = require("../models/Wishlist");
const Product = require("../models/Product");

// Add product to wishlist
exports.addToWishlist = async (req, res) => {
    try {
        const { productId } = req.body;
        const customerId = req.user.id; // Assuming authentication middleware sets req.user

        // Check if the product exists
        const productExists = await Product.findById(productId);
        if (!productExists) {
            return res.status(404).json({ success: false, message: "Product not found" });
        }

        // Find or create wishlist for the customer
        let wishlist = await Wishlist.findOne({ customer: customerId });
        if (!wishlist) {
            wishlist = new Wishlist({ customer: customerId, products: [] });
        }

        // Check if the product is already in the wishlist
        if (wishlist.products.includes(productId)) {
            return res.status(400).json({ success: false, message: "Product already in wishlist" });
        }

        // Add product to wishlist
        wishlist.products.push(productId);
        await wishlist.save();

        // Fetch updated count
        const updatedCount = wishlist.products.length;

        res.status(200).json({ 
            success: true, 
            message: "Product Added to wishlist", 
            wishlist, 
            count: updatedCount // Return count to update frontend 
        });
    } catch (error) {
        res.status(500).json({ success: false, message: "Server Error", error: error.message });
    }
};


// Remove product from wishlist
exports.removeFromWishlist = async (req, res) => {
    try {
        const { productId } = req.params;
        const customerId = req.user.id;

        console.log("Customer ID:", customerId); // Debugging log

        const wishlist = await Wishlist.findOne({ customer: customerId });
        if (!wishlist) {
            return res.status(404).json({ success: false, message: "Wishlist not found" });
        }

        if (!wishlist.products.includes(productId)) {
            return res.status(400).json({ success: false, message: "Product not in wishlist" });
        }

        // Remove product from wishlist
        wishlist.products = wishlist.products.filter(id => id.toString() !== productId);
        await wishlist.save();

        // Fetch updated wishlist with populated products
        const updatedWishlist = await Wishlist.findOne({ customer: customerId }).populate("products");

        // Return updated wishlist count
        res.status(200).json({
            success: true,
            message: "Removed from wishlist",
            wishlist: updatedWishlist,
            count: updatedWishlist.products.length, // Send updated count
        });
    } catch (error) {
        res.status(500).json({ success: false, message: "Server Error", error: error.message });
    }
};


exports.getWishlistCount = async (req, res) => {
  try {
    const wishlist = await Wishlist.findOne({ user: req.user.id });

    if (!wishlist) {
      return res.status(200).json({ success: true, count: 0 });
    }

    return res.status(200).json({ success: true, count: wishlist.products.length });
  } catch (error) {
    console.error("Error fetching wishlist count:", error);
    return res.status(500).json({ success: false, message: "Server Error" });
  }
};

// Get wishlist of a customer
exports.getWishlist = async (req, res) => {
    try {
        const customerId = req.user.id;
        const wishlist = await Wishlist.findOne({ customer: customerId }).populate("products");

        if (!wishlist) {
            return res.status(404).json({ success: false, message: "Wishlist not found" });
        }

        res.status(200).json({ success: true, wishlist });
    } catch (error) {
        res.status(500).json({ success: false, message: "Server Error", error: error.message });
    }
};

exports.deleteWishlistItem = async (req, res) => {
    try {
      const userId = req.user.id; // Get user ID from `protect` middleware
      const productId = req.params.productId;
  
      // Find the user's wishlist
      const wishlist = await Wishlist.findOne({ customer: userId });
  
      if (!wishlist) {
        return res.status(404).json({ success: false, message: "Wishlist not found" });
      }
  
      
  
      res.status(200).json({ success: true, message: "Product deleted from wishlist" });
    } catch (error) {
      console.error("Error deleting from wishlist:", error);
      res.status(500).json({ success: false, message: "Server error" });
    }
};
