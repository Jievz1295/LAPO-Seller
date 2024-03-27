import 'package:flutter/material.dart';

circularProgress()
{
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12),
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
          Colors.green,
       ),
    ),
  );
}

LinearProgress()
{
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12),
    child: const LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
          Color.fromARGB(255, 0, 38, 255),
       ),
    ),
  );
}