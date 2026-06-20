import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:jigyasa/constant/api/api.url.constant.dart';
import 'package:jigyasa/modules/profile/model/user.profile.model.dart';
import 'package:jigyasa/services/http/dio_client.http.dart';
import 'package:jigyasa/services/local_storage/local_storage.services.dart';

class ProfileRepository {
  Future<User> getProfile() async {
    try {
      // Debug: log token presence
      try {
        final token = await storageInstance.getData(key: 'accessToken');
        debugPrint(
          'ProfileRepository.updateProfile - token present: ${token != null && token.isNotEmpty}',
        );
      } catch (_) {}

      // Use validateStatus to capture non-2xx responses for debugging (temporary)
      // Also attach an extra barrier token header (X-Barrier-Token) as requested.
      String? tokenValue;
      try {
        final t = await storageInstance.getData(key: 'accessToken');
        if (t != null && t.startsWith('Bearer ')) {
          tokenValue = t.substring(7);
        } else {
          tokenValue = t;
        }
      } catch (_) {
        tokenValue = null;
      }

      final response = await apiClient.get(
        ApiUrl.getUserProfile,
        options: Options(
          validateStatus: (status) => true,
          headers: tokenValue != null ? {'X-Barrier-Token': tokenValue} : null,
        ),
      );

      debugPrint('Profile API response status: ${response.statusCode}');
      debugPrint('Profile API response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return User.fromJson(response.data as Map<String, dynamic>);
        } else {
          throw Exception('Backend returned empty or invalid JSON. Response: "${response.data}"');
        }
      } else {
        throw Exception(
          'Failed to load profile - status: ${response.statusCode}, body: ${response.data}',
        );
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      debugPrint(
        'DioException in getProfile: ${e.message}, response: ${e.response?.data}',
      );
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      // Handle other errors
      debugPrint('Error in getProfile: $e');
      throw Exception('Something went wrong: $e');
    }
  }

  Future<User> updateProfile({required Map<String, dynamic> data}) async {


    try {
      try {
        final token = await storageInstance.getData(key: 'accessToken');
        debugPrint(
          'ProfileRepository.getProfile - token present: ${token != null && token.isNotEmpty}',
        );
      } catch (_) {}

      // Use validateStatus to capture non-2xx responses for debugging (temporary)
      // Also attach an extra barrier token header (X-Barrier-Token) as requested.
      String? tokenValue;
      try {
        final t = await storageInstance.getData(key: 'accessToken');
        if (t != null && t.startsWith('Bearer ')) {
          tokenValue = t.substring(7);
        } else {
          tokenValue = t;
        }
      } catch (_) {
        tokenValue = null;
      }
      final response = await apiClient.patch(
        ApiUrl.updateUserProfile,
        data: data,
        options: Options(
          validateStatus: (status) => true,
          headers: tokenValue != null ? {'X-Barrier-Token': tokenValue} : null,
        ),
      );
      debugPrint('Profile API response status: ${response.statusCode}');
      debugPrint('Profile API response data: ${response.data}');
      if(response.statusCode == 200){
        return User.fromJson(response.data);
      }else{
        throw Exception(
          'Failed to update profile - status: ${response.statusCode}, body: ${response.data}',
        );
        
        }
      
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }
}
