import 'package:flutter/material.dart';
import 'package:gossip_go/models/user_model.dart';

@immutable
abstract class AuthStates {
  const AuthStates();
}

@immutable
final class AuthLoadingState extends AuthStates {}

@immutable
final class AuthLoadedState extends AuthStates {
  final UserModel? user;
  const AuthLoadedState({this.user});
}

@immutable
final class AuthInitialState extends AuthStates {}

@immutable
final class AuthErrorState extends AuthStates {
  final String message;
  const AuthErrorState({required this.message});
}
