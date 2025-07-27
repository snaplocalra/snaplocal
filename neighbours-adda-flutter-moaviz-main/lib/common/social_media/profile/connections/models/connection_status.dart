enum ConnectionStatus {
  notConnected("not_connected"),
  requestPending("request_pending"),
  connected("connected");

  final String jsonValue;

  const ConnectionStatus(this.jsonValue);

  factory ConnectionStatus.fromString(String? data) {
    switch (data) {
      case "not_connected":
        return notConnected;
      case "request_pending":
        return requestPending;
      case "connected":
        return connected;
      default:
        throw "Invalid Connection Status";
    }
  }
}
