import 'package:bookapp/pages/reading_now.dart';
import 'package:bookapp/pages/wishlist.dart';
import 'package:bookapp/pages/read.dart';
import 'package:bookapp/services/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:bookapp/services/database_helper.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  final int numberOfBooksRead;
  const HomePage({Key? key, this.numberOfBooksRead = 0}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numberOfBooksRead = 0; //variable for demonstrating the number of read books on home screen

  //input window controllers in the ADD form
  final formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _commentsController = TextEditingController();

  //List number from radio buttons in the ADD form
  int? _chosenListNum = 1;

  //Function that check if input fields are empty
  String? validateMyTextField(String? value){
    if(value!.isEmpty) return 'Field is required';
    return null;
  }

  //Function that refreshes the home page after return from the other pages
  void navigateAndRefreshOnReturn(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ).then((_) {
      // This part gets called when returning to the HomePage
      _refreshData();
    });
  }

  //Function that refreshes the number of read books on Home page
  _refreshData() async {
    final data = await DatabaseHelper.countBooksByStatus(3);
    setState(() {
      numberOfBooksRead = data;
    });
  }

  //Function
  Future<void> addItem() async{
    await DatabaseHelper.createItem(_titleController.text, _authorController.text, _commentsController.text, _chosenListNum);
    _refreshData();
  }

 //Refreshing the number of books at first loading of the page
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    //Variables with width and height of the screen
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
        "BOOKPAL",
        style: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 25,
            //fontWeight: FontWeight.bold,
        ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(15.0),
          child: Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            child: Text(
              'Because I read',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 16, // Adjust the font size as needed
              ),
            ),
          ),
        ),
      ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.05),
              //Element with the number of read books
              Text("BOOKS READ",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
              ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                width: screenWidth * 0.45,
                height: screenWidth * 0.45,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$numberOfBooksRead',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiary,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              //Buttons leading to lists of books
              Padding(
              padding: const EdgeInsets.all(13.0), // Adjust padding to control button width
              child: ElevatedButton(
              onPressed: () {
                navigateAndRefreshOnReturn(context, Wishlist());
              },
              child: Text('Wishlist',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 25,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(screenHeight * 0.07),
                backgroundColor: Theme.of(context).colorScheme.primary,
                elevation: 10,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0), // Adjust padding to control button width
                child: ElevatedButton(
                  onPressed: () {
                    navigateAndRefreshOnReturn(context, ReadingNow());
                  },
                  child: Text('Reading Now',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 25,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(screenHeight * 0.07),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      elevation: 10,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0), // Adjust padding to control button width
                child: ElevatedButton(
                  onPressed: () {
                    navigateAndRefreshOnReturn(context, Read());
                  },
                  child: Text('Read',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiary,
                      fontSize: 25,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(screenHeight * 0.07),
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      elevation: 10,
                    // You can also add additional styling here
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //ADD Button for adding new books
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 45, 35, 0),
                    child: ElevatedButton.icon(
                        onPressed: (){
                          ShowMyForm(null);
                        },
                        icon: Icon(
                            Icons.add,
                          size: 40,
                        ),
                      label: Text(
                          'ADD',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        elevation: 10,
                        minimumSize: Size(130, 60),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
    );
  }

  //Function that opens a form for adding a new book
  void ShowMyForm(int? id) async {
    //Removing old text from the input fields
    _titleController.text = "";
    _authorController.text = "";
    _commentsController.text = "";
    _chosenListNum = 1;

    showModalBottomSheet(
        elevation: 5,
        isDismissible: false,
        isScrollControlled: true,
        context: context, builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(_).viewInsets.bottom
      ),
      child: SingleChildScrollView(
        child: StatefulBuilder( // Wrap with StatefulBuilder
        builder: (BuildContext context, StateSetter setStateModal) { // Note the setStateModal for local updates
          return Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  //Title input field
                  child: TextFormField(
                    validator: validateMyTextField,
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: "title"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  //Author input field
                  child: TextFormField(
                    validator: validateMyTextField,
                    controller: _authorController,
                    decoration: const InputDecoration(hintText: "author"),
                  ),
                ),
                // New TextFormField for comments
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 7),
                  //Comments input field
                  child: TextFormField(
                    controller: _commentsController,
                    decoration: const InputDecoration(hintText: "comments"),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3, // Increase this for a larger input area
                  ),
                ),

                //Radio Buttons
                Row(
                  children: [
                    SizedBox(width: 10),
                    InkWell( //Inkwell widget makes its children (radio + text) responsive to touch
                      onTap: () {
                        setStateModal(() {
                          _chosenListNum = 1;
                        });
                      },
                      child: Row(
                        children: [
                          Radio<int>(
                            value: 1,
                            groupValue: _chosenListNum,
                            onChanged: (int? value) {
                              setStateModal(() {
                                _chosenListNum = value;
                              });
                            },
                          ),
                          Text("Wishlist"),
                        ],
                      ),
                    ),
                    //SizedBox(width: 15), // Spacing between options
                    InkWell(
                      onTap: () {
                        setStateModal(() {
                          _chosenListNum = 2;
                        });
                      },
                      child: Row(
                        children: [
                          Radio<int>(
                            value: 2,
                            groupValue: _chosenListNum,
                            onChanged: (int? value) {
                              setStateModal(() {
                                _chosenListNum = value;
                              });
                            },
                          ),
                          Text("Reading now"),
                        ],
                      ),
                    ),
                    //SizedBox(width: 15), // Spacing between options
                    InkWell(
                      onTap: () {
                        setStateModal(() {
                          _chosenListNum = 3;
                        });
                      },
                      child: Row(
                        children: [
                          Radio<int>(
                            value: 3,
                            groupValue: _chosenListNum,
                            onChanged: (int? value) {
                              setStateModal(() {
                                _chosenListNum = value;
                              });
                            },
                          ),
                          Text("Read"),
                        ],
                      ),
                    ),
                  ],
                ),



                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Exit button
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Exit",
                          style: TextStyle(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .onSecondary,
                            fontSize: 20,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 60),
                          backgroundColor: Theme
                              .of(context)
                              .colorScheme
                              .secondary,
                          elevation: 5,
                        )
                    ),

                    //Create button
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          addItem();
                          Navigator.pop(context);
                          UIHelper.showNotification(context, "The book is added!");
                        }
                        setState(() {
                          _titleController.text = "";
                          _authorController.text = "";
                          _commentsController.text = "";
                        });
                      },
                      child: Text(
                        "Create",
                        style: TextStyle(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onPrimary,
                          fontSize: 20,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 60),
                        backgroundColor: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                        elevation: 5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
              ],
            ),
          );
        },
        )
      ),
    ));
  }

}
