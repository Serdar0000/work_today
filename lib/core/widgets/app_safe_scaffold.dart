import 'package:flutter/material.dart';

/// [Scaffold] внутри [SafeArea] по верху и бокам, чтобы тулбар и контент
/// не заходили под status bar / вырез (в т.ч. при edge-to-edge).
///
/// Если задан [bottomNavigationBar], нижний inset применяется только к нему,
/// чтобы не дублировать отступ у [body].
class AppSafeScaffold extends StatelessWidget {
  const AppSafeScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.extendBody = false,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool extendBody;

  @override
  Widget build(BuildContext context) {
    final bottomBar = bottomNavigationBar;
    return SafeArea(
      minimum: EdgeInsets.zero,
      top: true,
      left: true,
      right: true,
      bottom: bottomBar == null,
      child: Scaffold(
        extendBody: extendBody,
        backgroundColor: backgroundColor,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
        body: body,
        bottomNavigationBar: bottomBar == null
            ? null
            : SafeArea(
                top: false,
                left: false,
                right: false,
                bottom: true,
                minimum: EdgeInsets.zero,
                child: bottomBar,
              ),
      ),
    );
  }
}
