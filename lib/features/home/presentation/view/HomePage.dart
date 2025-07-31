import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Pages for each tab
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      ProductListScreen(),
      WishlistScreen(),
      OrdersScreen(),
      ProfileScreen(),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Friends'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  bool isDarkMode = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? profileImagePath;
  String? userId;
  String? token;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() { isLoading = true; });
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt_token');
    userId = prefs.getString('user_id');
    if (token == null || userId == null) {
      setState(() { isLoading = false; });
      return;
    }
    try {
      final response = await ApiService().getProfile(userId!, token!);
      fnameController.text = response['fname'] ?? '';
      lnameController.text = response['lname'] ?? '';
      phoneController.text = response['phone'] ?? '';
      nameController.text = response['fname'] ?? '';
      emailController.text = response['email'] ?? '';
      // TODO: Load profile image if available
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red),
      );
    }
    setState(() { isLoading = false; });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImagePath = pickedFile.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (token == null || userId == null) return;
    setState(() { isLoading = true; });
    try {
      await ApiService().updateProfile(
        userId: userId!,
        token: token!,
        fname: fnameController.text,
        lname: lnameController.text,
        phone: phoneController.text,
        email: emailController.text,
        imagePath: profileImagePath,
      );
      setState(() { isEditing = false; });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red),
      );
    }
    setState(() { isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 24),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: profileImagePath != null
                        ? FileImage(File(profileImagePath!))
                        : AssetImage('assets/images/profile.jpg') as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.edit, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                isEditing
                    ? TextField(
                        controller: fnameController,
                        decoration: InputDecoration(labelText: 'First Name'),
                      )
                    : Text(fnameController.text, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                isEditing
                    ? TextField(
                        controller: lnameController,
                        decoration: InputDecoration(labelText: 'Last Name'),
                      )
                    : Text(lnameController.text, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                SizedBox(height: 8),
                isEditing
                    ? TextField(
                        controller: phoneController,
                        decoration: InputDecoration(labelText: 'Phone'),
                      )
                    : Text(phoneController.text, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                SizedBox(height: 8),
                isEditing
                    ? TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                      )
                    : Text(nameController.text, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                isEditing
                    ? TextField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      )
                    : Text(emailController.text, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (isEditing) {
                          _saveProfile();
                        } else {
                          setState(() {
                            isEditing = true;
                          });
                        }
                      },
                      child: Text(isEditing ? 'Save' : 'Edit Profile'),
                    ),
                    if (isEditing)
                      SizedBox(width: 12),
                    if (isEditing)
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isEditing = false;
                            _fetchProfile();
                          });
                        },
                        child: Text('Cancel'),
                      ),
                  ],
                ),
                SizedBox(height: 32),
                SwitchListTile(
                  title: Text('Dark Mode'),
                  value: isDarkMode,
                  onChanged: (val) {
                    setState(() {
                      isDarkMode = val;
                      // TODO: Implement actual theme switching
                    });
                  },
                  secondary: Icon(Icons.brightness_6),
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Implement logout logic
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('jwt_token');
                    await prefs.remove('user_id');
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  icon: Icon(Icons.logout),
                  label: Text('Logout'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          );
  }
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Map<String, dynamic>>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _loadProducts();
  }

  Future<List<Map<String, dynamic>>> _loadProducts() async {
    try {
      final response = await ApiService().getProducts();
      final data = response.data as List<dynamic>;
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No products found.'));
        }
        final products = snapshot.data!;
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              leading: product['image'] != null
                  ? Image.network(product['image'], width: 48, height: 48, fit: BoxFit.cover)
                  : Icon(Icons.image, size: 48),
              title: Text(product['name'] ?? 'No Name'),
              subtitle: Text(product['description'] ?? ''),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(productId: product['_id']),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  const ProductDetailScreen({required this.productId});

  @override
  Widget build(BuildContext context) {
    final quantityController = TextEditingController(text: '1');
    return Scaffold(
      appBar: AppBar(title: Text('Product Details')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadProductDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Product not found.'));
          }
          final product = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product['image'] != null)
                  Center(
                    child: Image.network(product['image'], width: 200, height: 200, fit: BoxFit.cover),
                  ),
                SizedBox(height: 16),
                Text(product['name'] ?? '', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(product['description'] ?? ''),
                SizedBox(height: 8),
                if (product['price'] != null)
                  Text('Price: \$${product['price']}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('Quantity:'),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _addToWishlist(context, productId),
                        child: Text('Add to Wishlist'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _placeOrder(context, productId, int.tryParse(quantityController.text) ?? 1),
                        child: Text('Place Order'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _loadProductDetail() async {
    try {
      final response = await ApiService().getProductDetail(productId);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to load product detail: $e');
    }
  }

  Future<void> _addToWishlist(BuildContext context, String productId) async {
    try {
      await ApiService().addToWishlist(productId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to wishlist!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to wishlist: $e')),
      );
    }
  }

  Future<void> _placeOrder(BuildContext context, String productId, int quantity) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please login first')),
        );
        return;
      }
      await ApiService().placeOrder(
        productId: productId,
        quantity: quantity,
        userId: userId,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    }
  }
}

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late Future<List<Map<String, dynamic>>> _wishlistFuture;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt_token');
    setState(() {
      _wishlistFuture = _fetchWishlist();
    });
  }

  Future<List<Map<String, dynamic>>> _fetchWishlist() async {
    if (token == null) return [];
    try {
      final response = await ApiService().getWishlist();
      final data = response.data as List<dynamic>;
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to load wishlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _wishlistFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No wishlist items.'));
        }
        final wishlist = snapshot.data!;
        return ListView.builder(
          itemCount: wishlist.length,
          itemBuilder: (context, index) {
            final item = wishlist[index];
            return ListTile(
              title: Text(item['name'] ?? 'No Name'),
              subtitle: Text(item['description'] ?? ''),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  if (token != null && item['_id'] != null) {
                    try {
                      await ApiService().removeFromWishlist(item['_id']);
                      _loadWishlist();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to remove item: $e')),
                      );
                    }
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<List<Map<String, dynamic>>> _ordersFuture;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt_token');
    setState(() {
      _ordersFuture = _fetchOrders();
    });
  }

  Future<List<Map<String, dynamic>>> _fetchOrders() async {
    if (token == null) return [];
    try {
      final response = await ApiService().getOrders();
      final data = response.data as List<dynamic>;
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _ordersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No orders found.'));
        }
        final orders = snapshot.data!;
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return ListTile(
              title: Text('Order #${order['_id'] ?? ''}'),
              subtitle: Text('Product: ${order['product']?['name'] ?? ''}\nQuantity: ${order['quantity'] ?? ''}'),
              // Add more order details as needed
            );
          },
        );
      },
    );
  }
}
