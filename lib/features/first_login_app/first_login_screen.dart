import 'package:flutter/material.dart';
import 'package:my_randevu/core/constants/app_strings.dart';
import 'package:my_randevu/core/widgets/buttons/text_button_started.dart';

part 'views/first_login_view_body.dart';

class FirstLoginScreen extends StatefulWidget {
  const FirstLoginScreen({super.key});

  @override
  State<FirstLoginScreen> createState() => _FirstLoginScreenState();
}

class _FirstLoginScreenState extends State<FirstLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _FirstLoginViewBody());
  }
}
