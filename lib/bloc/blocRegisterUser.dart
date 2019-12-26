import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import '../classes/defaultResponse.dart';
import '../api/firebaseConnection.dart';
import '../bloc/blocRegisterBase.dart';
import '../classes/cities.dart';
import '../classes/user.dart';

class BlocRegisterUser extends BlocRegisterBase {
  String url="users";
  User dataObject = User();
  List<State> listStates;
  List<String> listCities;
  final States states = States();

  BlocRegisterUser(){
    listStates = states.data;
    _userController.listen((value){
      dataObject = value;
    });
    _state.stream.listen((data){
      listCities=states.getCities(data);
      _inCity.add(listCities[0]);
    });
  }

  @override
  void dispose() {
    _userController.close();
    _email.close();
    _key.close();
    _name.close();
    _telephone.close();
    _cellphone.close();
    _telephone.close();
    _cellphone.close();
    _website.close();
    _state.close();
    _city.close();
    super.dispose();
  }

  @override
  Future<DefaultResponse> save() async {
    final api = FirebaseConnection();
    
    if (dataObject.id==null){
      DefaultResponse error;

      final requestCreate = await api.createUserWithEmailAndPassword(dataObject.email, dataObject.key);
      if (requestCreate.code=="OK"){
        final requestSign = await api.signInWithEmailAndPassword(dataObject.email, dataObject.key);
        if (requestSign.code=="OK")
          await Firestore.instance.collection("users").document(requestSign.value).setData(dataObject.toJson(removeId: true));
        else
          registerState = requestSign;
      } 
      else
        registerState = requestCreate;

      if (error!=null) {
        print("Erro: ${error.code} -> ${error.value}");
        moveToStep(0);
      }
    }
    else
      await Firestore.instance.collection("users").document(dataObject.id).setData(dataObject.toJson(removeId: true));

    return super.save();
  }

  final BehaviorSubject<User> _userController = BehaviorSubject<User>();
  Stream<User> get outUser => _userController.stream;
  Sink<User> get inUser => _userController.sink;
 
  final _name = BehaviorSubject<String>.seeded("");
  Stream<String> get outName  => _name.stream;
  Function(String) get inName => _name.sink.add;

  final _email = BehaviorSubject<String>.seeded("");
  Stream<String> get outEmail => _email.stream;
  Function(String) get inEmail => _email.sink.add;

  final _key = BehaviorSubject<String>.seeded("");
  Stream<String> get outKey  => _key.stream;
  Function(String) get inKey => _key.sink.add;

  final _telephone = BehaviorSubject<String>.seeded("");
  Stream<String> get outTelephone  => _telephone.stream;
  Function(String) get inTelephone => _telephone.sink.add;

  final _cellphone = BehaviorSubject<String>.seeded("");
  Stream<String> get outCellphone  => _cellphone.stream;
  Function(String) get inCellphone => _cellphone.sink.add;

  final _website = BehaviorSubject<String>.seeded("");
  Stream<String> get outWebsite  => _website.stream;
  Function(String) get inWebsite => _website.sink.add;

  final _state = BehaviorSubject<String>.seeded("XX");
  Stream<String> get outState  => _state.stream;
  Function(String) get inState => _state.sink.add;

  String getState() => _state.value;

  final _city = BehaviorSubject<String>();
  Stream<String> get outCity  => _city.stream;
  Function(String) get inCity => _city.sink.add;
  Sink<String> get _inCity => _city.sink;
}