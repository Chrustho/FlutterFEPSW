import '../objects/users.dart';

class UserRegistrationRequest{
  Users user;
  String password;
  UserRegistrationRequest({required this.user, required this.password});



  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'password': password,
  };
  Users getUser(){
    return user;
  }
}