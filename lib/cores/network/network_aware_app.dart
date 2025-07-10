import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class NetworkAwareApp extends StatefulWidget {
  final RouterConfig<Object> routerConfig;
  final String? title;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final bool? debugShowCheckedModeBanner;
  const NetworkAwareApp({
    super.key,
    required this.routerConfig,
    this.title,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.scaffoldMessengerKey,
    this.debugShowCheckedModeBanner,
  });

  @override
  State<NetworkAwareApp> createState() => _NetworkAwareAppState();
}

class _NetworkAwareAppState extends State<NetworkAwareApp> {
  late final Stream<List<ConnectivityResult>> _connectivityStream;
  bool _isOffline = false;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  Key _appKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _connectivityStream = Connectivity().onConnectivityChanged;
    _subscription = _connectivityStream.listen((results) {
      final offline = results.contains(ConnectivityResult.none);
      if (offline != _isOffline) {
        setState(() {
          _isOffline = offline;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: _appKey,
      routerConfig: widget.routerConfig,
      title: widget.title ?? '',
      theme: widget.theme,
      darkTheme: widget.darkTheme,
      themeMode: widget.themeMode,
      scaffoldMessengerKey: widget.scaffoldMessengerKey,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner ?? false,
      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox(),
            if (_isOffline)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Material(
                  color: Colors.redAccent,
                  elevation: 8,
                  child: SafeArea(
                    bottom: false,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.wifi_off, color: Colors.white),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'No Internet Connection',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              final results = await Connectivity()
                                  .checkConnectivity();
                              final offline = results is List
                                  ? results.contains(ConnectivityResult.none)
                                  : results == ConnectivityResult.none;
                              if (!offline) {
                                setState(() {
                                  _isOffline = false;
                                  _appKey =
                                      UniqueKey(); 
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Reload',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.white.withOpacity(0.15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
