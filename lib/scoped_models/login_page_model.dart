import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginPageModel extends Model {
  String title = 'Hello world!';
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
}
