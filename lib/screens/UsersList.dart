import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<dynamic> users = [];
  List<dynamic> filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  String? _authToken;
  int? _pendingDeleteUserId; // To keep track of the user pending deletion

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchUsers();
  }

  Future<void> _loadTokenAndFetchUsers() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('token');
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Dio().get(
        'https://obai.aunakit-hosting.com/users/',
        options: Options(
          headers: _buildHeaders(),
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          users = response.data;
          filteredUsers = users;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load users')),
      );
    }
  }

  Future<void> _deleteUser(int userId) async {
    try {
      final response = await Dio().delete(
        'https://obai.aunakit-hosting.com/delete-user/$userId/',
        options: Options(
          headers: _buildHeaders(),
        ),
      );
      if (response.statusCode == 204) {
        setState(() {
          users.removeWhere((user) => user['id'] == userId);
          filteredUsers.removeWhere((user) => user['id'] == userId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم الحذف بنجاح')),
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في الحذف')),
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog(int userId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('هل أنت متأكد من حذف هذا المستخدم ؟'),
          actions: <Widget>[
            TextButton(
              child: const Text('لا'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  _pendingDeleteUserId = null; // Reset the pending delete user
                });
              },
            ),
            TextButton(
              child: const Text('نعم'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteUser(userId); // Proceed with deletion
              },
            ),
          ],
        );
      },
    );
  }

  void _filterUsers(String query) {
    final filtered = users.where((user) {
      final name = user['username'].toLowerCase();
      final search = query.toLowerCase();
      return name.contains(search);
    }).toList();

    setState(() {
      filteredUsers = filtered;
    });
  }

  Map<String, String> _buildHeaders() {
    return {
      'Authorization': 'Token $_authToken',
      'Content-Type': 'application/json',
    };
  }

  void _navigateToChangePassword(int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChangePasswordScreen(userId: userId, authToken: _authToken!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المستخدمين'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterUsers,
              decoration: const InputDecoration(
                labelText: 'بحث',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return _pendingDeleteUserId == user['id']
                    ? Container() // Temporarily hide the item
                    : Dismissible(
                        key: Key(user['id'].toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            _pendingDeleteUserId = user['id'];
                          });
                          _showDeleteConfirmationDialog(user['id']);
                        },
                        background: Container(color: Colors.red),
                        child: ListTile(
                          title: Text(user['username']),
                          onTap: () => _navigateToChangePassword(user['id']),
                        ),
                      );
              },
            ),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  final int userId;
  final String authToken;

  ChangePasswordScreen({required this.userId, required this.authToken});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _changePassword() async {
    final newPassword = _passwordController.text;
    if (newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال كلمة المرور')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await Dio().post(
        "https://obai.aunakit-hosting.com/api/admin/change-password/",
        options: Options(
          headers: {
            'Authorization': 'Token ${widget.authToken}',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status! < 500; // Accept all status codes less than 500
          },
        ),
        data: json.encode({
          'user_id': widget.userId,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تغيير كلمة المرور')),
        );
        Navigator.pop(context);
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في تغيير كلمة المرور: ${response.data}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل في تغيير كلمة المرور')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تغيير كلمة المرور')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TextField(
                    controller: _passwordController,
                    decoration:
                        const InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _changePassword,
                    child: const Text('Change Password'),
                  ),
                ],
              ),
      ),
    );
  }
}
