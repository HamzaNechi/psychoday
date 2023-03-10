class User {
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
}