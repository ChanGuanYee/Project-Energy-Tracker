import 'package:flutter/material.dart';
import 'dart:math';
import 'appliance.dart';
import 'data_service.dart';

class ApplianceProvider with ChangeNotifier {
  List<Appliance> _appliances = [];
  bool _isLoading = false;
  String? _errorMessage;
  final DataService _dataService = DataService();

  List<Appliance> get appliances => _appliances;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get totalDailyKwh {
    return _appliances.fold(0, (sum, item) => sum + item.dailyEnergyKwh);
  }

  double get totalMonthlyKwh => totalDailyKwh * 30;

  double get estimatedMonthlyCostRM {
    double monthlyKwh = totalMonthlyKwh;
    double totalCost = 0.0;
    double remainingKwh = monthlyKwh;

    if (remainingKwh == 0) return 0.0;

    if (remainingKwh > 0) {
      double billable = remainingKwh > 200 ? 200 : remainingKwh;
      totalCost += billable * 0.218;
      remainingKwh -= billable;
    }

    if (remainingKwh > 0) {
      double billable = remainingKwh > 100 ? 100 : remainingKwh;
      totalCost += billable * 0.334;
      remainingKwh -= billable;
    }

    if (remainingKwh > 0) {
      double billable = remainingKwh > 300 ? 300 : remainingKwh;
      totalCost += billable * 0.516;
      remainingKwh -= billable;
    }

    if (remainingKwh > 0) {
      double billable = remainingKwh > 300 ? 300 : remainingKwh;
      totalCost += billable * 0.546;
      remainingKwh -= billable;
    }

    if (remainingKwh > 0) {
      totalCost += remainingKwh * 0.571;
    }

    return totalCost > 0 && totalCost < 3.00 ? 3.00 : totalCost;
  }

  Future<void> loadData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _appliances = await _dataService.fetchAppliances();
    } catch (e) {
      _errorMessage = "Failed to load data. Please try again.";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addAppliance(Appliance appliance) async {
    _appliances.add(appliance);
    notifyListeners();
    
    try {
      await _dataService.saveAppliance(appliance); 
    } catch (e) {
      _errorMessage = "Failed to save data.";
      notifyListeners();
    }
  }

  Future<void> deleteAppliance(String id) async {
    _appliances.removeWhere((item) => item.id == id);
    notifyListeners();
    try {
      await _dataService.deleteAppliance(id);
    } catch (e) {
      _errorMessage = "Failed to delete.";
      notifyListeners();
    }
  }

  Future<void> updateAppliance(Appliance updatedAppliance) async {
    final index = _appliances.indexWhere((item) => item.id == updatedAppliance.id);
    if (index != -1) {
      _appliances[index] = updatedAppliance;
      notifyListeners();
      try {
        await _dataService.saveAppliance(updatedAppliance);
      } catch (e) {
        _errorMessage = "Failed to update.";
        notifyListeners();
      }
    }
  }

  final List<String> _shortTips = [
    "Always switch off unused appliances at the wall plug.",
    "Use LED light bulbs to reduce lighting energy by 75%.",
    "Clean your Air Conditioner filters monthly for better efficiency.",
    "Utilize natural sunlight during the day instead of lamps.",
    "Unplug fully charged devices to prevent vampire power draw."
  ];

  String get randomTip => _shortTips[Random().nextInt(_shortTips.length)];
}