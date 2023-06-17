import 'package:flutter/material.dart';
import 'package:mymoda/themes/widgets/buttons.dart';

class MsModal extends StatelessWidget {
  const MsModal({
    Key? key,
    required this.title,
    this.description = '',
    required this.buttons,
  }) : super(key: key);

  final String title;
  final String description;
  final List buttons;

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttonWidgets = buttons.map<Widget>((button) {
      return Expanded(
        child: MsButton(
          onTap: () {
            button[2]();
          },
          title: button[0],
          style: button[1],
        ),
      );
    }).toList();

    final count = buttonWidgets.length;

    final List<Widget> contentWidgets = [
      Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 21.0,
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ];

    if (description.isNotEmpty) {
      contentWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
          child: Text(
            description,
            style: TextStyle(fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    contentWidgets.add(
      Row(
        children: <Widget>[
          for (int i = 0; i < count; i++) ...[
            buttonWidgets[i],
            if (i != count - 1) ...[
              SizedBox(width: 10.0),
            ]
          ],
        ],
      ),
    );

    return Column(
      children: contentWidgets,
    );
  }
}
