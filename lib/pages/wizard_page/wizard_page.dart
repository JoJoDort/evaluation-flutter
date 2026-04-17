import 'package:flutter/material.dart';
import 'package:green_track/pages/results_page/results_page.dart';
import 'package:green_track/pages/shared/app_bar.dart';
import 'package:green_track/pages/wizard_page/step/wizard_step_consumption.dart';
import 'package:green_track/pages/wizard_page/step/wizard_step_housing.dart';
import 'package:green_track/pages/wizard_page/step/wizard_step_transports.dart';
import 'package:green_track/pages/shared/ProgressBar.dart';
import 'package:green_track/pages/shared/BottomBar.dart';

class WizardPage extends StatefulWidget {
  const WizardPage({super.key});
  @override
  State<WizardPage> createState() => _WizardPageState();
}

class _WizardPageState extends State<WizardPage> {
  int _currentStep = 0;
  final int _totalSteps = 3; // 1. Transports, 2. Logement, 3. Consommation

  void _onStepChanged(int step) {
    setState(() => _currentStep = step);
  }

  void _next() {
    if (_currentStep < _totalSteps) _onStepChanged(_currentStep + 1);
  }

  void _previous() {
    if (_currentStep > 0) _onStepChanged(_currentStep - 1);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentStep == _totalSteps) {
      return const Scaffold(appBar: GreenTrackAppBar(), body: ResultsPage());
    }

    return Scaffold(
      appBar: GreenTrackAppBar(
        bottom: WizardProgressBar(
          currentStep: _currentStep + 1,
          totalSteps: _totalSteps,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: IndexedStack(
          index: _currentStep,
          children: <Widget>[
            WizardStepTransports(onNext: _next),
            //WizardStepHousing(onNext: _next),
            //WizardStepConsumption(onNext: _next),
          ],
        ),
      ),
      bottomNavigationBar: WizardBottomBar(
        onCancel: _previous,
        onContinue: _next,
      ),
    );
  }
}
