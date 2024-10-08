class User { // 새 채팅 생성, 회원 탈퇴
  String id;
  String name;
  String phoneNumber;
  String schoolEmail;
  String password;
  String schoolName;
  bool pushAlarm;
  bool personalInformation;
  List<dynamic> chatRoomOid;

  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.schoolEmail,
    required this.password,
    required this.schoolName,
    required this.pushAlarm,
    required this.personalInformation,
    required this.chatRoomOid
  });

  Map<String, dynamic> toJson(){
    return{
      "_id": id,
      "name": name,
      "phoneNumber": phoneNumber,
      "schoolEmail": schoolEmail,
      "password": password,
      "schoolName": schoolName,
      "pushAlarm": pushAlarm,
      "personalInformation": personalInformation,
      "chatRoomOid": chatRoomOid
    };
  }

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["_id"],
      name: json["name"],
      phoneNumber: json["phoneNumber"],
      schoolEmail: json["schoolEmail"],
      password: json["password"],
      schoolName: json["schoolName"],
      pushAlarm: json["pushAlarm"],
      personalInformation: json["personalInformation"],
      chatRoomOid: json["chatRoomOid"],
    );
  }

}