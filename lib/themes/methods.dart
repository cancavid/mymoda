import 'package:flutter/material.dart';
import 'package:mymoda/themes/theme.dart';

Future<dynamic> customAlert(
    BuildContext context, icon, text, mainButtonText, mainOnTap,
    [secondButtonText = '', secondOnTap = '']) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        alignment: Alignment.center,
        icon: Icon(icon, size: 55.0),
        titleTextStyle: TextStyle(fontSize: 18.0, color: Colors.black),
        title: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(height: 1.4),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        actionsPadding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
        actions: [
          Row(
            children: [
              if (secondButtonText != '') ...[
                Expanded(
                  child: GestureDetector(
                    onTap: secondOnTap,
                    child: Container(
                      alignment: Alignment.center,
                      height: 45.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Theme.of(context).colorScheme.lightColor),
                      child: Text(secondButtonText),
                    ),
                  ),
                ),
                SizedBox(width: 15.0)
              ],
              Expanded(
                child: GestureDetector(
                  onTap: mainOnTap,
                  child: Container(
                    alignment: Alignment.center,
                    height: 45.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Theme.of(context).colorScheme.secondColor),
                    child: Text(mainButtonText,
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          )
        ],
      );
    },
  );
}
