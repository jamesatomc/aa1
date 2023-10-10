import 'package:ch09_flutter/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistPage extends StatefulWidget {
  const RegistPage({Key? key}) : super(key: key);

  @override
  _RegistPageState createState() => _RegistPageState();
}

class _RegistPageState extends State<RegistPage> {
  final mystyle = MyStyle();
  final formkey = GlobalKey<FormState>();
  var nameText = TextEditingController();
  var userText = TextEditingController();
  var passText = TextEditingController();
  var verifyText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: mystyle.decorations(),
        child: ListView(
          children: [
            Form(
              key: formkey,
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  showTitle(),
                  const SizedBox(height: 20),
                  mystyle.textBoxs(
                      'ชื่อ-นามสกุล',
                      const Icon(Icons.font_download, size: 32),
                      false,
                      nameText),
                  const SizedBox(height: 3),
                  mystyle.textBoxs('ชื่อเข้าสู่ระบบ',
                      const Icon(Icons.person, size: 32), false, userText),
                  const SizedBox(height: 3),
                  mystyle.textBoxs('รหัสผ่าน',
                      const Icon(Icons.vpn_key, size: 32), true, passText),
                  const SizedBox(height: 3),
                  mystyle.textBoxs(
                      'ยืนยันรหัสผ่าน',
                      const Icon(Icons.vpn_key_outlined, size: 32),
                      true,
                      verifyText),
                  const SizedBox(height: 20),
                  submitButton(),
                  const SizedBox(height: 15),
                  backButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showTitle() {
    return const Text(
      'ลงทะเบียน',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget submitButton() {
    return SizedBox(
      width: 320,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: userText.text, 
                  password: passText.text)
              .then((value) {
            value.user!.updateDisplayName(nameText.text);
          });

          Widget okButton = TextButton(
            onPressed: () {
              Navigator.pop(context,
                  MaterialPageRoute(builder: ((context) => LoginPage())));
            },
            child: Text("ตกลง"),
          );

          AlertDialog alert = AlertDialog(
            title: Text("ผ่าน"),
            content: Text("ผ่าน"),
            actions: [
              okButton,
            ],
          );

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          ).catchError((onError) {
            print(onError);
            var errortxt = "";
            switch (onError.toString()) {
              case "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
                {
                  errortxt = "อีเมลซ้ำ กรุณาตรวจสอบ";
                }
                break;
              case "[firebase_auth/weak-password] Password should be at least 6 characters":
                {
                  errortxt = "รหัสไม่ครบ 6 ตัว";
                }
                break;
              case "[firebase_auth/invalid-email] The email address is badly formatted.":
                {
                  errortxt = "รูปแบบอีเมลไม่ถูกต้อง";
                }
                break;
              default:
                {
                  errortxt = onError.toString();
                }
            }

            Widget okButton = TextButton(
              onPressed: () {
                Navigator.pop(context,
                    MaterialPageRoute(builder: ((context) => LoginPage())));
              },
              child: Text("ตกลง"),
            );

            AlertDialog alert = AlertDialog(
              title: Text("ข้อผิดพลาด"),
              content: Text(errortxt),
              actions: [
                okButton,
              ],
            );

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
            // SnackBar snackBar =
            //     SnackBar(content: Text("เกิดข้อพิดพลาด : " + errortxt));
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
          // if (formkey.currentState!.validate()) {
          //   messageBox('กรอกข้อมูลครบ', 'การบันทึกข้อมูลสำเร็จ');
          // } else {
          //   messageBox('โปรดตรวจสอบการกรอกข้อมูล', 'ข้อผิดพลาด');
          // }
        },
        style: ElevatedButton.styleFrom(
            primary: Colors.pink[300],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
        child: const Text(
          'ยืนยันการสมัคร',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget backButtons() {
    return SizedBox(
      width: 320,
      height: 55,
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'กลับหน้าหลัก',
          style: TextStyle(
              fontSize: 18,
              color: Colors.yellow[700]!,
              decoration: TextDecoration.underline),
        ),
      ),
    );
  }

  dynamic messageBox(String content, String title) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class MyStyle {
  BoxDecoration decorations() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.tealAccent,
          Colors.cyan,
          Colors.indigo[400]!,
        ],
      ),
    );
  }

  Widget textBoxs(String _txts, Widget _icons, bool _obcurs, var controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
      child: TextFormField(
        obscureText: _obcurs,
        controller: controller,
        validator: (val) {
          if (val!.isEmpty) {
            return 'กรุณากรอกข้อมูลให้ครบ';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          fillColor: Colors.white10.withOpacity(0.7),
          filled: true,
          hintText: _txts,
          prefixIcon: _icons,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
