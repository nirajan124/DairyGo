import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/data/repository/local_repository/user_local_repository.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../view_model/homepage_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Pages for each tab
  final List<Widget> _pages = [
    Center(child: Text('Home', style: TextStyle(fontSize: 24))),
    Center(child: Text('Friends', style: TextStyle(fontSize: 24))),
    Center(child: Text('Messages', style: TextStyle(fontSize: 24))),
    ProfileScreen(),
  ];

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
  UserEntity? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final repo = UserLocalRepository(dataSource: UserHiveDataSource(hiveService: HiveService()));
    final result = await repo.getCurrentUser();
    result.fold(
      (failure) {
        setState(() {
          isLoading = false;
        });
      },
      (userData) {
        setState(() {
          user = userData;
          nameController.text = userData.username;
          emailController.text = userData.email;
          isLoading = false;
        });
      },
    );
  }

  void _saveProfile() {
    setState(() {
      if (user != null) {
        user = UserEntity(
          userId: user!.userId,
          email: emailController.text,
          username: nameController.text,
          password: user!.password,
        );
      }
      isEditing = false;
    });
    // TODO: Save updated user to Hive
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : BlocProvider(
            create: (_) => HomeViewModel(),
            child: Builder(
              builder: (context) => SingleChildScrollView(
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
                          backgroundImage: AssetImage('assets/images/profile.jpg'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Implement profile picture update
                            },
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
                                nameController.text = user?.username ?? '';
                                emailController.text = user?.email ?? '';
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
                        await context.read<HomeViewModel>().logout();
                        // TODO: Navigate to login screen after logout
                      },
                      icon: Icon(Icons.logout),
                      label: Text('Logout'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
