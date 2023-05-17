export 'package:flutter/material.dart';
export 'package:flutter/foundation.dart' if (kIsWeb) 'dart.js'
    show context, JsObject;
//firebase imports
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:precious_gifts/firebase_options.dart';
export 'package:cloud_firestore/cloud_firestore.dart';

//import pages
export 'package:precious_gifts/auth/loginAuth.dart';
export 'package:precious_gifts/auth/signUpAuth.dart';
export 'package:precious_gifts/Login_page/login_page.dart';
export 'package:precious_gifts/SignUpPage/sign_up.dart';
export 'package:precious_gifts/imports/import.dart';
export 'package:precious_gifts/main.dart';
export 'package:precious_gifts/DirectorsForm/directors_form.dart';
