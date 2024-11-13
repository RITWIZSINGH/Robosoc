import 'package:flutter/material.dart';

//profile page component class

class Component {
  Component({required this.name, required this.quantity, image})
      : image = Image.asset("assets/images/defaultComponent.png");
  String name;
  int quantity;
  Image image;
}
