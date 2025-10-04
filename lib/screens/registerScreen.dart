import 'package:flutter/material.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<Registerscreen> {
  bool iiSigUp = false;
  bool _obscure = true;
  bool _subimitting = false;

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? "";
    if (value.isEmpty) return "Informe Email";
    final ok = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$").hasMatch(value);
    if (!ok) return "Email inválido";
    return null;
  }

  String? _validatePassword(String? v) {
    final value = v?.trim() ?? "";
    if (value.isEmpty) return "Informe a senha";
    if (value.length < 6) return "Senha deve ter pelo menos 6 caracteres";
    return null;
  }

  String? _validateConfirmPassword(String? v) {
    if (v == null || v.isEmpty) return "Confirme a senha";
    if (v != _passCtrl.text) return "As senhas não coincidem";
    return null;
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _subimitting = true);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 800));

      final mode = iiSigUp ? 'Sign Up' : 'Sign In';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$mode ok (mock)')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao autenticar. Tente novamente.')),
      );
    } finally {
      if (mounted) setState(() => _subimitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const corPrincipal = Color(0xFF1E88E5);
    const background = Color(0xFFF5F7FA);
    const corTexto = Color(0xFF37474F);
    final corDica = Colors.grey.shade600;

    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: <Widget>[
              Image.asset("assets/logo.png", height: 150),
              const SizedBox(height: 50),
              Container(
                height: 350,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        controller: _emailCtrl,
                        style: const TextStyle(
                          color: corTexto,
                          fontWeight: FontWeight.w500,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: corDica),
                          hintText: "seu.email@exemplo.com",
                          hintStyle: TextStyle(color: corDica),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: corPrincipal,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: corPrincipal,
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passCtrl,
                        style: const TextStyle(
                          color: corTexto,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          labelText: "Senha",
                          labelStyle: TextStyle(color: corDica),
                          hintText: "Digite sua senha",
                          hintStyle: TextStyle(color: corDica),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: corPrincipal,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: corPrincipal,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: corPrincipal,
                              width: 2.0,
                            ),
                          ),
                        ),
                        obscureText: _obscure,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPassCtrl,
                        style: const TextStyle(
                          color: corTexto,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          labelText: "Confirmar Senha",
                          labelStyle: TextStyle(color: corDica),
                          hintText: "Repita sua senha",
                          hintStyle: TextStyle(color: corDica),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: corPrincipal,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: corPrincipal,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: corPrincipal,
                              width: 2.0,
                            ),
                          ),
                        ),
                        obscureText: _obscure,
                        validator: _validateConfirmPassword,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _subimitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: corPrincipal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: _subimitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Registrar",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
