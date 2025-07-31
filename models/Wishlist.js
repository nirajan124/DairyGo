const mongoose = require("mongoose");

const wishlistSchema = new mongoose.Schema({
    customer: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Customer",
        required: true,
    },
    products: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: "Product", // Changed from "Package"
        }
    ],
}, { timestamps: true }); // Automatically adds createdAt & updatedAt

module.exports = mongoose.model("Wishlist", wishlistSchema);
