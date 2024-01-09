import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowcaseBloc extends Bloc<GlobalKey, GlobalKey> {
  ShowcaseBloc() : super(GlobalKey());

  List<GlobalKey> keys = List.generate(10, (_) => GlobalKey());

  int currentKey = 0;
}
