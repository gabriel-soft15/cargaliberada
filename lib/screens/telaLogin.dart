import 'package:flutter/material.dart';

class Telalogin extends StatefulWidget {
  const Telalogin({super.key});

  @override
  State<Telalogin> createState() => _TelaloginState();
}

class _TelaloginState extends State<Telalogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 227, 227),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('lib/img/logocargaliberada.png', height: 250),

              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(250, 255, 255, 255),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(66, 3, 19, 118),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 18),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(66, 2, 26, 179),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () {},

                        child: const Text('Entrar'),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Cadastro'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ); //
  }
}
