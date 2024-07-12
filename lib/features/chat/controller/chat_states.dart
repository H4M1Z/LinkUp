import 'package:flutter/material.dart';

@immutable
abstract class ChatScreenStates {}

@immutable
final class ChatInitialState extends ChatScreenStates {}

@immutable
final class ChatLoadingState extends ChatScreenStates {}

@immutable
final class ChatLoadedState extends ChatScreenStates {}
