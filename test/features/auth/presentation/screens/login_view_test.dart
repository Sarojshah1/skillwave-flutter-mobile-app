import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:skillwave/features/auth/presentation/screens/login_view.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    whenListen(
      mockAuthBloc,
      Stream<AuthState>.empty(),
      initialState: AuthInitial(),
    );
  });

  testWidgets('LoginView renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const LoginView(),
          ),
        ),
      ),
    );

    // Verify that the login form elements are present
    expect(find.text('Login'), findsOneWidget);
    expect(find.text("Let's Sign In.!"), findsOneWidget);
    expect(
      find.text('Login to Your Account to Continue your Courses'),
      findsOneWidget,
    );
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text("Don't have an account? "), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('LoginView shows loading state', (WidgetTester tester) async {
    whenListen(
      mockAuthBloc,
      Stream.fromIterable([AuthLoading()]),
      initialState: AuthInitial(),
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const LoginView(),
          ),
        ),
      ),
    );

    await tester.pump();

    // Should show loading overlay with "Loading..." text
    expect(find.text('Loading...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
  });

  testWidgets('LoginView shows error state', (WidgetTester tester) async {
    whenListen(
      mockAuthBloc,
      Stream.fromIterable([AuthFailure(message: 'Login failed')]),
      initialState: AuthInitial(),
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const LoginView(),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 2)); // allow SnackBar to appear

    // Print all Text widget contents for debugging
    final textWidgets = find.byType(Text);
    tester.widgetList(textWidgets).forEach((widget) {
      final textWidget = widget as Text;
      // ignore: avoid_print
      print('Text widget: "${textWidget.data}"');
    });

    // The error message should be shown in a SnackBar
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Invalid credentials!'), findsOneWidget);
  });
}
