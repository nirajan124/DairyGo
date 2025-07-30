const mongoose = require('mongoose');
const request = require('supertest');
const app = require('../server');
const Product = require('../models/Product');

describe('Product API Tests', () => {
  let testProductId;

  beforeAll(async () => {
    // Connect to test database
    await mongoose.connect(process.env.MONGO_URI_TEST || 'mongodb://localhost:27017/dairy_test');
  });

  afterAll(async () => {
    await mongoose.connection.close();
  });

  beforeEach(async () => {
    await Product.deleteMany({});
  });

  describe('POST /api/v1/products', () => {
    it('should create a new dairy product', async () => {
      const productData = {
        name: 'Fresh Milk',
        description: 'Organic whole milk from local farms',
        category: 'Milk',
        price: 4.99,
        stockQuantity: 50,
        unit: 'liter',
        brand: 'Local Dairy',
        isOrganic: true,
        expiryDate: '2024-12-31',
        nutritionalInfo: {
          calories: 150,
          protein: 8,
          fat: 8,
          carbohydrates: 12,
          calcium: 300
        }
      };

      const response = await request(app)
        .post('/api/v1/products')
        .send(productData)
        .expect(201);

      expect(response.body.name).toBe(productData.name);
      expect(response.body.category).toBe(productData.category);
      expect(response.body.isOrganic).toBe(true);
      testProductId = response.body._id;
    });

    it('should validate required fields', async () => {
      const invalidProduct = {
        name: 'Test Product'
        // Missing required fields
      };

      const response = await request(app)
        .post('/api/v1/products')
        .send(invalidProduct)
        .expect(500);
    });
  });

  describe('GET /api/v1/products', () => {
    it('should get all products', async () => {
      // Create test products
      await Product.create([
        {
          name: 'Cheddar Cheese',
          description: 'Aged cheddar cheese',
          category: 'Cheese',
          price: 8.99,
          stockQuantity: 20,
          unit: 'kg',
          brand: 'Cheese Co',
          isOrganic: false,
          expiryDate: new Date('2024-12-31'),
          image: 'cheese.jpg'
        },
        {
          name: 'Greek Yogurt',
          description: 'Creamy Greek yogurt',
          category: 'Yogurt',
          price: 3.99,
          stockQuantity: 30,
          unit: 'pack',
          brand: 'Yogurt Brand',
          isOrganic: true,
          expiryDate: new Date('2024-12-15'),
          image: 'yogurt.jpg'
        }
      ]);

      const response = await request(app)
        .get('/api/v1/products')
        .expect(200);

      expect(response.body).toHaveLength(2);
    });

    it('should filter products by category', async () => {
      await Product.create([
        {
          name: 'Milk',
          description: 'Fresh milk',
          category: 'Milk',
          price: 4.99,
          stockQuantity: 50,
          unit: 'liter',
          brand: 'Dairy Co',
          isOrganic: false,
          expiryDate: new Date('2024-12-31'),
          image: 'milk.jpg'
        },
        {
          name: 'Cheese',
          description: 'Aged cheese',
          category: 'Cheese',
          price: 8.99,
          stockQuantity: 20,
          unit: 'kg',
          brand: 'Cheese Co',
          isOrganic: false,
          expiryDate: new Date('2024-12-31'),
          image: 'cheese.jpg'
        }
      ]);

      const response = await request(app)
        .get('/api/v1/products?category=Milk')
        .expect(200);

      expect(response.body).toHaveLength(1);
      expect(response.body[0].category).toBe('Milk');
    });
  });

  describe('GET /api/v1/products/:id', () => {
    it('should get a product by ID', async () => {
      const product = await Product.create({
        name: 'Test Product',
        description: 'Test description',
        category: 'Milk',
        price: 5.99,
        stockQuantity: 25,
        unit: 'liter',
        brand: 'Test Brand',
        isOrganic: false,
        expiryDate: new Date('2024-12-31'),
        image: 'test.jpg'
      });

      const response = await request(app)
        .get(`/api/v1/products/${product._id}`)
        .expect(200);

      expect(response.body.name).toBe('Test Product');
    });

    it('should return 404 for non-existent product', async () => {
      const fakeId = new mongoose.Types.ObjectId();
      await request(app)
        .get(`/api/v1/products/${fakeId}`)
        .expect(404);
    });
  });

  describe('PUT /api/v1/products/:id', () => {
    it('should update a product', async () => {
      const product = await Product.create({
        name: 'Original Name',
        description: 'Original description',
        category: 'Milk',
        price: 4.99,
        stockQuantity: 30,
        unit: 'liter',
        brand: 'Original Brand',
        isOrganic: false,
        expiryDate: new Date('2024-12-31'),
        image: 'original.jpg'
      });

      const updateData = {
        name: 'Updated Name',
        price: 5.99,
        stockQuantity: 40
      };

      const response = await request(app)
        .put(`/api/v1/products/${product._id}`)
        .send(updateData)
        .expect(200);

      expect(response.body.name).toBe('Updated Name');
      expect(response.body.price).toBe(5.99);
      expect(response.body.stockQuantity).toBe(40);
    });
  });

  describe('PUT /api/v1/products/:id/stock', () => {
    it('should update product stock', async () => {
      const product = await Product.create({
        name: 'Stock Test',
        description: 'Test product for stock update',
        category: 'Milk',
        price: 4.99,
        stockQuantity: 10,
        unit: 'liter',
        brand: 'Test Brand',
        isOrganic: false,
        expiryDate: new Date('2024-12-31'),
        image: 'test.jpg'
      });

      const response = await request(app)
        .put(`/api/v1/products/${product._id}/stock`)
        .send({ stockQuantity: 25 })
        .expect(200);

      expect(response.body.stockQuantity).toBe(25);
      expect(response.body.isAvailable).toBe(true);
    });
  });

  describe('DELETE /api/v1/products/:id', () => {
    it('should delete a product', async () => {
      const product = await Product.create({
        name: 'Delete Test',
        description: 'Product to be deleted',
        category: 'Milk',
        price: 4.99,
        stockQuantity: 10,
        unit: 'liter',
        brand: 'Test Brand',
        isOrganic: false,
        expiryDate: new Date('2024-12-31'),
        image: 'test.jpg'
      });

      await request(app)
        .delete(`/api/v1/products/${product._id}`)
        .expect(200);

      // Verify product is deleted
      const deletedProduct = await Product.findById(product._id);
      expect(deletedProduct).toBeNull();
    });
  });
}); 