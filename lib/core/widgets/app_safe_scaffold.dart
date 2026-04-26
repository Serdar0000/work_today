import 'package:flutter/material.dart';

/// [Scaffold] с корректными отступами: **без** внешнего [SafeArea] вокруг всего каркаса
/// (он даёт «чёрную полосу» над контентом — незакрашенная зона под status bar).
///
/// [SafeArea] только у [body] (и у [bottomNavigationBar], если есть).
/// При наличии [AppBar] верхний inset у [body] не дублируется ([top: false]).
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
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.scaffoldBackgroundColor;
    final bottomBar = bottomNavigationBar;

    final paddedBody = SafeArea(
      top: appBar == null,
      left: true,
      right: true,
      bottom: bottomBar == null,
      minimum: EdgeInsets.zero,
      child: body,
    );

    return Scaffold(
      extendBody: extendBody,
      backgroundColor: bg,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
      body: paddedBody,
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
    );
  }
}
