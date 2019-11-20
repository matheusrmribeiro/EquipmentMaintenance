abstract class Entity{
  int id;
  
  dynamic toClass(Map<String, dynamic> data);
  Map<String, dynamic> toJSON(bool removeId);
}