class SocialUserModel {

    String ?name;
    String ?email;
    String ?phone;
    String? uId ;
    String? image ;
    String? cover ;
    String? bio ;
    bool? isEmailVerifide;

   SocialUserModel({
     this.name,
     this.email,
     this.phone,
     this.uId,
     this.image,
     this.cover,
     this.bio,
     this.isEmailVerifide,
});

   SocialUserModel.fromJson(Map<String , dynamic> json)
   {
    name=json['name'];
    email=json['email'];
    phone=json['phone'];
    uId=json['uId'];
    image=json['image'];
    cover=json['cover'];
    bio=json['bio'];
    isEmailVerifide=json['isEmailVerifide'];
   }

    Map<String,dynamic> toMap()
    {
      return{
      'name': name,
      'email': email,
      'phone': phone,
      'uId':uId,
      'image':image,
      'cover':cover,
      'bio':bio,
      'isEmailVerifide': isEmailVerifide,

      };
    }



}