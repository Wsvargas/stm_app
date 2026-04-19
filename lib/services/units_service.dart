import 'package:flutter/foundation.dart';
import '../models/unit_model.dart';
import '../dataconnect_generated/generated.dart';
import 'auth_service.dart';

class UnitsService extends ChangeNotifier {
  static final UnitsService instance = UnitsService._();
  UnitsService._();

  List<UnitModel> _allUnits = [];
  final Set<String> _enrolledCodes = {};

  List<UnitModel> get allUnits => List.unmodifiable(_allUnits);
  List<UnitModel> get enrolledUnits =>
      _allUnits.where((u) => _enrolledCodes.contains(u.code)).toList();

  bool isEnrolled(String unitId) => _enrolledCodes.contains(unitId);

  Future<void> loadAll() async {
    final result = await ExampleConnector.instance
        .listAllUnits()
        .execute();

    _allUnits = result.data.units.map((u) => UnitModel(
      id: u.id,
      code: u.code,
      name: u.name,
      description: u.description ?? '',
      lecturerName: '',
    )).toList();

    await _loadEnrolled();
    notifyListeners();
  }

  Future<void> _loadEnrolled() async {
    final dbId = AuthService.instance.currentAppUser?.dbId;
    if (dbId == null) return;

    final result = await ExampleConnector.instance
        .listEnrolledUnits(studentId: dbId)
        .execute();

    _enrolledCodes
      ..clear()
      ..addAll(result.data.enrollments.map((e) => e.unit.code));
  }

  Future<void> enroll(String unitId) async {
    final dbId = AuthService.instance.currentAppUser?.dbId;
    if (dbId == null) return;

    final unit = _allUnits.firstWhere((u) => u.id == unitId);
    await ExampleConnector.instance
        .enrollInUnit(studentId: dbId, unitId: unit.id)
        .execute();

    _enrolledCodes.add(unit.code);
    notifyListeners();
  }

  Future<void> drop(String unitId) async {
    final dbId = AuthService.instance.currentAppUser?.dbId;
    if (dbId == null) return;

    final unit = _allUnits.firstWhere((u) => u.id == unitId);
    await ExampleConnector.instance
        .dropUnit(studentId: dbId, unitId: unit.id)
        .execute();

    _enrolledCodes.remove(unit.code);
    notifyListeners();
  }

  UnitModel? findById(String id) {
    try { return _allUnits.firstWhere((u) => u.id == id); } catch (_) { return null; }
  }

  UnitModel? findByCode(String code) {
    try { return _allUnits.firstWhere((u) => u.code == code); } catch (_) { return null; }
  }
}
