import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_miniproject_app/config/config.dart';
import 'package:mobile_miniproject_app/models/request/customers_login_post_req.dart';
import 'package:mobile_miniproject_app/models/response/customersLoginPostRes.dart';
import 'package:mobile_miniproject_app/pages/Admin.dart';
import 'package:mobile_miniproject_app/pages/register.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_miniproject_app/pages/Home.dart';
import 'package:mobile_miniproject_app/shared/share_data.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var model;
  GetStorage gs = GetStorage();
  String text = '';
  int count = 0;
  String phoneNo = '', txt = '';
  TextEditingController EmailCtl = TextEditingController();
  TextEditingController PasswordCtl = TextEditingController();
  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((value) {
      setState(() {
        url = value['apiEndpoint'];
        log("API Endpoint: $url"); // ตรวจสอบค่า URL หลังจากตั้งค่าเสร็จ
        print(gs.read('Email'));
        print(gs.read('Password'));

        if (gs.read('Email') != null) {
          login();
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: SizedBox(
                width: 400,
                height: 250,
                child: Image.network(
                  'https://media.istockphoto.com/id/1455501896/th/%E0%B9%80%E0%B8%A7%E0%B8%84%E0%B9%80%E0%B8%95%E0%B8%AD%E0%B8%A3%E0%B9%8C/%E0%B8%95%E0%B9%89%E0%B8%99%E0%B9%84%E0%B8%A1%E0%B9%89%E0%B9%80%E0%B8%87%E0%B8%B4%E0%B8%99%E0%B9%83%E0%B8%99%E0%B8%81%E0%B8%A3%E0%B8%B0%E0%B8%96%E0%B8%B2%E0%B8%87%E0%B8%94%E0%B8%AD%E0%B8%81%E0%B9%84%E0%B8%A1%E0%B9%89%E0%B8%97%E0%B8%B5%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B9%83%E0%B8%9A%E0%B8%AA%E0%B8%B5%E0%B9%80%E0%B8%82%E0%B8%B5%E0%B8%A2%E0%B8%A7%E0%B9%81%E0%B8%A5%E0%B8%B0%E0%B9%80%E0%B8%AB%E0%B8%A3%E0%B8%B5%E0%B8%A2%E0%B8%8D%E0%B8%97%E0%B8%AD%E0%B8%87.jpg?s=170667a&w=0&k=20&c=aAj0OUymMwxABoT0QTiQwtxYM8trB2hG4ZJycUajCUM=', // กำหนดการจัดตำแหน่งของรูปภาพ
                ),
              ),
            ),
            const Text(
              'Log in',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 52, 51, 52),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 45, 44, 45),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: TextField(
                      controller: EmailCtl,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 228, 225, 225),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(width: 1)),
                      ),
                    ),
                  ),
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 45, 44, 45),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 30.0),
                    child: TextField(
                      obscureText: true,
                      controller: PasswordCtl,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 228, 225, 225),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(width: 1)),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: FilledButton(
                          onPressed: () {
                            gs.write('Email', EmailCtl.text);
                            gs.write('Password', PasswordCtl.text);
                            print(gs.read('Email'));
                            print(gs.read('Password'));
                            login();
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Color.fromARGB(255, 254, 137, 69)),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.white),
                          ),
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 25.0, bottom: 5.0),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No account?'),
                      TextButton(
                        onPressed: register,
                        style: ButtonStyle(
                          // สีพื้นหลังของปุ่ม
                          foregroundColor: WidgetStateProperty.all(
                              const Color.fromARGB(255, 254, 137, 69)),
                        ),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: Text(
                txt,
                style: TextStyle(color: Color.fromARGB(255, 223, 7, 7)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    log("API Endpoint: $url");
    String email = gs.read('Email');
    String password = gs.read('Password');
    log(email);
    log(password);

    log("xxxxxxx");
    model = CustomersLoginPostRequest(Email: email, Password: password);

    try {
      var Value = await http.post(Uri.parse("$url/db/users/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customersLoginPostRequestToJson(model));
      log(Value.body); // Log the raw response body

      List<dynamic> jsonResponse = json.decode(Value.body);
      var res = CustomersLoginPostResponse.fromJson(jsonResponse.first);
      User_info User = User_info();
      User.uid = res.uid;
      User.wallet = res.wallet;
      User.username = res.username;
      context.read<ShareData>().user_info = User;
      log(res.image);

      if (res.typeId == 1) {
        log("Admin User Logged In");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminPage(
                uid: res.uid,
                wallet: res.wallet,
                username: res.username,
                selectedIndex: 0,
              ), // ไปยังหน้า Admin
            ));
      } else {
        // นำไปยังหน้า HomePage ตามปกติ
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                selectedIndex: 0,
              ),
            ));
      }
    } catch (err) {
      log(err.toString());
      setState(() {
        Fluttertoast.showToast(
            msg:
                "Email หรือ Password ไม่ถูกต้องโปรดตรวจสอบความถูกต้อง แล้วลองอีกครั้ง",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            // backgroundColor: Color.fromARGB(120, 0, 0, 0),
            backgroundColor: Color.fromARGB(255, 255, 0, 0),
            textColor: Colors.white,
            fontSize: 15.0);
      });

      setState(() {});
    }
  }

  void register() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPage(),
        ));
  }
}
