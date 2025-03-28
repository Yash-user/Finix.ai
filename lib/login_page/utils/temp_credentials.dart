class TempCredentials {
  static const Map<String, String> users = {
    'test@example.com': 'Test123456',
    'abc@example.com': 'password'
  };

  static bool validateCredentials(String email, String password) {
    return users[email] == password;
  }
}