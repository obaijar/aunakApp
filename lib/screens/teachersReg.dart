import 'package:flutter/material.dart';

class TeacherReg extends StatefulWidget {
  @override
  _TeacherRegState createState() => _TeacherRegState();
}

class _TeacherRegState extends State<TeacherReg> {
  List<bool> isSelected = [false, false, false];
  List<Color> colors = [Colors.white, Colors.white, Colors.white];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل أستاذ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'الإسم',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء ادخال الإسم';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'الإيميل',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الإيميل';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'الإيميل غير صحيح';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'كلمة السر',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة السر';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'تأكيد كلمة السر',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء تأكيد كلمة السر';
                  }
                  if (value != _passwordController.text) {
                    return 'لا يوجد تطابق';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              buildCard(0, "Physics", "Physics Description", "3"),
              buildCard(1, "Math", "Math Description", "2"),
              buildCard(2, "Philosophy", "Philosophy Description", "5"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission
                    print('Name: ${_nameController.text}');
                    print('Email: ${_emailController.text}');
                    print('Password: ${_passwordController.text}');
                  }
                },
                child: Text('تسجيل'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(int index, String title, String subtitle, String trailing) {
    return Card(
      color: colors[index],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            selected: isSelected[index],
            leading: const Icon(Icons.info),
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: Text(trailing),
            onLongPress: () => toggleSelection(index),
          ),
        ],
      ),
    );
  }

  void toggleSelection(int index) {
    setState(() {
      if (isSelected[index]) {
        colors[index] = Colors.white;
        isSelected[index] = false;
      } else {
        colors[index] = Colors.grey[300]!;
        isSelected[index] = true;
      }
    });
  }
}
