import 'package:flutter/material.dart';
import 'package:green_track/pages/shared/app_bar.dart';
import 'package:green_track/pages/wizard_page/step/wizard_step_transports.dart';

class WizardPage extends StatelessWidget {
  const WizardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: GreenTrackAppBar(), body: WizardStepTransports());
  }
}
