import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:green_track/providers/carbon_provider.dart';
import 'package:green_track/l10n/app_localizations.dart';
import 'package:green_track/res/app_colors.dart';
import 'package:green_track/res/app_icons.dart'; // N'oublie pas cet import

class WizardStepTransports extends StatelessWidget {
  const WizardStepTransports({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final CarbonProvider provider = context.watch<CarbonProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          SizedBox(
            height: 33,
            child: Text(
              l10n.section_transports,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 38),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCarSection(provider),
                  const SizedBox(height: 30),
                  _buildBikeSection(provider),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // === SECTION VOITURE ===
  Widget _buildCarSection(CarbonProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(AppIcons.car, color: AppColors.primaryDark),
            ),
            const SizedBox(width: 12),
            const Text(
              'En voiture',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMileageRow('Kilomètres / an :', provider.carKm),
              const SizedBox(height: 43),
              _buildSliderMileage(
                value: provider.carKm,
                max: 24000,
                onChanged: (double newValue) {
                  provider.updateCarKm(newValue);
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Passagers en moyenne : ${provider.passengers}',
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 12),
              _buildPassengerSelector(provider),
            ],
          ),
        ),
      ],
    );
  }

  // === SECTION VÉLO ===
  Widget _buildBikeSection(CarbonProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(AppIcons.bike, color: AppColors.primaryDark),
            ),
            const SizedBox(width: 12),
            const Text(
              'À vélo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Type : ${provider.isElectricBike ? 'Electrique' : 'Musculaire'}",
              ),
              _buildBikeTypeSelector(provider),
              const SizedBox(height: 20),
              _buildMileageRow('Kilomètres / an :', provider.bikeKm),
              const SizedBox(height: 43),
              _buildSliderMileage(
                value: provider.bikeKm,
                max: 2000,
                onChanged: (double newValue) {
                  provider.updateBikeKm(newValue);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMileageRow(String label, double value) {
    return SizedBox(
      width: double.infinity,
      height: 19,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          Text(
            '${value.toInt()} km',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderMileage({
    required double value,
    required double max,
    required Function(double) onChanged,
  }) {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: SliderTheme(
        data: SliderThemeData(
          trackHeight: 16.0,
          activeTrackColor: AppColors.secondary,
          inactiveTrackColor: AppColors.white,
          thumbColor: AppColors.primaryDark,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
          overlayShape: SliderComponentShape.noOverlay,
        ),
        child: Slider(value: value, min: 0, max: max, onChanged: onChanged),
      ),
    );
  }

  Widget _buildPassengerSelector(CarbonProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildPassengerButton('1', 1, provider),
        _buildPassengerButton('2', 2, provider),
        _buildPassengerButton('3', 3, provider),
        _buildPassengerButton('4', 4, provider),
        _buildPassengerButton('5+', 5, provider),
      ],
    );
  }

  Widget _buildPassengerButton(
    String label,
    int value,
    CarbonProvider provider,
  ) {
    final bool isSelected = provider.passengers == value;

    return GestureDetector(
      onTap: () {
        provider.updatePassengers(value);
      },
      child: Container(
        width: 43,
        height: 43,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
      ),
    );
  }

  Widget _buildBikeTypeSelector(CarbonProvider provider) {
    return Row(
      children: [
        Expanded(
          child: _buildBikeTypeButton(
            label: 'Musculaire',
            isSelected: !provider.isElectricBike,
            onTap: () => provider.updateIsElectricBike(false),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildBikeTypeButton(
            label: 'Electrique',
            isSelected: provider.isElectricBike,
            onTap: () => provider.updateIsElectricBike(true),
          ),
        ),
      ],
    );
  }

  Widget _buildBikeTypeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 41,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10), // #000000 à 10%
                    blurRadius: 4,
                    offset: const Offset(0, 0), // X=0, Y=0
                  ),
                ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600, // SemiBold
            color: AppColors.primaryDark,
          ),
        ),
      ),
    );
  }
}
