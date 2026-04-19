import 'package:flutter/material.dart';
import '../models/unit_model.dart';
import '../services/chat_service.dart';

class GroupChatPage extends StatefulWidget {
  final GroupModel group;
  const GroupChatPage({super.key, required this.group});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  bool _refreshing = false;
  bool _refreshBlocked = false;

  @override
  void initState() {
    super.initState();
    ChatService.instance.loadMessages(widget.group.id);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    if (_refreshBlocked || _refreshing) return;
    setState(() { _refreshing = true; _refreshBlocked = true; });
    await ChatService.instance.loadMessages(widget.group.id);
    if (mounted) setState(() => _refreshing = false);
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) setState(() => _refreshBlocked = false);
    });
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    ChatService.instance.sendMessage(
      groupId: widget.group.id,
      text: text,
    );
    _ctrl.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    if (dt.day == now.day && dt.month == now.month) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '${dt.day}/${dt.month} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        title: Row(children: [
          CircleAvatar(
            radius: 16,
            backgroundColor:
                const Color(0xFF4A7BFF).withValues(alpha: 0.2),
            child: const Icon(Icons.group,
                color: Color(0xFF4A7BFF), size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.group.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              Text('${widget.group.members.length} members',
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 11)),
            ],
          ),
        ]),
        actions: [
          IconButton(
            tooltip: _refreshBlocked ? 'Wait 30 s' : 'Refresh',
            onPressed: (_refreshBlocked || _refreshing) ? null : _refresh,
            icon: _refreshing
                ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(
                        color: Color(0xFF4A7BFF), strokeWidth: 2))
                : Icon(Icons.refresh,
                    color: _refreshBlocked
                        ? Colors.white24
                        : const Color(0xFF4A7BFF)),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Messages ───────────────────────────────────
          Expanded(
            child: ListenableBuilder(
              listenable: ChatService.instance,
              builder: (context, _) {
                final msgs = ChatService.instance
                    .messagesForGroup(widget.group.id);
                if (msgs.isEmpty) {
                  return const Center(
                    child: Text('No messages yet. Say hello!',
                        style: TextStyle(
                            color: Colors.white38, fontSize: 13)),
                  );
                }
                return ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  itemCount: msgs.length,
                  itemBuilder: (_, i) {
                    final msg = msgs[i];
                    final isMe = msg.senderId == 'me';
                    return _Bubble(
                      msg: msg,
                      isMe: isMe,
                      timeStr: _formatTime(msg.sentAt),
                    );
                  },
                );
              },
            ),
          ),

          // ── Input bar ───────────────────────────────────
          Container(
            color: const Color(0xFF111111),
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: SafeArea(
              top: false,
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    style: const TextStyle(color: Colors.white),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle:
                          const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A7BFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send,
                        color: Colors.white, size: 18),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final MessageModel msg;
  final bool isMe;
  final String timeStr;
  const _Bubble(
      {required this.msg, required this.isMe, required this.timeStr});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor:
                  const Color(0xFF4A7BFF).withValues(alpha: 0.15),
              child: Text(
                msg.senderName.isNotEmpty
                    ? msg.senderName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                    color: Color(0xFF4A7BFF),
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 2),
                    child: Text(msg.senderName,
                        style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe
                        ? const Color(0xFF4A7BFF)
                        : const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                  ),
                  child: Text(msg.content,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 14)),
                ),
                const SizedBox(height: 2),
                Text(timeStr,
                    style: const TextStyle(
                        color: Colors.white24, fontSize: 10)),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 6),
        ],
      ),
    );
  }
}
