import 'package:daedong3/personal_information.dart';
import 'package:daedong3/view/home_page.dart';
import 'package:daedong3/view/hamburger/past_dialog.dart';
import 'package:daedong3/view/hamburger/privacy_update.dart';
import 'package:flutter/material.dart';
import 'package:daedong3/viewmodel/chat_view_model.dart';

import 'package:http/http.dart' as http;

import '../login.dart';

class HamburgerMenu extends StatefulWidget {
  final String chatRoomId;
  HamburgerMenu({required this.chatRoomId,Key? key}) : super(key: key);


  PersonalInformation information = PersonalInformation("김승민", "수원대학교");

  @override
  State<HamburgerMenu> createState() => _HamburgerMenuState();
}

class _HamburgerMenuState extends State<HamburgerMenu> {
  final ChatViewModel _chatViewModel = ChatViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ChatViewModel에서 채팅방 정보를 요청
    _chatViewModel.requestChatRoomInfo(chatRoomId: widget.chatRoomId);

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }
  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          //StreamBuilder 확인
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.lightBlueAccent),
            accountName: Text(widget.information.getName()),
            accountEmail: Text(widget.information.getUniversity()),
            currentAccountPicture: CircleAvatar(
              // 프로필 사진 변경 미구현
              backgroundImage: AssetImage('assets/basic_profile.jpeg'),
              //backgroundColor: Colors.blueAccent,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.grey[850],
            ),
            title: Text("개인정보 수정"),
            onTap: () async {
              PersonalInformation updateInformation = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PrivacyUpdate(
                          information: widget.information,)),
              );
              setState(() {
                widget.information = updateInformation;
              });
            },
            trailing: Icon(Icons.arrow_right),
          ),
          ListTile(
            leading: Icon(
              Icons.add_box,
              color: Colors.grey[850],
            ),
            title: Text("New Chat"),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) =>
                    HomePage(widget.chatRoomId, PersonalInformation('로그인 필요','a'))),
              )
            },
            trailing: Icon(Icons.arrow_right),
          ),

          ListTile(
            leading: Icon(
              Icons.content_paste_go,
              color: Colors.grey[850],
            ),
            title: Text("이전 대화 내용"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PastDialog()
                  ));


            },
            trailing: Icon(Icons.arrow_right),
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.grey[850],
            ),
            title: Text("로그아웃"),
            onTap: () {
              //mongodb logout 기능
              Navigator.push(
                  context, MaterialPageRoute(builder: (_)=>
                  LoginScreen()));


            },
            trailing: Icon(Icons.arrow_right),
          ),
        ],
      ),
    );
  }
}