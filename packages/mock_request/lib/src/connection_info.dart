import 'dart:io';

class MockHttpConnectionInfo implements HttpConnectionInfo {
  @override
  final InternetAddress remoteAddress;
  @override
  final int localPort, remotePort;

  MockHttpConnectionInfo({required this.remoteAddress, this.localPort = -1, this.remotePort = -1});
}
