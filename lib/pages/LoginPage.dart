import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wsmb_day1_try6_jam/models/driver.dart';
import 'package:wsmb_day1_try6_jam/pages/homePage.dart';
import 'package:wsmb_day1_try6_jam/pages/ride/ridePage.dart';
import 'package:wsmb_day1_try6_jam/pages/register/persona.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final icnoController = TextEditingController();
  final passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  Future<void> login() async {
    if (formkey.currentState!.validate()) {
      var driver =
          await Driver.login(icnoController.text, passwordController.text);
      if (driver == null) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Warning'),
                  content: Text('Invalid Login'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'))
                  ],
                ));
      } else {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Success'),
                  content: Text('Login Successfully'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomePage()));
                        },
                        child: Text('OK'))
                  ],
                ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              Center(
                child: Text(
                  'Hello\nWelcome to Kongsi Kereta',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Form(
                  key: formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                            controller: icnoController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                label: Center(child: Text('IC No'))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please key in your ic number";
                              } else if (value.length < 12 ||
                                  int.tryParse(value) == null) {
                                return 'Please enter a valid ic number';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                label: Center(child: Text('Password'))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please key in your password";
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                              color: Colors.white),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(45.0),
                                  ),
                                  backgroundColor: Colors.lightBlueAccent),
                              onPressed: login,
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PersonaPage()));
                            },
                            child: Text(
                              'Did not have account yet?\nClick me!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue),
                            ))
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
