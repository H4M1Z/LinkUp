import 'package:flutter/material.dart';

@immutable
abstract class SplashScreenStates {}

@immutable
final class SplashScreenInitialState extends SplashScreenStates {}

@immutable
final class SplashScreenLoadingState extends SplashScreenStates {}

@immutable
final class SplashScreenLoadedState extends SplashScreenStates {}
