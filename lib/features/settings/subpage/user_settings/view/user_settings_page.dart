import 'package:flutter/material.dart';

import '../../../../authentication/authentication_welcome/view/authentication_welcome_page.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // eğer kullanıcı yoksa burda splasda gösterdiğin login register ekranını göstericem eğer kullanıcı giriş yaptıysa backup kısmını göster ama bundan önce kullanıcı kontrol sistemini yazmalısın

    return Scaffold(
        appBar: AppBar(
          title: Text("User Settings"),
        ),
        body: AuthWelcomePage());
  }
}
