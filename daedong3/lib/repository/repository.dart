import 'dart:convert';
import 'package:daedong3/model/faq_item.dart';
import 'package:daedong3/model/info_modify_request.dart';
import 'package:logger/logger.dart';
import '../model/chat_room.dart';
import '../model/login.dart';
import '../model/past_chat.dart';
import '../model/question.dart';
import '../model/sign_up.dart';
import '../model/user.dart';
import 'package:http/http.dart' as http;
import '../model/user_update.dart';

class Repository {
  // API 순서대로 메소드 작성

  // 사용자 질문
  Future<String> answerQuestion(Question question) async {
    try {
      final response = await http.post(
          Uri.parse('http://13.209.50.197:8080/daedong/chatroom/question'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(question.toJson()));
      return response.body; // response가 String이어서 그대로 return
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // 로그인한 사용자의 최근 채팅방
  Future<ChatRoom> latestChatRoom(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://13.209.50.197:8080/daedong/$userId'),
      );
      return ChatRoom.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // 사용자가 선택한 채팅방
  Future<ChatRoom> chosenChatRoom(String chatRoomId) async {
    try {
      final response = await http.get(
          Uri.parse('http://13.209.50.197:8080/daedong/chatroom/$chatRoomId'));
      return ChatRoom.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // 잘못된 정보 수정 요청
  Future<bool> requestModifyInfo(InfoModifyRequest infoModifyRequest) async {
    // bool 값으로 리턴
    try {
      final response = await http.post(
          Uri.parse('http://13.209.50.197:8080/daedong/chatroom/modify'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(infoModifyRequest.toJson()));
      if (response.body == "success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // 새 채팅 생성
  Future<String> createChatRoom(User user) async {
    try {
      final response = await http.post(
          Uri.parse('http://13.209.50.197:8080/daedong/menu/createchatroom'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(user.toJson()));
      return response.body;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // 과거 채팅 내용 조회
  Future<List<PastChat>> pastChatList(String userId) async {
    try {
      final response = await http
          .get(Uri.parse('http://13.209.50.197:8080/daedong/menu/pastList/$userId'));
      dynamic chatList = jsonDecode(utf8.decode(response.bodyBytes)); // response 값 body에 디코딩해서 담기
      // List<PastChat> chatList = body
      //     .map((dynamic item) => PastChat.fromJson(item))
      //     .toList(); // PastChat 객체로 변환해서 리스트 형태로 리턴

      return (chatList as List).map((e) => PastChat.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // 채팅방 제목 수정
  Future<bool> updateTitle(ChatRoom chatRoom, String newChatTitle) async {
    // bool 값으로 리턴
    try {
      final response = await http.post(
          Uri.parse(
              'http://13.209.50.197:8080/daedong/menu/updatetitle/$newChatTitle'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(chatRoom.toJson()));
      if (response.body == "success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // 채팅방 삭제
  Future<bool> deleteChatRoom(ChatRoom chatRoom) async {
    // bool 값으로 리턴
    try {
      final response = await http.post(
          Uri.parse('http://13.209.50.197:8080/daedong/menu/deletechatroom'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(chatRoom.toJson()));
      if (response.body == "success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // 자주 묻는 질문
  Future<List<FaqItem>> fetchFaq() async {
    try {
      final response = await http.get(
        Uri.parse('http://13.209.50.197:8080/daedong/menu/faq'),
      );
      if(response.statusCode == 200){
        List<dynamic> jsonDataList = jsonDecode(utf8.decode(response.bodyBytes));

        List<FaqItem> faqResult = jsonDataList.map((jsonData) {
          return FaqItem.fromJson(jsonData);
        }).toList();

        return faqResult;
      }else {
        throw Exception('Failed to load faq data');
      }

    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // 로그인
  Future<User> loginRepo(Login login) async {
    try {
      final response = await http.post(
          Uri.parse('http://13.209.50.197:8080/daedong/login'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(login.toJson()));
      User result = User.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      return result;
    } catch (e) { // 로그인 실패 시 띄울 오류 메시지
      throw Exception("로그인에 실패했습니다. 아이디와 비밀번호를 확인하세요.");
    }
  }

  // 회원 정보 수정
  Future<User> updateUserInfo(User user) async {
    // id 는 UserId
    try {
      final response = await http.post(
          Uri.parse(
              'http://13.209.50.197:8080/daedong/updateUser'),
          // #Uri 상 _id 이지만 private 처리 문제로 일단 id로 적어둠
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(user.toJson()));
      User result = User.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      return result;

    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // 회원 탈퇴
  Future<bool> deleteUser(User user) async {
    try {
      final response = await http.post(
          Uri.parse('http://13.209.50.197:8080/daedong/deleteUser'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(user.toJson()));
      if (response.body == "success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // 로그아웃
  Future<bool> logout() async {
    try {
      final response = await http.post(
          Uri.parse('http://13.209.50.197:8080/daedong/logout')
      );
      if (response.body == "success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // 회원가입
  Future<bool> signup(SignUp signUp) async{
    try {
      final response = await http.post(
          Uri.parse('http://13.209.50.197:8080/daedong/join'),
          headers: {"Content-Type" : "application/json"},
          body: jsonEncode(signUp.toJson())
      );
      if (response.body == "success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // schoolEmail 중복 체크(ID 중복체크)
  Future<bool> checkDuplicatedEmail(String schoolEmail) async {
    try{
      final response = await http.get(
        Uri.parse('http://13.209.50.197:8080/daedong/repeatCheck?schoolEmail=$schoolEmail')
      );
      if(response.body == "true"){
        return true; // 중복이 아니라면 true 리턴
      }else{
        return false; // 이메일이 중복된다면 false 리턴
      }
    }catch (e){
      throw Exception('Error: $e');
    }
  }
}
