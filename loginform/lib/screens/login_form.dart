import 'package:flutter/material.dart';
import 'package:loginform/providers/usuari_provider.dart';
import 'package:provider/provider.dart';


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String? _authError;

  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  handleSubmit(bool value) {
    // Si el formulario no es válido, no se hace nada
    if (!_formKey.currentState!.validate()) return;
    
    // Obtener inputs del controlador
    final email = _emailController.value.text;
    final password = _passwordController.value.text;

    var usuariProvider = Provider.of<UsuariProvider>(context, listen: false); // Obtener el provider de usuario
    usuariProvider.setUsuari(email); // Guardar el usuario en el provider
    usuariProvider.setContrasenya(password); // Guardar la contraseña en el provider
    Navigator.pushReplacementNamed(context, 'home');
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField( // jtextField para el usuario
                controller: _emailController, // Asignar controlador, vincula al att _emailController.
                // Validar el input
                validator: (value) { // Usa el validador para asegurarse de que no está vacío.
                  // devuelve texto de error si no es correcto, de lo contrario no devuelve nada
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
              ),

              // jTextField para la contraseña
              TextFormField(
                  // Asignar controlador, vincula al att _passwordController
                  controller: _passwordController,
                  obscureText: true,
                  // Función para validar el usuario
                  validator: (value) { // Condición usada para validar desde el handlesubmit
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                  )),
              
              SizedBox(
                height: 16.0,
              ),

              // Botones para iniciar sesión o registrarse (en horizontal)
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly, // Espaciado parejo entre botones
                children: [

                  // Botón para iniciar sesión
                  ElevatedButton(
                    // onPressed: handleSubmit(true), ejecuta en tiempo de construcción
                    onPressed: () => handleSubmit(true), // lamba exp, ejecuta al apretar el botón
                    child: Text('Login'),
                  ),

                  // Botón para registrarse
                  ElevatedButton(
                    onPressed: () => handleSubmit(false),
                    child: Text('Register'),
                  ),
                ],
              ),

              // Menajes de error
              // Si hay un error (por ejemplo, usuario no encontrado), se muestra aquí en rojo.
              if (_authError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    _authError!,
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          )),
      ),
    );
  }
}