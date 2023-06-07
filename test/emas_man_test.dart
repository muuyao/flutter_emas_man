import 'package:flutter_test/flutter_test.dart';
import 'package:emas_man/emas_man.dart';
import 'package:emas_man/emas_man_platform_interface.dart';
import 'package:emas_man/emas_man_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEmasManPlatform
    with MockPlatformInterfaceMixin
    implements EmasManPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final EmasManPlatform initialPlatform = EmasManPlatform.instance;

  test('$MethodChannelEmasMan is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEmasMan>());
  });

  test('getPlatformVersion', () async {
    EmasMan emasManPlugin = EmasMan();
    MockEmasManPlatform fakePlatform = MockEmasManPlatform();
    EmasManPlatform.instance = fakePlatform;

    expect(await emasManPlugin.getPlatformVersion(), '42');
  });
}
