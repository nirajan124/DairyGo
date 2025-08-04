import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../../cart/presentation/cart_cubit.dart';
import '../../../cart/data/cart_model.dart';

class HomeContent extends StatefulWidget {
  HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late Future<List<Map<String, dynamic>>> _productsFuture;

  final List<Map<String, String>> categories = [
    { 'name': 'Milk', 'image': 'assets/image/milk.jpg' },
    { 'name': 'Yogurt', 'image': 'assets/image/yogurt.jpg' },
    { 'name': 'Ghee', 'image': 'assets/image/ghee.jpg' },
    { 'name': 'Ice Cream', 'image': 'assets/image/icecream.jpg' },
    { 'name': 'Cookies', 'image': 'assets/image/cookies.jpg' },
  ];

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductRemoteDataSource().fetchProducts();
  }

  void _addToCart(Map<String, dynamic> product) {
    final cartItem = CartItem(
      id: product['_id'] ?? product['id'] ?? DateTime.now().toString(),
      name: product['name'] ?? 'Unknown Product',
      image: product['image'] != null 
          ? 'http://10.0.2.2:3001/uploads/${product['image']}'
          : 'https://via.placeholder.com/150',
      price: (product['price'] ?? 0).toDouble(),
    );
    
    context.read<CartCubit>().addToCart(cartItem);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to cart page
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ),
    );
  }

  final List<Map<String, String>> topTrips = const [
    {
      'title': 'Rara Lake',
      'location': 'Nepal',
      'price': '\$40 /visit',
      'rating': '4.5',
      'image': 'https://i.pinimg.com/736x/86/82/e1/8682e16c492f150bd46e07e421adf5f2.jpg',
      'description': 'Known as the "Queen of Lakes," Rara is the largest lake in Nepal. Surrounded by lush forests, it offers a tranquil retreat with stunning reflections of the Himalayas.'
    },
    {
      'title': 'Tilicho Lake',
      'location': 'Nepal',
      'price': '\$40 /visit',
      'rating': '4.5',
      'image': 'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?w=800',
      'description': 'One of the highest lakes in the world, Tilicho is a breathtaking turquoise gem nestled in the Annapurna mountain range. A challenging yet rewarding trek for adventurers.'
    },
    {
      'title': 'Shey-Phoksundo Lake',
      'location': 'Nepal',
      'price': '\$40 /visit',
      'rating': '4.5',
      'image': 'https://i.pinimg.com/736x/eb/01/e5/eb01e564d2fc2b5c4c64ef7da9f1480b.jpg',
      'description': 'A sacred alpine lake with mesmerizing deep blue waters, located in the remote Dolpo region. Its unique beauty and cultural significance make it a must-see destination.'
    },
    {
      'title': 'Annapurna Base Camp',
      'location': 'Nepal',
      'price': '\$60 /visit',
      'rating': '4.8',
      'image': 'https://i.pinimg.com/736x/91/51/51/9151510b07cc9fc508a9b57b95d0d766.jpg',
      'description': 'Trek through diverse landscapes to the base of the majestic Annapurna massif. This classic trek offers unparalleled mountain views and a deep cultural experience.'
    },
    {
      'title': 'Gokyo Lakes',
      'location': 'Nepal',
      'price': '\$55 /visit',
      'rating': '4.7',
      'image': 'https://i.pinimg.com/736x/98/5f/40/985f40989da0986230256187a45cc471.jpg',
      'description': 'A series of six spectacular glacial lakes in the Sagarmatha National Park. The trek to Gokyo Ri offers panoramic views of Everest and surrounding peaks.'
    },
  ];

  final List<Map<String, String>> featuredPackages = const [
    {
      'title': 'Everest Base Camp',
      'location': 'Khumbu, Nepal',
      'duration': '14 days',
      'image': 'https://images.unsplash.com/photo-1551632811-561732d1e306?w=800',
    },
    {
      'title': 'Annapurna Circuit',
      'location': 'Annapurna, Nepal',
      'duration': '18 days',
      'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181C2E),
      appBar: AppBar(
        title: Text('Dairy Products'),
        backgroundColor: Color(0xFF181C2E),
        elevation: 0,
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              int itemCount = 0;
              if (state is CartLoaded) {
                itemCount = state.cart.itemCount;
              }
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                  if (itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Text(
                          '$itemCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get the Best Dairy Products!\nFresh & Healthy',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Categories
                  Text('Categories', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(cat['image']!),
                              radius: 28,
                            ),
                            SizedBox(height: 4),
                            Text(cat['name']!, style: TextStyle(color: Colors.white)),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  // Products from backend
                  Text('Available Products', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 8),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _productsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No products found.', style: TextStyle(color: Colors.white)));
                      }
                      final products = snapshot.data!;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final prod = products[index];
                          final String imageUrl = prod['image'] != null
                              ? 'http://10.0.2.2:3001/uploads/${prod['image']}'
                              : 'https://via.placeholder.com/150';
                          return Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                  child: Image.network(
                                    imageUrl,
                                    height: 90,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 90),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(prod['name'] ?? 'No Name', style: TextStyle(fontWeight: FontWeight.bold)),
                                      SizedBox(height: 4),
                                      Text(prod['price'] != null ? 'Rs. ${prod['price']}' : '', style: TextStyle(color: Colors.orange)),
                                      SizedBox(height: 8),
                                      Container(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          onPressed: () => _addToCart(prod),
                                          icon: Icon(Icons.add_shopping_cart, size: 16),
                                          label: Text('Add to Cart', style: TextStyle(fontSize: 12)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                            foregroundColor: Colors.white,
                                            minimumSize: Size(double.infinity, 32),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 