import 'package:flutter/material.dart';

class AddDecisionScreen extends StatefulWidget {
  @override
  _AddDecisionScreenState createState() => _AddDecisionScreenState();
}

class _AddDecisionScreenState extends State<AddDecisionScreen> {
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Decision')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Default form',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Basic form layout',
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(height: 24),

              // Username
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  hintText: 'Username',
                ),
                onSaved: (value) => username = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter username';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Email
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email address',
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => email = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter email';
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value))
                    return 'Please enter a valid email';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Password
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
                obscureText: true,
                onSaved: (value) => password = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter password';
                  if (value.length < 6)
                    return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Confirm Password
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
                obscureText: true,
                onSaved: (value) => confirmPassword = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please confirm your password';
                  if (value != password) return 'Passwords do not match';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Remember me Checkbox
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (bool? newValue) {
                      setState(() {
                        rememberMe = newValue ?? false;
                      });
                    },
                  ),
                  Text('Remember me'),
                ],
              ),
              SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Submit'),
                      onPressed: () {
                        final form = _formKey.currentState!;
                        if (form.validate()) {
                          form.save();
                          // هنا يمكنك تنفيذ ما تريده بعد الحفظ، مثل إرسال البيانات أو عرض رسالة
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Form submitted successfully'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        _formKey.currentState?.reset();
                        setState(() {
                          rememberMe = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
