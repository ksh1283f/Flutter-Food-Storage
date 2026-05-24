import 'package:flutter_food_storage/data/remote/api_client.dart';


class AuthAPI {
  AuthAPI({ApiClient? client}) : _client = client ?? ApiClient();
  final ApiClient _client;

  // Firebase 로그인 후 백엔드에 사용자 등록/동기화
  Future<Map<String, dynamic>> signIn() async {
    return await _client.post<Map<String, dynamic>>('/api/auth/login', {});
  }

  // 현재 로그인된 사용자 정보 조회
  Future<Map<String, dynamic>> getMe() async {
    return await _client.get<Map<String, dynamic>>('/api/users/me');
  }

  // 계정 삭제
  Future<void> deleteAccount() async {
    await _client.delete<Map<String, dynamic>>('/api/users/me');
  }
}
