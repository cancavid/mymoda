import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymoda/controllers/welcome_controller.dart';
import 'package:mymoda/themes/theme.dart';

class FinalButton extends StatefulWidget {
  const FinalButton({
    Key? key,
  }) : super(key: key);

  @override
  State<FinalButton> createState() => _FinalButtonState();
}

class _FinalButtonState extends State<FinalButton> {
  var welcomeController = Get.put(WelcomeController());
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        welcomeController.update(false);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 50.0,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondColor, borderRadius: BorderRadius.circular(30.0)),
        child: const Center(
          child: Text(
            'Başla',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
