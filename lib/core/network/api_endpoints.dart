class ApiEndpoints {
  // Base URL - configured for both emulator and physical device
  static const String baseUrl = 'http://192.168.1.19:3001/api/v1'; // For physical device and emulator
  // static const String baseUrl = 'http://10.0.2.2:3001/api/v1'; // For Android emulator only
  // static const String baseUrl = 'http://localhost:3001/api/v1'; // For iOS simulator

  // Auth endpoints
  static const String register = '/customers/register';
  static const String login = '/customers/login';
  static const String getCustomer = '/customers/getCustomer';
  static const String updateCustomer = '/customers/updateCustomer';
  static const String uploadImage = '/customers/uploadImage';

  // Package/Trip endpoints
  static const String packages = '/package';
  static const String packageById = '/package/';

  // Booking endpoints
  static const String bookings = '/bookings';
  static const String createBooking = '/bookings';
  static const String getBookings = '/bookings';

  // Wishlist endpoints
  static const String wishlist = '/wishlist';
  static const String addToWishlist = '/wishlist';
  static const String removeFromWishlist = '/wishlist/';

  // Khalti payment endpoints
  static const String khaltiPayment = '/api/khalti/payment';

  // Product endpoints
  static const String products = '/products';
} 