import 'package:heal_chat/globals/global_variables.dart';
import 'package:heal_chat/services/database_method.dart';
import 'package:heal_chat/sizeConfig/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  final String chatRoomId;
  final String toName;
  const ConversationPage(this.chatRoomId, this.toName, {Key? key})
      : super(key: key);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  bool? _isMessageLoaded;
  // late QuerySnapshot _query;
  bool emojiShowing = false;
  final FocusNode _focusNode = FocusNode();
  late DataBaseMethod _dataBaseMethod;
  late FirebaseAuth _firebaseAuth;
  Stream? _chatMessageStream;
  late List<Map<String, dynamic>> messageData;

  @override
  void initState() {
    // ignore: avoid_print
    print(globalUSERNAME);
    print(globalDOCNAME);
    super.initState();
    _firebaseAuth = FirebaseAuth.instance;
    _dataBaseMethod = DataBaseMethod();
    setState(() {
      _dataBaseMethod.getMessagesList(widget.chatRoomId).then(
            (value) => _chatMessageStream = value,
          );
    });
    getMeessageList();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          emojiShowing = false; //!emojiShowing;
        });
      }
    });
  }

  void getMeessageList() async {
    await _dataBaseMethod.getMessagesList(widget.chatRoomId).then(
          (value) => _chatMessageStream = value,
        );
    setState(() {
      _isMessageLoaded = true;
    });
  }

  Widget chatMessageList() {
    return _chatMessageStream != null
        ? StreamBuilder(
            stream: _chatMessageStream,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                      itemBuilder: (context, index) {
                        return showMessageTile(
                          (snapshot.data! as QuerySnapshot).docs[index]
                              ["message"],
                          (snapshot.data! as QuerySnapshot).docs[index]
                                  ["sendBy"] ==
                              globalUSERNAME,
                        );
                      },
                    )
                  : Container();
            },
          )
        : const Center(
            child: Text("Takes time to load..."),
          );
  }

  sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": _messageController.text,
        "sendBy": _firebaseAuth.currentUser!.displayName as String,
        "time": DateTime.now().microsecondsSinceEpoch,
      };
      await _dataBaseMethod.addMessagesList(widget.chatRoomId, messageMap);

      _messageController.clear();
    }
  }

  Widget showMessageTile(String message, bool isSendByMe) {
    return Container(
      padding: EdgeInsets.only(
        left: isSendByMe ? 0 : 24,
        right: isSendByMe ? 24 : 0,
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe
                ? const [
                    Color(0xff007EF4),
                    Color(0xff2A75BC),
                  ]
                : const [
                    Color(0x1AFFFFFF),
                    Color(0x1AFFFFFF),
                  ],
          ),
          borderRadius: isSendByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
        ),
        // color: Colors.blue,
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(widget.toName),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              chatMessageList(),
              Column(
                children: [
                  Expanded(child: Container()),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 08,
                    child: Row(
                      children: [
                        Material(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1.0),
                            child: IconButton(
                              icon: const Icon(Icons.image),
                              onPressed: () {},
                              color: Colors.blueGrey,
                            ),
                          ),
                          color: Colors.white,
                        ),
                        Expanded(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                focusNode: _focusNode,
                                controller: _messageController,
                                style: const TextStyle(
                                    color: Colors.blueGrey, fontSize: 15.0),
                                decoration: const InputDecoration.collapsed(
                                  focusColor: Colors.grey,
                                  hintText: 'Type your message...',
                                  hintStyle: TextStyle(color: Colors.blueGrey),
                                ),
                              )),
                        ),
                        Material(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                sendMessage();
                              },
                              color: Colors.blueGrey,
                            ),
                          ),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget buildLoading() {
    return Positioned(
      child: _isMessageLoaded == null
          ? Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }
}
