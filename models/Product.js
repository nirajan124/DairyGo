const mongoose = require("mongoose");

const productSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    description: { type: String, required: true },
    category: { 
      type: String, 
      required: true, 
      enum: ["Milk", "Cheese", "Yogurt", "Butter", "Cream", "Ice Cream", "Other"] 
    },
    price: { type: Number, required: true },
    stockQuantity: { type: Number, required: true, default: 0 },
    unit: { type: String, required: true, enum: ["kg", "liter", "piece", "pack"] },
    image: { type: String, required: true },
    expiryDate: { type: Date, required: true },
    brand: { type: String, required: true },
    isOrganic: { type: Boolean, default: false },
    isAvailable: { type: Boolean, default: true },
    nutritionalInfo: {
      calories: { type: Number },
      protein: { type: Number },
      fat: { type: Number },
      carbohydrates: { type: Number },
      calcium: { type: Number }
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model("Product", productSchema); 