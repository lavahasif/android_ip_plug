class PortScanrResult {
  String? port;
  String? success;
  String? ip;

  PortScanrResult(
      {required this.port, required this.success, required this.ip});

  PortScanrResult.fromJson(Map<String, dynamic> json) {
    port = json['port'];
    success = json['success'];
    ip = json['ip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['port'] = this.port;
    data['success'] = this.success;
    data['ip'] = this.ip;
    return data;
  }
}
