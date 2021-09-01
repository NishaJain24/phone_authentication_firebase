import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_authentication_firebase/home.dart';
import 'package:phone_authentication_firebase/main.dart';
import 'package:pinput/pin_put/pin_put.dart';
class OTPScreen extends StatefulWidget {
  final String phone;
  OTPScreen(this.phone);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  late String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Verify +91-${widget.phone}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                      verificationId: _verificationCode, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                              (route) => false);
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  _scaffoldkey.currentState!
                      .showSnackBar(SnackBar(content: Text('invalid OTP')));
                }
              },
            ),
          )
        ],
      ),
    );
  }

// class OTPScreen extends StatefulWidget {
//   final String phone;
//
//   OTPScreen(this.phone);
//
//   @override
//   _OTPScreenState createState() => _OTPScreenState();
// }
//
// class _OTPScreenState extends State<OTPScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
//   late String _verificationCode;
//   final TextEditingController _pinPutController = TextEditingController();
//   final FocusNode _pinPutFocusNode = FocusNode();
//   final BoxDecoration pinPutDecoration = BoxDecoration(
//     color: const Color.fromRGBO(43, 46, 66, 1),
//     borderRadius: BorderRadius.circular(10.0),
//     border: Border.all(
//       color: const Color.fromRGBO(126, 203, 224, 1),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("OTP Verification"),
//       ),
//       body: Column(
//         children: [
//           Container(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Center(
//                   child: Text(
//                     'Verify +91-${widget.phone}',
//                     style: TextStyle(
//                         color: Colors.black87,
//                         fontSize: 30,
//                         fontWeight: FontWeight.w200),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(30.0),
//             child: PinPut(
//               fieldsCount: 6,
//               textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
//               eachFieldWidth: 40.0,
//               eachFieldHeight: 55.0,
//               focusNode: _pinPutFocusNode,
//               controller: _pinPutController,
//               submittedFieldDecoration: pinPutDecoration,
//               selectedFieldDecoration: pinPutDecoration,
//               followingFieldDecoration: pinPutDecoration,
//               pinAnimationType: PinAnimationType.fade,
//               onSubmit: (pin) async {
//                 try {
//                   await FirebaseAuth.instance
//                       .signInWithCredential(PhoneAuthProvider.credential(
//                           verificationId: _verificationCode, smsCode: pin))
//                       .then((value) async {
//                     if (value.user != null) {
//                       Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(builder: (context) => HomeScreen()),
//                           (route) => false);
//                     }
//                   });
//                 } catch (e) {
//                   FocusScope.of(context).unfocus();
//                   _scaffoldkey.currentState!
//                       .showSnackBar(SnackBar(content: Text('invalid OTP')));
//                 }
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, void resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  // _verifyPhone() async {
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: '+91${widget.phone}',
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await FirebaseAuth.instance
  //             .signInWithCredential(credential)
  //             .then((value) async {
  //               if(value.user != null){
  //                 Navigator.pushAndRemoveUntil(
  //                     context,
  //                     MaterialPageRoute(builder: (context) => HomeScreen()),
  //                         (route) => false);
  //               }
  //         });
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         print(e.message);
  //       },
  //       codeSent: (String verificationID, void resendToken) {
  //         setState(() {
  //           _verificationCode = verificationID;
  //         });
  //       },
  //       timeout: Duration(seconds: 60),
  //       codeAutoRetrievalTimeout: (String verificationID) {
  //         setState(() {
  //           _verificationCode = verificationID;
  //         });
  //       });
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
