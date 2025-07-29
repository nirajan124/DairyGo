import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});

  // Replace trekking categories and recommendations with dairy product categories and products
  final List<Map<String, String>> categories = [
    { 'name': 'Milk', 'image': 'assets/image/milk.jpg' },
    { 'name': 'Yogurt', 'image': 'assets/image/yogurt.jpg' },
    { 'name': 'Ghee', 'image': 'assets/image/ghee.jpg' },
    { 'name': 'Ice Cream', 'image': 'assets/image/icecream.jpg' },
    { 'name': 'Cookies', 'image': 'assets/image/cookies.jpg' },
  ];
  final List<Map<String, String>> recommended = [
    { 'name': 'Fresh Milk', 'image': 'assets/image/milk.jpg', 'price': '2.99' },
    { 'name': 'Yogurt', 'image': 'assets/image/yogurt.jpg', 'price': '4.99' },
    { 'name': 'Ice Cream', 'image': 'assets/image/icecream.jpg', 'price': '3.99' },
    { 'name': 'Ghee', 'image': 'assets/image/ghee.jpg', 'price': '5.99' },
  ];

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
                  // Recommended
                  Text('Recommended for You', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: recommended.length,
                    itemBuilder: (context, index) {
                      final prod = recommended[index];
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.asset(prod['image']!, height: 90, width: double.infinity, fit: BoxFit.cover),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(prod['name']!, style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  Text(' 24${prod['price']}', style: TextStyle(color: Colors.orange)),
                                ],
                              ),
                            ),
                          ],
                        ),
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