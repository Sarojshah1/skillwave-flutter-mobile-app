import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final String? title;
  final bool showAppBar;
  final List<Widget>? actions;
  final Widget body;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;
  final bool centerTitle;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final Color? backgroundColor;
  final PreferredSizeWidget? customAppBar;

  const CommonScaffold({
    super.key,
    required this.body,
    this.title,
    this.showAppBar = true,
    this.actions,
    this.drawer,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
    this.centerTitle = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.backgroundColor,
    this.customAppBar,
  });

  @override
  Widget build(BuildContext context) {
    final scaffoldBody = SafeArea(
      top: safeAreaTop,
      bottom: safeAreaBottom,
      child: body,
    );

    return Scaffold(
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: showAppBar
          ? (customAppBar ??
          AppBar(
            title: title != null ? Text(title!) : null,
            centerTitle: centerTitle,
            actions: actions,
          ))
          : null,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      body: scaffoldBody,
    );
  }
}
