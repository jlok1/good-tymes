import 'package:flutter/widgets.dart';
import 'package:good_tymes/models/user.dart';
import 'package:good_tymes/services/auth_services.dart';

class MyUserProvider with ChangeNotifier {
  MyUser? _user;
  final AuthServices _authServices = AuthServices();

  MyUser get getUser => _user!;

  Future<void> refreshUser() async {
    MyUser user = await _authServices.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
