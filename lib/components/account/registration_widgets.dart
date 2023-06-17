import 'package:flutter/material.dart';
import 'package:mymoda/themes/theme.dart';

class RegAdvantages extends StatelessWidget {
  const RegAdvantages({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(color: MsColors.text, borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Niyə hesab yaratmalıyam?', style: TextStyle(color: Color(0xFF2b6991), fontWeight: FontWeight.w600, fontSize: 16.0)),
          SizedBox(height: 15.0),
          RegAdvantage(heading: 'Səbət və istək listin hər yerdən əlçatımlı olsun.'),
          SizedBox(height: 10.0),
          RegAdvantage(heading: 'Sifarişlər zamanı avtomatik məlumatlarınız qeydə alınsın.'),
          SizedBox(height: 10.0),
          RegAdvantage(heading: 'Sifariş tarixinizə istədiyiniz vaxt nəzər salın.'),
        ],
      ),
    );
  }
}

class RegAdvantage extends StatelessWidget {
  final String heading;

  const RegAdvantage({Key? key, required this.heading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Icon(Icons.check, color: Colors.orange, size: 17.0),
        ),
        SizedBox(width: 10.0),
        Expanded(child: Text(heading, style: TextStyle(color: Color(0xFF2b6991), height: 1.4))),
      ],
    );
  }
}
