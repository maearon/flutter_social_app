import 'dart:convert';
import 'package:crypto/crypto.dart';

class GravatarUtil {
  static String getGravatarUrl(String email, {int size = 80}) {
    final hash = md5.convert(utf8.encode(email.trim().toLowerCase())).toString();
    return 'https://secure.gravatar.com/avatar/$hash?s=$size';
  }
}
