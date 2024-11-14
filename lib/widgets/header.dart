import 'package:flutter/material.dart';

import '../responsive.dart';
import '../services/utils.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.fct,
    required this.title,
  });

  final Function fct;
  final String title;
  @override
  Widget build(BuildContext context) {
    final color = Utils(context).color;
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(
              Icons.menu,
              color: color,
            ),
            onPressed: () {
              fct();
            },
          ),
        if (Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 40),
            ),
          ),
        if (Responsive.isDesktop(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
      ],
    );
  }
}
