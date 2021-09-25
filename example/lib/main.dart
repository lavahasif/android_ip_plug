import 'dart:async';

import 'package:android_util/android_ip.dart';
import 'package:android_util/pigeon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _Connecton_change = '';
  String _ondeviceconnected = '';
  String _wifiname = '';
  String _ondeviceconnected2 = '';
  String _status = '';
  String _IpAddress_Wifi_tether = 'Unknown';
  bool _isHotspot = false;
  bool _isWifi = false;
  String _IpAddress_Wifi_both = 'Unknown';
  String _IpAddress_Wifi = 'Unknown';
  String _IpAddress_Private = 'Unknown';
  String _IpAddress_USB_tether = 'Unknown';
  String _IpAddress_All = 'Unknown';
  String _IpAddress_Cellular2 = 'Unknown';
  String _IpAddress_Cellular1 = 'Unknown';
  String _IpAddress_Cell = 'Unknown';
  String _IpAddress_Blue_ther = 'Unknown';
  String _connectedlist = '';

  NetworkResult? networkResult = null;

  late AndroidIp androidIp;

  @override
  initState() {
    super.initState();
    androidIp = new AndroidIp();
    var listner = androidIp.onConnectivityChanged;
    var ondeviceconnected = androidIp.onDeviceConnected;
    permissionchanged();
    androidIp.onPortbyIp!.listen((event) {
      print(event);
    });

    listner!.listen((event) {
      setState(() {
        _Connecton_change = event;
      });
      initPlatformState();
    });
    ondeviceconnected!.listen((event) {
      setState(() {
        _ondeviceconnected = _ondeviceconnected + "," + event;
      });
    });

    initPlatformState();
  }

  permissionchanged() {
    var da = androidIp.onPermissionChanged!.listen((event) {
      print("${event.name}${event.status}");
      initPlatformState();
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String IpAddress_Wifi_tether;
    String IpAddress_Wifi;
    String IpAddress_Wifi_both;
    String IpAddress_Private;
    String IpAddress_USB_tether;
    String IpAddress_Cellular1;
    String IpAddress_Cellular2;
    String IpAddress_Blue_ther;
    String IpAddress_All;
    bool isHotspot = false;
    bool isWifi = false;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      networkResult = await AndroidIp.networkresult;
      IpAddress_Wifi_tether = (networkResult)!.wifi_tether ?? 'Unknown Number';
      // await AndroidIp.IpAddress_Wifi_tetherorwifi;
      // await AndroidIp.getP2pNames;
      // await AndroidIp.getConnectedList ?? 'Unknown Number';
      IpAddress_Wifi_both = networkResult?.wifiboth ?? 'Unknown Number';
      IpAddress_Wifi = networkResult?.wifi ?? 'Unknown Number';
      IpAddress_Private = await AndroidIp.IpAddress_Private ?? 'Unknown Number';
      IpAddress_USB_tether =
          await AndroidIp.IpAddress_USB_tether ?? 'Unknown Number';
      IpAddress_Cellular1 =
          await AndroidIp.IpAddress_Cellular1 ?? 'Unknown Number';
      IpAddress_Cellular2 =
          await AndroidIp.IpAddress_Cellular2 ?? 'Unknown Number';
      IpAddress_Blue_ther =
          await AndroidIp.IpAddress_Blue_ther ?? 'Unknown Number';
      IpAddress_All = await AndroidIp.IpAddress_All ?? 'Unknown Number';
      isHotspot = await AndroidIp.isHotspotEnabled ?? false;
      isWifi = await AndroidIp.isWifiEnabled ?? false;
      _wifiname = networkResult?.WifiName ?? "";
    } on PlatformException {
      IpAddress_Wifi_tether = 'Failed to get ';
      IpAddress_Wifi = 'Failed to get ';
      IpAddress_Private = 'Failed to get ';
      IpAddress_USB_tether = 'Failed to get ';
      IpAddress_Cellular1 = 'Failed to get ';
      IpAddress_Cellular2 = 'Failed to get ';
      IpAddress_Blue_ther = 'Failed to get ';
      IpAddress_All = 'Failed to get ';
      IpAddress_Wifi_both = 'Failed to get ';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _IpAddress_Wifi_tether = IpAddress_Wifi_tether;
      _IpAddress_Wifi = IpAddress_Wifi;
      _IpAddress_Private = IpAddress_Private;
      _IpAddress_USB_tether = IpAddress_USB_tether;
      _IpAddress_Cellular1 = IpAddress_Cellular1;
      _IpAddress_Cellular2 = IpAddress_Cellular2;
      _IpAddress_Blue_ther = IpAddress_Blue_ther;
      _IpAddress_All = IpAddress_All;
      _IpAddress_Wifi_both = IpAddress_Wifi_both;
      _isHotspot = isHotspot;
      _isWifi = isWifi;
      _wifiname;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: [
            Column(
              children: [
                Text('Changes on: $_Connecton_change\n'),
                Row(
                  children: [
                    Text('Wifi on: $_IpAddress_Wifi\n'),       SizedBox(width: 25,),
                    RaisedButton(color:Colors.blue,child:Text("Copy"),onPressed:()=> _copy(_IpAddress_Wifi))
                  ],
                ),
                Row(
                  children: [
                    Text('Wifi_tether on: $_IpAddress_Wifi_tether\n'),       SizedBox(width: 25,),
                    RaisedButton(color:Colors.blue,child:Text("Copy"),onPressed:()=> _copy(_IpAddress_Wifi_tether))
                  ],
                ),
                Text('Private on: $_IpAddress_Private\n'),
                Row(
                  children: [
                    Text('Wifi_tether_both on: $_IpAddress_Wifi_both\n'),
                    SizedBox(
                      width: 25,
                    ),
                    RaisedButton(
                        color: Colors.blue,
                        child: Text("Copy"),
                        onPressed: () => _copy(_IpAddress_Wifi_both))
                  ],
                ),
                Text('Cellular2 on: $_IpAddress_Cellular2\n'),
                Row(
                  children: [
                    Text('USB_tether on: $_IpAddress_USB_tether\n'),
                    SizedBox(
                      width: 25,
                    ),
                    RaisedButton(
                        color: Colors.blue,
                        child: Text("Copy"),
                        onPressed: () => _copy(_IpAddress_USB_tether))
                  ],
                ),
                Row(
                  children: [
                    Text('USB_tether on: $_IpAddress_Blue_ther\n'),
                    RaisedButton(
                        color: Colors.blue,
                        child: Text("Copy"),
                        onPressed: () => _copy(_IpAddress_Blue_ther))
                  ],
                ),
                Text("IsHotspot:$_isHotspot"),
                Text("Iswifi:$_isWifi"),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$_ondeviceconnected2'),
                    RaisedButton(
                        color: Colors.blue,
                        child: Text("Copy"),
                        onPressed: () => setLisIp())
                  ],
                ),
                Text('Devices $_ondeviceconnected'),
                Text('wifi Name $_wifiname'),
                Text('All on: $_IpAddress_All\n'),
                RaisedButton(
                  color: Colors.blue,
                  child: Text("Share Me"),
                  onPressed: () async {
                    await AndroidIp.shareAPKFile;
                  },
                ),
                Text("status:$_status"),
                RaisedButton(
                  color: Colors.blue,
                  child: Text("Share Me"),
                  onPressed: () async {
                    setShare();
                  },
                ),
                RaisedButton(
                  color: Colors.blue,
                  child: Text("open Settings"),
                  onPressed: () async {
                    await AndroidIp.OpenSettings;
                  },
                ),
                RaisedButton(
                  color: Colors.blue,
                  child: Text("Enable wifi"),
                  onPressed: () async {
                    await AndroidIp.EnableWifi;
                  },
                ),
                RaisedButton(
                  color: Colors.blue,
                  child: Text("Enable Hotspot"),
                  onPressed: () async {
                    Hotspot hotspot = await AndroidIp.SetHotspotEnable;
                    print("======>${hotspot.encode()}");
                  },
                ),
                RaisedButton(
                  color: Colors.blue,
                  child: Text(
                      "Enable Permissions ${networkResult?.IsLocationEnabled} "),
                  onPressed: () async {
                    await AndroidIp.EnablePermission;
                  },
                ),
                RaisedButton(
                  color: Colors.blue,
                  child: Text("Storage"),
                  onPressed: () async {
                    await AndroidIp.EnableStoragePermission;
                  },
                ),
                RaisedButton(
                  color: Colors.blue,
                  child: Text("peer"),
                  onPressed: () async {
                    await AndroidIp.getP2pNames;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _copy(String ipAddress_Wifi) {
    var clipboardData = ClipboardData(text: ipAddress_Wifi);

    Clipboard.setData(clipboardData);
  }

  setLisIp() {
    setState(() {
      _ondeviceconnected2 = "";
    });

    var da = androidIp.onDeviceConnected!.listen((event) {
      setState(() {
        _ondeviceconnected2 = _ondeviceconnected2 + "," + event;
      });
    });
  }

  setShare() {
    setState(() {
      _status = "";
    });

    var da = androidIp.onShared!.listen((event) {
      setState(() {
        _status = event;
      });
    });
  }
}
