import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';

import 'splash_viewmodel.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      onModelReady: (model) =>
          SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        model.onStart();
      }),
      builder: (BuildContext context, SplashViewModel model, Widget? child) =>
          Scaffold(
        appBar: AppBar(
          title: const Text('Splash'),
        ),
      ),
      viewModelBuilder: () => SplashViewModel(),
    );
  }
}
