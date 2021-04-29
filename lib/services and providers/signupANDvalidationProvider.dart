
// class Validation with ChangeNotifier {

//   ValidationModel _email = ValidationModel(value: null, error: null);
//   ValidationModel _password = ValidationModel(value: null, error: null);
//   //getters
//   ValidationModel get email => _email;
//   ValidationModel get password => _password;

//   bool get isValid {
//     if (_email.value != null && _password.value != null) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   validateEmail(value) {
//     if (value.contains("@") && value.length >= 6) {
//       _email = ValidationModel(value: value, error: null);
//     } else {
//       _email = ValidationModel(value: null, error: "Enter a valid email");
//     }
//     notifyListeners();
//   }


// }



// class ValidationModel {
//   final String value;
//   final String error;

//   ValidationModel({this.value, this.error});
// }
