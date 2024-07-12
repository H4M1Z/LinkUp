import 'package:flutter/material.dart';

@immutable
abstract class CallState {}

@immutable
final class CallInitialState extends CallState {}

@immutable
final class CallLoadingState extends CallState {}

@immutable
final class CallLoadedState extends CallState {}
