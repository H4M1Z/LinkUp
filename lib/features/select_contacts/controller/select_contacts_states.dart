import 'package:flutter/material.dart';

@immutable
abstract class SelectContactsScreenStates {}

@immutable
final class SelectContactsInitialState extends SelectContactsScreenStates {}

@immutable
final class SelectContactsLoadingState extends SelectContactsScreenStates {}

@immutable
final class SelectContactsLoadedStatee extends SelectContactsScreenStates {}
