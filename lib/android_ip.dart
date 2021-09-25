import 'dart:async';
import 'dart:convert';

import 'package:android_ip/pigeon.dart';
import 'package:flutter/services.dart';

class AndroidIp {
  static const MethodChannel _channel = const MethodChannel('android_ip');
  static const EventChannel networklistner_channel =
      const EventChannel('networklistner');
  static const EventChannel share_channel = const EventChannel('sharelistner');
  static const EventChannel portbyCurrent_channel =
      const EventChannel('portbyCurrentchannel');

  static const EventChannel echannellist_channel =
      const EventChannel('echannellist');
  static const EventChannel permissionlist_channel =
      const EventChannel('permissionlistner');
  Stream<String>? _onConnectivityChanged;
  Stream<String>? _onDeviceConnected;
  Stream<String>? _onShareProcess;
  Stream<String>? _onportbyCurrent;
  Stream<PermissionResult>? _onPermissionChanged;
  static const EventChannel portbyIp_channel =
      const EventChannel('portbyIpchannel');
  Stream<Map<String, dynamic>>? _onportbyIp;

  Stream<Map<String, dynamic>>? get onPortbyIp {
    var arguments = {
      'ip': '192.168.70.156',
      'port': '812',
      'timeout': 50,
      "porta": [1, 10000]
    };
    _onportbyIp = portbyIp_channel
        .receiveBroadcastStream(arguments)
        .map((event) => Map<String, dynamic>.from(event));
    //     {
    //   Map<String, dynamic> parameters = Map<String, dynamic>.from(event);
    //   // print("==ff=>${parameters.values}");
    //   return parameters;
    // }
    // ).skipWhile((element) => element["success"] == "false");
    return _onportbyIp;
  }

  Stream<String>? get onPortbyCurrent {
    var arguments = {
      'ip': '192.168.70.156',
      'port': '812',
      'timeout': 500,
      "porta": [1, 1000]
    };
    _onportbyCurrent = portbyCurrent_channel
        .receiveBroadcastStream(arguments)
        .map((event) => jsonDecode(event.toString()));
    return _onportbyCurrent;
  }

  Stream<String>? get onConnectivityChanged {
    _onConnectivityChanged = networklistner_channel
        .receiveBroadcastStream()
        .map((event) => event.toString());
    return _onConnectivityChanged;
  }

  Stream<PermissionResult>? get onPermissionChanged {
    _onPermissionChanged = permissionlist_channel
        .receiveBroadcastStream()
        .map((event) => PermissionResult.decode(event));
    return _onPermissionChanged;
  }

  Stream<String>? get onDeviceConnected {
    _onDeviceConnected = echannellist_channel
        .receiveBroadcastStream()
        .map((event) => event.toString());
    return _onDeviceConnected;
  }

  Stream<String>? get onShared {
    _onShareProcess =
        share_channel.receiveBroadcastStream().map((event) => event.toString());
    return _onShareProcess;
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool?> get shareself async {
    final bool? version = await _channel.invokeMethod('shareself');
    return version;
  }

  static Future<String?> get shareAPKFile async {
    final String? version = await _channel.invokeMethod('shareAPKFile');
    return version;
  }

  static Future<String?> get getAppName async {
    final String? version = await _channel.invokeMethod('getAppName');
    return version;
  }

  static Future<bool?> get IsLocationEnabled async {
    final bool? version = await _channel.invokeMethod('IsLocationEnabled');
    return version;
  }

  static Future<NetworkResult?> get networkresult async {
    var message = await _channel.invokeMethod('networkresult');
    var dat = NetworkResult.decode(message);
    // print(dat.encode());
    return dat;
  }

  static Future<String?> get IpAddress_Wifi_tether async {
    final String? version = await _channel.invokeMethod('Wifi_tether');
    return version;
  }

  static Future<String?> get EnableWifi async {
    final String? version = await _channel.invokeMethod('EnableWifi');
    return version;
  }

  static Future<String?> get DisableWifi async {
    final String? version = await _channel.invokeMethod('DisableWifi');
    return version;
  }

  static Future<Hotspot> get SetHotspotEnable async {
    var name = await _channel.invokeMethod('SetHotspotEnable', {'key': 'true'});
    return Hotspot.decode(name);
  }

  static Future<void> get SetHotspotDisable async {
    return await _channel.invokeMethod('SetHotspotDisable');
  }

  static Future<void> get SetExternalStorage async {
    return await _channel.invokeMethod('SetExternalStorage');
  }

  static Future<void> get getP2pNames async {
    return await _channel.invokeMethod('getP2pNames');
  }

  static Future<void> get EnableStoragePermission async {
    return await _channel.invokeMethod('EnableStoragePermission');
  }

  static Future<String?> get IpAddress_Wifi_tetherorwifi async {
    final String? version = await _channel.invokeMethod('Wifi_tetherorWifi', {
      'ip': '192.168.43.8',
      'port': '812',
      'timeout': 500,
      "porta": [10, 80],
      'key': 'true'
    });
    return version;
  }

  static Future<String?> get getssid async {
    final String? version = await _channel.invokeMethod('getssid');
    return version;
  }

  static Future<bool?> get isWifiEnabled async {
    // final String? version = await _channel.invokeMethod('isWifiEnabled');

    return await _channel.invokeMethod('isWifiEnabled');
    ;
  }

  static Future<bool?> get isWifiConnected async {
    // final String? version = await _channel.invokeMethod('isWifiEnabled');

    return await _channel.invokeMethod('isWifiConnected');
    ;
  }

  static Future<bool?> get isHotspotEnabled async {
    // final String? version = await _channel.invokeMethod('isHotspotEnabled');

    return await _channel.invokeMethod('isHotspotEnabled');
    ;
  }

  static Future<String?> get IpAddress_Private async {
    String? version = await getIp("Private");
    return version;
  }

  static Future<String?> get EnablePermission async {
    String? version = await getIp("EnablePermission");
    return version;
  }

  static Future<String?> get OpenSettings async {
    String? version = await getIp("OpenSettings");
    return version;
  }

  static Future<String?> get IpAddress_USB_tether async {
    String? version = await getIp("USB_tether");
    return version;
  }

  static Future<String?> get IpAddress_Wifi async {
    String? version = await getIp("Wifi");
    return version;
  }

  static Future<String?> get IpAddress_Blue_ther async {
    String? version = await getIp("Blue_ther");
    return version;
  }

  static Future<String?> get IpAddress_Cellular1 async {
    String? version = await getIp("Cellular1");
    return version;
  }

  static Future<String?> get IpAddress_Cellular2 async {
    String? version = await getIp("Cellular2");
    return version;
  }

  static Future<String?> get IpAddress_All async {
    String? version = await getIp("All");
    return version;
  }

  static Future<String?> get getConnectedList async {
    String? version = await getIp("ConnectedList");
    return version;
  }

  static Future<String?> getIp(String s) async {
    final String? version = await _channel.invokeMethod(s);
    return version;
  }
}
