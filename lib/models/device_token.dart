class DeviceToken {
    final String deviceToken;
    final String associatedUserEmail;

    DeviceToken({this.deviceToken, this.associatedUserEmail});

    factory DeviceToken.fromMap(Map<String, dynamic> deviceTokenMap) {
      return DeviceToken(
        deviceToken: deviceTokenMap['deviceToken'],
        associatedUserEmail: deviceTokenMap['email'],
      );
    }
}