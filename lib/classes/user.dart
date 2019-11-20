class User {
  String id;
  String email;
  String key;
  String image="";
  String name;
  String nickname="";
  String cellphone="";
  String telephone="";
  int type=0;
  String city;
  String state;

  Map<String, dynamic> toJson({removeId = false}){
    Map<String, dynamic> data = {
      "id"       : id,
      "email"    : email,
      "image"    : image,
      "name"     : name,
      "nickname" : nickname,
      "celphone" : cellphone,
      "telephone": telephone,
      "type"     : type,
      "state"    : state,
      "city"     : city
    };

    if (removeId)
      data.remove("id");

    return data;
  }

  void toClass(String id, Map<String, dynamic> json) {
    id        = json["id"];
    email     = json["email"];
    image     = json["image"];
    name      = json["name"];
    nickname  = json["nickname"];
    cellphone = json["cellphone"];
    telephone = json["telephone"];
    type      = json["type"];
    state     = json["state"];
    city      = json["city"];
  }
}