import 'package:heal_chat/globals/global_variables.dart';
import 'package:heal_chat/pages/one_to_one_conversation_page.dart';
import 'package:heal_chat/pages/user_login_page.dart';
import 'package:heal_chat/pages/user_search_page.dart';
import 'package:heal_chat/services/database_method.dart';
import 'package:heal_chat/userauthentication/user_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class dChatRoom extends StatefulWidget {

  const dChatRoom({Key? key}) : super(key: key);

  @override
  _dChatRoomState createState() => _dChatRoomState();
}

class _dChatRoomState extends State<dChatRoom> {
  
  late Authentication _transaction;

  Stream? _chatRoomList;
  

  late DataBaseMethod _dataBaseMethod;
  late final double offset;
  @override
  void initState() {
    super.initState();
    _transaction = Authentication();
    _dataBaseMethod = DataBaseMethod();
    getChatList();
  }

  void getChatList() async {
    await _dataBaseMethod.getChatRoomList(globalUSERNAME!).then(
          (value) => _chatRoomList = value,
        );
    setState(() {});
  }

  Widget chatRoomList() {
    return _chatRoomList != null
        ? StreamBuilder(
            stream: _chatRoomList,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                      itemBuilder: (contetx, index) {
                        return chatRoomTile(
                          (snapshot.data! as QuerySnapshot)
                              .docs[index]["chatRoomId"]
                              .toString()
                              .replaceAll("_", "")
                              .replaceAll(globalUSERNAME!,""),
                          (snapshot.data! as QuerySnapshot).docs[index]
                              ["chatRoomId"],
                        );
                      },
                    )
                  : Container();
            },
          )
        : const Center(
            child: Text("Good things take time.."),
          );
  }

  Widget chatRoomTile(String userName, String chatRoomId) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          userName.substring(0, 1).toUpperCase(),
        ),
      ),
      title: Text(userName),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationPage(chatRoomId, userName),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Heal-Chat"),
        
        actions: [
          IconButton(
            onPressed: () {
              _transaction.userLogOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app_sharp),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserSearch(),
            ),
          );
        },
        child: const Icon(
          Icons.person_search,
          color: Colors.white,
        ),
      ),
    );
  }
}
