// import 'package:otp/otp.dart';

// class TwoFactorAuth {
//   static final _issuer = 'My App';

//   // Generate a new secret key for the user to store
//   static String generateSecret() {
//     final random = Random.secure();
//     final List<int> values = List.generate(32, (index) => random.nextInt(256));
//     return base32.encode(values);
//   }

//   // Generate a new QR code URL based on the user's secret key
//   static String generateQRCodeUrl(String user, String secret) {
//     final uri = Uri.encodeFull('otpauth://totp/$_issuer:$user?secret=$secret&issuer=$_issuer');
//     return 'https://api.qrserver.com/v1/create-qr-code/?data=$uri&size=200x200';
//   }

//   // Verify the provided one-time password against the user's secret key
//   static bool verify(String secret, String otp) {
//     return OTP.verify(otp, secret);
//   }

//   // Generate a new one-time password for the user to use
//   static String generateOneTimePassword(String secret) {
//     return OTP.generateTOTPCodeString(secret, DateTime.now().millisecondsSinceEpoch);
//   }

//   // Generate a new TOTP URI for the user to use
//   static String generateTOTPUri(String user, String secret) {
//     final uri = Uri.encodeFull('otpauth://totp/$_issuer:$user?secret=$secret&issuer=$_issuer');
//     return uri;
//   }

//   // Hash the user's password for storage in the database
//   static String hashPassword(String password) {
//     final bytes = utf8.encode(password);
//     final digest = sha256.convert(bytes);
//     return digest.toString();
//   }
// }
