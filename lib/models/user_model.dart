class UserModel {
  String? name;
  String? email;
  String ? phone;
  String ? id;
  String ?token;
  String ?image;

  UserModel({required this.email, required this.name,required this.phone,required this.token, this.id,required this.image,});

  UserModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    email = json['email'];
    phone = json['phone'];
    id = json['id'];
    token = json['token'];
    image = json['image'];

  }

  Map<String, dynamic> toMap({required id}) => {
    'id': id,
    'name':name,
    'email': email,
    'phone': phone,
    'token': token,
    'image': image,
  };
}