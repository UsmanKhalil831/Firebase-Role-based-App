class Biodata{
  String? email;
  String? role;
  String? useruid;

  Biodata({required this.email, required this.role,required this.useruid});

  Biodata.fromMap(Map<String,dynamic> map){
    useruid = map['uid'];
    email = map['email'];
    role = map['role'];
  }

  Map<String,dynamic> toMap(){
    return{
      'uid':useruid,
      'email':email,
      'role':role,
    };
  }
}