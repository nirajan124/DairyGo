import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SharedPreferences Tests', () {
    group('String Operations', () {
      // Test 1: Set string value
      test('should set string value successfully', () async {
        final prefs = await SharedPreferences.getInstance();
        final result = await prefs.setString('test_key', 'test_value');
        expect(result, isTrue);
      });

      // Test 2: Get string value
      test('should get string value successfully', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('test_key', 'test_value');
        final result = prefs.getString('test_key');
        expect(result, equals('test_value'));
      });

      // Test 3: Get string value when key doesn't exist
      test('should return null when string key doesn\'t exist', () async {
        final prefs = await SharedPreferences.getInstance();
        final result = prefs.getString('non_existent_key');
        expect(result, isNull);
      });
    });

    group('Boolean Operations', () {
      // Test 4: Set boolean value
      test('should set boolean value successfully', () async {
        final prefs = await SharedPreferences.getInstance();
        final result = await prefs.setBool('bool_key', true);
        expect(result, isTrue);
      });

      // Test 5: Get boolean value
      test('should get boolean value successfully', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('bool_key', true);
        final result = prefs.getBool('bool_key');
        expect(result, isTrue);
      });
    });

    group('Integer Operations', () {
      // Test 6: Set integer value
      test('should set integer value successfully', () async {
        final prefs = await SharedPreferences.getInstance();
        final result = await prefs.setInt('int_key', 42);
        expect(result, isTrue);
      });

      // Test 7: Get integer value
      test('should get integer value successfully', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('int_key', 42);
        final result = prefs.getInt('int_key');
        expect(result, equals(42));
      });
    });

    group('Key Operations', () {
      // Test 8: Check if key exists
      test('should check if key exists', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('existing_key', 'value');
        final existingResult = prefs.containsKey('existing_key');
        final nonExistingResult = prefs.containsKey('non_existing_key');
        expect(existingResult, isTrue);
        expect(nonExistingResult, isFalse);
      });

      // Test 9: Clear all preferences
      test('should clear all preferences', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('key1', 'value1');
        await prefs.setString('key2', 'value2');
        final result = await prefs.clear();
        expect(result, isTrue);
        expect(prefs.getString('key1'), isNull);
        expect(prefs.getString('key2'), isNull);
      });
    });

    group('Data Persistence', () {
      // Test 10: Verify data persistence across operations
      test('should persist data across multiple operations', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', '12345');
        await prefs.setBool('is_logged_in', true);
        final userId = prefs.getString('user_id');
        final isLoggedIn = prefs.getBool('is_logged_in');
        expect(userId, equals('12345'));
        expect(isLoggedIn, isTrue);
      });
    });
  });
} 