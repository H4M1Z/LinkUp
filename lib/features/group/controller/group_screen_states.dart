import 'package:flutter/material.dart';

@immutable
abstract class GroupScreenState {}

@immutable
final class GroupScreenInitialState extends GroupScreenState {}

@immutable
final class GroupScreenLoadingState extends GroupScreenState {}

@immutable
final class GroupScreenLoadedState extends GroupScreenState {}
