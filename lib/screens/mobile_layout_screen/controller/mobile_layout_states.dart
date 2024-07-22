import 'package:flutter/material.dart';

@immutable
abstract class ContactsScreenStates {
  const ContactsScreenStates();
}

@immutable
final class ContactScreenInitialState extends ContactsScreenStates {}

@immutable
final class ContactScreenLoadingState extends ContactsScreenStates {}

@immutable
final class ContactScreenLoadedState extends ContactsScreenStates {}
