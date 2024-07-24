import 'package:flutter/material.dart';

class Component {
  Component({required this.name, required this.quantity, image})
      : image = Image.asset("assets/images/defaultComponent.png");
  String name;
  int quantity;
  Image image;
}
