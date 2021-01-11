///
/// User Model
///
///
class LoginResponse {
  String firstName, lastName, email;

  LoginResponse(this.firstName, this.lastName, this.email);

  LoginResponse.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
  }
}
