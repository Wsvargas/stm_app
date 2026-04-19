import 'package:flutter/foundation.dart';
import '../models/unit_model.dart';
import '../dataconnect_generated/generated.dart';
import 'auth_service.dart';

class ChatService extends ChangeNotifier {
  static final ChatService instance = ChatService._();
  ChatService._();

  final Map<String, List<MessageModel>> _cache = {};

  List<MessageModel> messagesForGroup(String groupId) =>
      List.from(_cache[groupId] ?? []);

  Future<List<MessageModel>> loadMessages(String groupId) async {
    final result = await ExampleConnector.instance
        .listMessages(groupId: groupId)
        .execute();

    final messages = result.data.messages.map((m) => MessageModel(
      id: m.id,
      groupId: groupId,
      senderId: m.sender.uid,
      senderName: m.sender.name,
      content: m.text,
      sentAt: DateTime.fromMillisecondsSinceEpoch(
          m.timestamp.seconds.toInt() * 1000),
    )).toList();

    _cache[groupId] = messages;
    notifyListeners();
    return messages;
  }

  Future<void> sendMessage({
    required String groupId,
    required String text,
  }) async {
    final user = AuthService.instance.currentAppUser;
    if (user == null) return;

    await ExampleConnector.instance.sendMessage(
      groupId: groupId,
      senderId: user.dbId,
      text: text,
    ).execute();

    // Optimistic local update
    _cache.putIfAbsent(groupId, () => []).add(MessageModel(
      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
      groupId: groupId,
      senderId: user.uid,
      senderName: user.name,
      content: text,
      sentAt: DateTime.now(),
    ));
    notifyListeners();
  }
}
