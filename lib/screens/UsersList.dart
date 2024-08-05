import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/users/'),
      headers: _buildHeaders(),
    );
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(utf8.decode(response.bodyBytes));
        filteredUsers = users;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users')),
      );
    }
  }

  Future<void> _deleteUser(int userId) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/delete-user/$userId/'),
      headers: _buildHeaders(),
    );
    if (response.statusCode == 204) {
      setState(() {
        users.removeWhere((user) => user['id'] == userId);
        filteredUsers.removeWhere((user) => user['id'] == userId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم الحذف بنجاح')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في الحذف')),
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog(int userId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  _pendingDeleteUserId = null; // Reset the pending delete user
                });
              },
            ),
            TextButton(
              child: Text('Yes'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterUsers,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
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
                        ),
                      );
              },
            ),
    );
  }
}
