import 'package:heal_chat/globals/global_variables.dart';
import 'package:heal_chat/models/user_model.dart';
import 'package:heal_chat/pages/one_to_one_conversation_page.dart';
import 'package:heal_chat/pages/user_login_page.dart';
import 'package:heal_chat/services/dataBase_method.dart';
import 'package:heal_chat/sizeConfig/size_config.dart';
import 'package:heal_chat/userauthentication/user_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class UserSearch extends StatefulWidget {
  const UserSearch({Key? key}) : super(key: key);

  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  final List<UserModel> _searchResult = [];
  // late QuerySnapshot _querySnapshot;
  // late Map<String, dynamic> _searchData;
  final _formKey = GlobalKey<FormState>();
  // final AuthMethods _authMethods = AuthMethods();
  late DataBaseMethod _dataBaseMethod;
  late Authentication _authentication;
  final TextEditingController _searchUser = TextEditingController();
  bool isloading = false;
  bool isdataloaded = false;
  bool isSearchOptionVisible = false;

  @override
  void initState() {
    super.initState();
    _dataBaseMethod = DataBaseMethod();
    _authentication = Authentication();
  }

  void onSearch(String search) async {
    QuerySnapshot _query;
    // List<UserDetailsModel> result = [];
    Map<String, dynamic> mapResult = {};
    if (_formKey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      _query = await _dataBaseMethod.onUserSearch(search);
      if (_query.docs.isNotEmpty) {
         for (var element in _query.docs) {
          UserModel object = UserModel.fromMap(element);
          _searchResult.add(object);
        }
        setState(() {
          isloading = false;
          isdataloaded = true;
        });
      }
    }
  }

  createChatRommAndStartConversation(String userName) {
    String myName = globalUSERNAME!;
    if (userName != myName) {
      String chatRoomId = getChatRoomId(userName, myName);
      List<String> users = [
        userName,
        myName,
      ];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId,
      };
      _dataBaseMethod.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationPage(chatRoomId, userName),
        ),
      );
    } else {
      // ignore: avoid_print
      print("You can not send message to yourself..");
    }
  }

  String getChatRoomId(String user1, String user2) {
    return user1.substring(0, 1).codeUnitAt(0) >
            user2.substring(0, 1).codeUnitAt(0)
        // ignore: unnecessary_string_escapes
        ? '$user2\_$user1'
        // ignore: unnecessary_string_escapes
        : '$user1\_$user2';

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: const Text("Heal-Chat"),
        actions: [
          IconButton(
            onPressed: () {
              _authentication.userLogOut();
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.heightMultiplier * 1,
              ),
              Container(
                padding: const EdgeInsets.all(5.0),
                alignment: Alignment.center,
                child: TextFormField(
                  validator: (value) {
                    return value!.isEmpty || value.length < 4
                        ? "Search Field cannot be empty"
                        : null;
                  },
                  controller: _searchUser,
                  decoration: const InputDecoration(
                    label: Text("Search User"),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 1,
              ),
              TextButton(
                child: Text(
                  'Search',
                  style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 3.5,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  primary: Colors.white,
                  shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  onSearch(_searchUser.text);
                },
              ),
              isdataloaded
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResult.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3.0,
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(_searchResult[index].userName),
                            subtitle: Text(_searchResult[index].userEmailId),
                            trailing: TextButton(
                              child: Text(
                                'Message',
                                style: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 3,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                                primary: Colors.white,
                                shape: const BeveledRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                createChatRommAndStartConversation(
                                    _searchResult[index].userName);
                              },
                            ),
                           
                          ),
                        );
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
