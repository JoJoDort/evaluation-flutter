import 'package:flutter/material.dart';

enum TypeEnergie {
  bois(2),
  electricite(5),
  gaz(20);

  final int value;
  const TypeEnergie(this.value);
}

class CarbonProvider extends ChangeNotifier {
  // --- Données ---
  // Voiture
  double carKm = 12000.0;
  int passengers = 1;
  // Vélo
  bool isElectricBike = false;
  double bikeKm = 1000.0;

  // Logement
  bool isApart = true;
  double surface = 50.0;
  TypeEnergie energie = TypeEnergie.bois;

  // Consommation
  bool isNewEquipment = true;

  // --- Setters ---
  void updateCarKm(double newValue) {
    carKm = newValue;
    notifyListeners();
  }

  void updateBikeKm(double newValue) {
    bikeKm = newValue;
    notifyListeners();
  }

  void updatePassengers(int newValue) {
    passengers = newValue;
    notifyListeners();
  }

  void updateIsElectricBike(bool newValue) {
    isElectricBike = newValue;
    notifyListeners();
  }

  // --- Calculs des sous-scores ---
  double get scoreVoiture {
    return (carKm * 0.14 + (1 + (passengers - 1) * 0.05)) / passengers;
  }

  double get scoreVelo {
    return isElectricBike ? 0 : 0.0015 * bikeKm;
  }

  double get bonusSante {
    int nBonus = bikeKm ~/ 1000;
    return nBonus * 0.02;
  }

  double get scoreHousing {
    double multiplicateur = isApart ? 0.8 : 1.2;
    return surface * multiplicateur * (energie.value);
  }

  double get scoreConsumption {
    return isNewEquipment ? 1 : 1.3;
  }

  // --- Score Total ---
  double calculateTotal() {
    return ((scoreVoiture + scoreVelo + scoreHousing) * scoreConsumption) *
        (1 - bonusSante);
  }

  // --- Compensation ---
  int get treesToPlant {
    return (calculateTotal() * 25).round();
  }
}
