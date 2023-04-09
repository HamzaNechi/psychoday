class User {
   String? id;
   String? fullName;
   String? assurance;
   String? nickName;
   String? email;
   String? password;
   String? phone;
   String? role;
   String? speciality;
   String? address;
   String? photo;
   String? certificate;

  User(
      this.id,
      this.nickName,
      this.email,
      this.password,
      this.phone,
      this.role,
      this.address,
      this.photo,
      this.certificate,
      this.fullName,
      this.speciality,
      this.assurance,
  );

  User.userWithThreeParameters({this.fullName, this.speciality, this.assurance});

  User.three({this.fullName,this.role,this.id,this.email});

  factory User.fromJson(dynamic json){
    return User.three(
      id : json['_id'], 
      email : json['email'], 
      role : json['role'],
      fullName : json['fullname'],
      );
  }
}