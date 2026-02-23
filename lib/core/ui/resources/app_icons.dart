import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppIcons {
  static bool isIOS = Platform.isIOS;

  static IconData get settings {
    if (isIOS) return CupertinoIcons.gear_solid;
    return Icons.settings;
  }

  static IconData get send => Icons.send;

  static IconData get plus {
    if (isIOS) return CupertinoIcons.plus;
    return Icons.add;
  }

  static IconData get email {
    if (isIOS) return CupertinoIcons.envelope;
    return Icons.email;
  }

  static IconData get lock {
    if (isIOS) return CupertinoIcons.lock;
    return Icons.lock;
  }

  static IconData get eye {
    if (isIOS) return CupertinoIcons.eye;
    return Icons.visibility;
  }

  static IconData get eyeOff {
    if (isIOS) return CupertinoIcons.eye_slash;
    return Icons.visibility_off;
  }

  static IconData get user {
    if (isIOS) return CupertinoIcons.person;
    return Icons.person;
  }
}
