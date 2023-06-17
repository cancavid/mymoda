import 'package:flutter/material.dart';
import 'package:mymoda/themes/theme.dart';
import 'package:mymoda/themes/widgets/bottom_sheet.dart';
import 'package:mymoda/themes/widgets/headings.dart';

class SortFilter extends StatelessWidget {
  SortFilter({super.key, required this.onChanged, this.selected = 0});

  final Function(int) onChanged;
  final int selected;
  final List sorts = ['Ən yenilər', 'Əvvəlcə baha', 'Əvvəlcə ucuz'];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return MsBottomSheet(
                  static: true,
                  height: 250.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 15.0),
                        child: MsMediumHeading(title: 'Sıralama'),
                      ),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: sorts.length,
                          itemBuilder: (context, index) {
                            return RadioListTile(
                                title: Text(sorts[index]),
                                value: index,
                                groupValue: selected,
                                onChanged: (value) {
                                  onChanged(index);
                                });
                          }),
                    ],
                  ),
                );
              });
        },
        child: Container(
          color: Theme.of(context).colorScheme.backgroundColor,
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Icon(Icons.sort),
              SizedBox(
                width: 10.0,
              ),
              Text(sorts[selected])
            ],
          ),
        ),
      ),
    );
  }
}
