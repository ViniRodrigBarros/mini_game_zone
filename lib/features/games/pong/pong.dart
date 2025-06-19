import 'package:flutter/material.dart';
import './pong_view.dart';

class Pong extends StatefulWidget {
  static const route = '/Pong/';
  const Pong({super.key});

  @override
  PongView createState() => PongView();
}
