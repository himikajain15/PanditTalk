import 'package:flutter/material.dart';
import '../utils/theme.dart';

PreferredSizeWidget saffronAppBar({required BuildContext context, required String title, List<Widget>? actions}) {
  return AppBar(
    title: Text(title),
    backgroundColor: AppTheme.saffron,
    actions: actions,
  );
}
