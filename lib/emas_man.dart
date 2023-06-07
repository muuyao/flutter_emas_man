import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class EmasMan {
  @visibleForTesting
  final MethodChannel methodChannel;

  // 将构造函数标记为私有，以确保只有一个实例。
  EmasMan._() : methodChannel = const MethodChannel('emas_man');

  // 使用工厂构造函数返回单例。
  static final EmasMan _instance = EmasMan._();
  factory EmasMan() => _instance;

  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future<bool?> init({bool? debug, bool? autoPageTrack}) {
    return methodChannel.invokeMethod<bool>('init', {
      'debug': debug,
      'autoPageTrack': autoPageTrack,
    });
  }

  Future<bool?> turnOffAutoPageTrack() {
    return methodChannel.invokeMethod<bool>('turnOffAutoPageTrack');
  }

  Future<bool?> userRegister({
    required String userId,
  }) {
    return methodChannel.invokeMethod<bool>('userRegister', {
      'userId': userId,
    });
  }

  Future<bool?> updateUserAccount({
    required String userId,
    required String username,
  }) {
    return methodChannel.invokeMethod<bool>('updateUserAccount', {
      "userId": userId,
      "username": username,
    });
  }

  Future<bool?> trackPage({
    required String pageName,
    String referPageName = '',
    int? duration,
    Map<String, String>? properties,
  }) {
    return methodChannel.invokeMethod<bool>('trackPage', {
      "pageName": pageName,
      "referPageName": referPageName,
      "duration": duration,
      "properties": properties,
    });
  }

  Future<bool?> trackEvent({
    required String pageName,
    required String eventName,
    int? duration,
    Map<String, String>? properties,
  }) {
    return methodChannel.invokeMethod<bool>('trackEvent', {
      "pageName": pageName,
      "eventName": eventName,
      "duration": duration,
      "properties": properties,
    });
  }
}
