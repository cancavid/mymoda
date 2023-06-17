import 'package:flutter/material.dart';
import 'package:mymoda/themes/theme.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key, required this.onTap});

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Theme.of(context).colorScheme.backgroundColor,
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: const [
              Icon(Icons.filter_alt_outlined),
              SizedBox(
                width: 10.0,
              ),
              Text('Filter')
            ],
          ),
        ),
      ),
    );
  }
}
