import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseAuthProvider{

  FirebaseUser _firebaseUser;
  String _status;

  AuthCredential _phoneAuthCredential;
  String _verificationId;
  int _code;
  
  final _routeController = new BehaviorSubject<String>();

  Stream<String> get routeStream => _routeController.stream;

  Function(String) get onChangeRoute => _routeController.sink.add;

  String get route => _routeController.value;

  // FirebaseAuthProvider(){
  //   _getFirebaseUser();
  // }

  static final FirebaseAuthProvider _singleton = FirebaseAuthProvider._internal();
  factory FirebaseAuthProvider() {
    return _singleton;
  }
  FirebaseAuthProvider._internal();

  
  Future<void> getFirebaseUser() async {
    this._firebaseUser = await FirebaseAuth.instance.currentUser();
    // setState(() {
      _status =
          (_firebaseUser == null) ? 'Not Logged In\n' : 'Already LoggedIn\n';
    // });
  }

  /// phoneAuthentication works this way:
  ///     AuthCredential is the only thing that is used to authenticate the user
  ///     OTP is only used to get AuthCrendential after which we need to authenticate with that AuthCredential
  ///
  /// 1. User gives the phoneNumber
  /// 2. Firebase sends OTP if no errors occur
  /// 3. If the phoneNumber is not in the device running the app
  ///       We have to first ask the OTP and get `AuthCredential`(`_phoneAuthCredential`)
  ///       Next we can use that `AuthCredential` to signIn
  ///    Else if user provided SIM phoneNumber is in the device running the app,
  ///       We can signIn without the OTP.
  ///       because the `verificationCompleted` callback gives the `AuthCredential`(`_phoneAuthCredential`) needed to signIn
  Future<void> login() async {
    /// This method is used to login the user
    /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
    try {
      await FirebaseAuth.instance
          .signInWithCredential(this._phoneAuthCredential)
          .then((AuthResult authRes) {
        _firebaseUser = authRes.user;
        print(_firebaseUser.toString());
      });
      // setState(() {
        _status += 'Signed In\n';
      // });
    } catch (e) {
      // setState(() {
        _status += e.toString() + '\n';
      // });
      print(e.toString());
    }
  }

  Future<void> logout() async {
    /// Method to Logout the `FirebaseUser` (`_firebaseUser`)
    try {
      // signout code
      await FirebaseAuth.instance.signOut();
      _firebaseUser = null;
      // setState(() {
        _status += 'Signed out\n';
      // });
    } catch (e) {
      // setState(() {
        _status += e.toString() + '\n';
      // });
      print(e.toString());
    }
  }

  //llamar el login phone
  Future<void> submitPhoneNumber(BuildContext context, String _phoneNumber) async {
    /// NOTE: Either append your phone number country code or add in the code itself
    /// Since I'm in India we use "+91 " as prefix `phoneNumber`
    String phoneNumber = "+52 " +  _phoneNumber;//_phoneNumberController.text.toString().trim();
    print(phoneNumber);

    /// The below functions are the callbacks, separated so as to make code more redable
    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      // setState(() {
        _status += 'verificationCompleted\n';
      // });
      this._phoneAuthCredential = phoneAuthCredential;
      onChangeRoute('config_password');
      print(phoneAuthCredential);
      Navigator.pushNamed(context, 'config_password');
    }


    void verificationFailed(AuthException error) {
      print('verificationFailed');
      // setState(() {
        _status += '$error\n';
      // });
      onChangeRoute('error en la verificación');
      print(error);
    }
    
    void codeSent(String verificationId, [int code]) { //navegar hacia pin code
      print('codeSent');
      this._verificationId = verificationId;
      print(verificationId);
      this._code = code;
      print(code.toString());
      // setState(() {
       _status += 'Code Sent\n';
      print("ENVIANDO CODIGO SALTAR A PAGINA DE OTP");
      onChangeRoute('pin_code');
      // });
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
      // setState(() {
        _status += 'codeAutoRetrievalTimeout\n';
      // });
       onChangeRoute('error en la verificación');
      print(verificationId);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: phoneNumber,

      /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
      timeout: Duration(milliseconds: 10000),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }


  void submitOTP(String otp) {
    /// get the `smsCode` from the user
    String smsCode =otp;

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    this._phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: this._verificationId, smsCode: smsCode);

    login();
  }

}