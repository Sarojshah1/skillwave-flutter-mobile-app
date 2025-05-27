import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillwave/cores/shared_prefs/user_shared_prefs.dart';
import 'package:skillwave/features/welcomescreens/presentation/bloc/obBoardingBloc/onboarding_cubit.dart';

@module
abstract class InjectionModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
  @lazySingleton
  OnboardingCubit get onboardingCubit => OnboardingCubit();
  @lazySingleton
  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey => GlobalKey<ScaffoldMessengerState>();
  @lazySingleton
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();
  @lazySingleton
  Dio get dio => Dio();


}
