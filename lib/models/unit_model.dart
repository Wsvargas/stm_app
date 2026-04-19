class UnitModel {
  final String id;
  final String code;
  final String name;
  final String description;
  final String lecturerName;

  const UnitModel({
    required this.id,
    required this.code,
    required this.name,
    this.description = '',
    this.lecturerName = '',
  });
}

class GroupMemberModel {
  final String userId;
  final String name;
  final String role; // 'Leader' | 'Member'

  const GroupMemberModel({
    required this.userId,
    required this.name,
    required this.role,
  });
}

class GroupModel {
  final String id;
  final String name;
  final String unitId;
  final List<GroupMemberModel> members;

  const GroupModel({
    required this.id,
    required this.name,
    required this.unitId,
    required this.members,
  });
}

class MessageModel {
  final String id;
  final String groupId;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime sentAt;

  MessageModel({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.sentAt,
  });
}
