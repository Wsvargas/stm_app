import 'package:flutter/foundation.dart';
import '../models/unit_model.dart';
import '../dataconnect_generated/generated.dart';
import 'auth_service.dart';

class GroupsService extends ChangeNotifier {
  static final GroupsService instance = GroupsService._();
  GroupsService._();

  List<GroupModel> _groups = [];
  List<GroupModel> get groups => List.unmodifiable(_groups);

  Future<void> load() async {
    final dbId = AuthService.instance.currentAppUser?.dbId;
    if (dbId == null) return;

    final result = await ExampleConnector.instance
        .getGroupsForUser(userId: dbId)
        .execute();

    _groups = result.data.groupMembers.map((gm) {
      final g = gm.group;
      return GroupModel(
        id: g.id,
        name: g.name,
        unitId: g.unit.code,
        members: [],
      );
    }).toList();

    notifyListeners();
  }

  Future<List<GroupMemberModel>> loadMembers(String groupId) async {
    final result = await ExampleConnector.instance
        .listGroupMembers(groupId: groupId)
        .execute();

    return result.data.groupMembers.map((m) => GroupMemberModel(
      userId: m.user.uid,
      name: m.user.name,
      role: m.role,
    )).toList();
  }

  GroupModel? forUnit(String unitCode) {
    try {
      return _groups.firstWhere((g) => g.unitId == unitCode);
    } catch (_) {
      return null;
    }
  }
}
