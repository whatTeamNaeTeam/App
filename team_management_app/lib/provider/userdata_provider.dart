import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// 사용자 정보를 저장할 상태 프로바이더
final userProvider = StateProvider<Map<String, dynamic>?>((ref) {
  return null;
});

// 로그인 상태를 저장할 프로바이더
final loginStatusProvider = StateProvider<bool>((ref) {
  return false;
});

// Navigator key를 저장할 프로바이더
final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});
