import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GroupsPage(),
    );
  }
}

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  // Initial groups
  List<Map<String, dynamic>> groups = [
    {
      "title": "ICT306 Advance Cyber Security",
      "subtitle": "Demonstration",
      "members": 5,
      "activity": "Active 2 hours ago",
      "messages": []
    },
    {
      "title": "ICT305 Topic in IT",
      "subtitle": "Research",
      "members": 3,
      "activity": "Active Yesterday",
      "messages": []
    },
    {
      "title": "ICT309 GRC",
      "subtitle": "Report",
      "members": 4,
      "activity": "Active Just now",
      "messages": []
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Groups", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Study Groups",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateGroupPage(),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          groups.add({
                            "title": result["groupName"],
                            "subtitle": result["studentName"],
                            "members": 1,
                            "activity": "Just created",
                            "messages": []
                          });
                        });
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Create Group"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                     return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupChatPage(group: group),
                          ),
                        );
                      },
                      child: GroupCard(
                        title: group["title"],
                        subtitle: group["subtitle"],
                        members: group["members"],
                        activity: group["activity"],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int members;
  final String activity;

  const GroupCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.members,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            height: 140,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: const Center(child: Icon(Icons.image)),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.people, size: 16, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          "$members",
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, color: Colors.grey),
                    SizedBox(width: 16),
                    Icon(Icons.description_outlined, color: Colors.grey),
                    SizedBox(width: 16),
                    Icon(Icons.calendar_today, color: Colors.grey),
                    SizedBox(width: 16),
                    Icon(Icons.video_call_outlined, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  activity,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController studentIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Create Group"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _groupNameController,
              decoration: const InputDecoration(
                labelText: "Group Name",
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: studentNameController,
              decoration: const InputDecoration(
                labelText: "Student Name",
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: studentIDController,
              decoration: const InputDecoration(
                labelText: "Student ID",
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                String groupName = _groupNameController.text;
                String studentName = studentNameController.text;
                String studentID = studentIDController.text;

                if (groupName.isEmpty ||
                    studentName.isEmpty ||
                    studentID.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                Navigator.pop(context, {
                  "groupName": groupName,
                  "studentName": studentName,
                  "studentID": studentID,
                });

                // Clear controllers
                _groupNameController.clear();
                studentNameController.clear();
                studentIDController.clear();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12)),
              child:
                  const Text("Create Group", style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}

class GroupChatPage extends StatefulWidget {
  final Map<String, dynamic> group;

  const GroupChatPage({super.key, required this.group});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController messageController = TextEditingController();
  List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.group["title"]),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              itemCount: widget.group["messages"].length,
              itemBuilder: (context, index) {
                return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.transparent, // keeps background transparent
                        border: Border.all(
                          color: Colors.white, // border color
                          width: 1.0,           // border thickness
                        ),
                        borderRadius: BorderRadius.circular(8), // rounded corners
                      ),
                      child: ListTile(
                        title: Text(
                          widget.group["messages"][index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    );
              },
            ),
          ),

          // Input field
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    if (messageController.text.isEmpty) return;

                    setState(() {
                      widget.group["messages"].add(messageController.text);
                    
                    });

                    messageController.clear();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}