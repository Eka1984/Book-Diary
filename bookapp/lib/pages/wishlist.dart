import 'package:flutter/material.dart';
import 'package:bookapp/services/database_helper.dart';
import 'package:bookapp/services/ui_helper.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {

  //Input fields controllers in editing form
  final formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _commentsController = TextEditingController();

  //List number in the radio buttons in editing field
  int? _chosenListNum = 1;

  //List with data fetched from the database
  List<Map<String, dynamic>> myData = [];

  //Function that makes sure input fields are not empty when form is sent
  String? validateMyTextField(String? value){
    if(value!.isEmpty) return 'Field is required';
    return null;
  }

  //Function refreshing myData variable and the list of books
  _refreshData() async {
    final data = await DatabaseHelper.getItems(1);
    setState(() {
      myData = data;
    });
  }

  //Function that updates a book entry
  Future<void> updateItem(int id) async{
    await DatabaseHelper.updateItem(id, _titleController.text, _authorController.text, _commentsController.text, _chosenListNum);
    _refreshData();
  }

  //Function that deletes a book entry
  void deleteItem(int id) async {
    bool confirmDelete = await UIHelper.showDeleteConfirmationDialog(context);
    if (confirmDelete) {
      await DatabaseHelper.deleteItem(id);
      UIHelper.showNotification(context, "The book is deleted!");
      _refreshData();
    }
  }

  //Refreshing the list of books on the first load of the page
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          "Wishlist",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 30,
            //fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      //Text that is shown, if there are no book entries
      body: myData.isEmpty ? Center(
        child: Text(
          "No books here yet!",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        //Building the list of books
      ) : ListView.builder(
          shrinkWrap: true,
          itemCount: myData.length,
          itemBuilder: (context, index) {
            return Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(myData[index]['title']),
                subtitle: Text(myData[index]['author']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //View icon
                    IconButton(
                        onPressed: () => ShowMyForm(myData[index]['id']),
                        icon: const Icon(Icons.visibility)
                    ),
                    //Delete icon
                    IconButton(
                        onPressed: () async => deleteItem(myData[index]['id']),
                        icon: const Icon(Icons.delete)
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

  //Function that opens an editing form
  void ShowMyForm(int? id) async {
    if(id != null){
      //Searching through myData for the book entry with the given id
      final existingData = myData.firstWhere((element) => element['id'] == id);
      //Filling in the input fields with the book data
      _titleController.text = existingData['title'];
      _authorController.text = existingData['author'];
      _commentsController.text = existingData['comments'];
      // Setting the list in the radio buttons
      _chosenListNum = existingData['status'];
    }
    else{
      _titleController.text = "";
      _authorController.text = "";
    }

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
                      child: TextFormField(
                        validator: validateMyTextField,
                        controller: _titleController,
                        decoration: const InputDecoration(hintText: "title"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: TextFormField(
                        validator: validateMyTextField,
                        controller: _authorController,
                        decoration: const InputDecoration(hintText: "author"),
                      ),
                    ),
                    // New TextFormField for comments
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 7),
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
                        InkWell(
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

                        //Update button
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if(id != null){
                                await updateItem(id);
                                UIHelper.showNotification(context, "The book is updated!");
                              }

                              Navigator.pop(context);
                            }
                            setState(() {
                              _titleController.text = "";
                              _authorController.text = "";
                              _commentsController.text = "";
                            });
                          },
                          child: Text(
                            "Update",
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
