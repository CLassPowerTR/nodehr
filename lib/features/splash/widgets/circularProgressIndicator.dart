part of '../splash_screen.dart';

CircularProgressIndicator _loadingIndicator(BuildContext context) {
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
  );
}
