class Validators {
  static String? validateName(String? value) {
    return (value == null || value.isEmpty) ? 'Enter name' : null;
  }

  static String? validateAge(String? value) {
    final age = int.tryParse(value ?? '');
    if (age == null || age <= 0 || age > 100) return 'Enter valid age';
    return null;
  }

  static String? validateEmail(String? value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
    return (value == null || !emailRegex.hasMatch(value))
        ? 'Enter valid email'
        : null;
  }

  static String? validatePhone(String? value) {
    return (value == null || !RegExp(r'^\d{10}$').hasMatch(value))
        ? 'Enter valid 10-digit phone number'
        : null;
  }
}
