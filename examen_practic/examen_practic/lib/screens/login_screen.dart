import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/login_form_provider.dart';
import '../ui/input_decorations.dart';
import 'screens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

bool valuecheck = false;

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              children: [
                const FlutterLogo(
                  size: 100,
                ),
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: _LoginForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  SharedPreferences? prefs;
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  String? email;
  String? password;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _setData() async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString('email', email_controller.text.toString());
    prefs!.setString('password', password_controller.text.toString());
    print(prefs!.get('email'));
    print(prefs!.get('password'));
  }

  _deleteData() async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString('email', '');
    prefs!.setString('password', '');
    print(prefs!.get('email'));
    print(prefs!.get('password'));
  }

  _getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs!.get("email") != null) {
        email_controller.text = prefs!.get('email').toString();
        password_controller.text = prefs!.get('password').toString();
        print(prefs!.get('email'));
        print(prefs!.get('password'));
      } else {
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final bool validator = loginForm.isValidForm();
    loginForm.email = email.toString();
    loginForm.password = password.toString();

    return Container(
      child: Form(
          key: loginForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                controller: email_controller,
                onChanged: ((value) => loginForm.email),
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Email',
                    labelText: 'Correo electrónico',
                    prefixIcon: Icons.alternate_email),
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                  RegExp regExp = RegExp(pattern);
                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'El valor ingresado no corresponde con un email';
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: password_controller,
                onChanged: ((value) => loginForm.password),
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '*********',
                    labelText: 'Contraseña',
                    prefixIcon: Icons.lock_outline),
                validator: (value) {
                  return (value != null && value.length >= 6)
                      ? null
                      : 'La contraseña debe contener un minimo de 6 carácteres';
                },
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        if (validator == true && valuecheck == true) {
                          print('comprobacion correcta');
                          _setData();
                          print(prefs!.get('email'));
                          print(prefs!.get('password'));
                        }
                        if (validator == true && valuecheck == false) {
                          _deleteData();
                          print(prefs!.get('email'));
                          print(prefs!.get('password'));
                        }
                        FocusScope.of(context).unfocus();
                        if (!loginForm.isValidForm()) return;
                        loginForm.isLoading = true;

                        await Future.delayed(Duration(seconds: 2));
                        loginForm.isLoading = false;
                        Navigator.pushNamed(context, 'home');
                      },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurple,
                child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 10,
                    ),
                    child: Text(
                      loginForm.isLoading ? 'Cargando' : 'Acceder',
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
              Row(
                children: [
                  Checkbox(
                    activeColor: Colors.deepPurple,
                    value: valuecheck,
                    onChanged: (bool? value) {
                      setState(() => valuecheck = value!);
                      print(valuecheck);
                    },
                  ),
                  const Text('Recuerdame')
                ],
              ),
            ],
          )),
    );
  }
}
