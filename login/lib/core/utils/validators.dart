class Validators {
  Validators._();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Invalid email format';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    return null;
  }

  static bool hasMinLength(String password) => password.length >= 8;
  static bool hasNumber(String password) => password.contains(RegExp(r'[0-9]'));
  static bool hasSpecialChar(String password) =>
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  static int passwordStrength(String password) {
    int strength = 0;
    if (hasMinLength(password)) strength++;
    if (hasNumber(password)) strength++;
    if (hasSpecialChar(password)) strength++;
    if (password.length >= 12) strength++;
    return strength; // 0-4
  }
}
