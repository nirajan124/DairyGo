import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_service.dart';
import '../view_model/homepage_viewmodel.dart';
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
      Center(child: Text('Friends', style: TextStyle(fontSize: 24))),
      Center(child: Text('Messages', style: TextStyle(fontSize: 24))),
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
      final response = await ApiService().safeApiCall(() => ApiService().getProfile(userId!, token!));
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
      await ApiService().safeApiCall(() => ApiService().updateProfile(
        userId: userId!,
        token: token!,
        fname: fnameController.text,
        lname: lnameController.text,
        phone: phoneController.text,
        email: emailController.text,
        imagePath: profileImagePath,
      ));
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
    _productsFuture = ApiService().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: \\${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No products found.'));
        }
        final products = snapshot.data!;
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
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
    return Scaffold(
      appBar: AppBar(title: Text('Product Details')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService().getProductDetail(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Product not found.'));
          }
          final product = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product['name'] ?? '', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(product['description'] ?? ''),
                SizedBox(height: 8),
                if (product['price'] != null)
                  Text('Price: \\${product['price']}', style: TextStyle(fontSize: 18)),
                // Add more fields as needed
              ],
            ),
          );
        },
      ),
    );
  }
}
