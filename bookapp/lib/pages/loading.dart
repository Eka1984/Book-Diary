import 'package:flutter/material.dart';
import 'package:bookapp/services/database_helper.dart';
import 'package:bookapp/pages/home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    int numberOfBooksRead = await DatabaseHelper.countBooksByStatus(3); // Replace with your data fetching logic
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(numberOfBooksRead: numberOfBooksRead),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "BOOKPAL",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 35,
              ),
            ),
            SizedBox(height: 30),
            SpinKitFadingCircle(
              color: Theme.of(context).colorScheme.onPrimary,
              size: 100.0,
            ),
          ],
        ),
      ),
    );
  }
}
