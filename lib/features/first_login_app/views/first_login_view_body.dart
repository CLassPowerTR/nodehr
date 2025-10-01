part of '../first_login_screen.dart';

class _FirstLoginViewBody extends StatefulWidget {
  const _FirstLoginViewBody({super.key});

  @override
  State<_FirstLoginViewBody> createState() => __FirstLoginViewBodyState();
}

class __FirstLoginViewBodyState extends State<_FirstLoginViewBody> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          textButtonStarted(context, AppStrings.businessLogin, () {}),
          textButtonStarted(context, AppStrings.customerLogin, () {}),
        ],
      ),
    );
  }
}
