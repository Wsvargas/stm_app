import 'package:flutter/material.dart';
import '../models/unit_model.dart';
import 'group_chat_page.dart';

class GroupPage extends StatelessWidget {
  final GroupModel group;
  const GroupPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(group.name),
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Group header ──────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A7BFF).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.group,
                        color: Color(0xFF4A7BFF), size: 32),
                  ),
                  const SizedBox(height: 12),
                  Text(group.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${group.members.length} members',
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Members ───────────────────────────────────
            const Text('Members',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...group.members.map((m) => _MemberCard(member: m)),
            const SizedBox(height: 24),

            // ── Open Chat button ──────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => GroupChatPage(group: group)),
                ),
                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                label: const Text('Open Group Chat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A7BFF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final GroupMemberModel member;
  const _MemberCard({required this.member});

  Color get _roleColor =>
      member.role == 'Leader'
          ? const Color(0xFF4A7BFF)
          : const Color(0xFF888888);

  @override
  Widget build(BuildContext context) {
    final isMe = member.userId == 'me';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: isMe
            ? Border.all(
                color: const Color(0xFF4A7BFF).withValues(alpha: 0.4))
            : null,
      ),
      child: Row(children: [
        // Avatar
        CircleAvatar(
          radius: 20,
          backgroundColor:
              _roleColor.withValues(alpha: 0.15),
          child: Text(
            member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
            style: TextStyle(
                color: _roleColor,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
        const SizedBox(width: 12),
        // Name + You tag
        Expanded(
          child: Row(children: [
            Text(member.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            if (isMe) ...[
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A7BFF).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('You',
                    style: TextStyle(
                        color: Color(0xFF4A7BFF),
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ]),
        ),
        // Role badge
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _roleColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(member.role,
              style: TextStyle(
                  color: _roleColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }
}
