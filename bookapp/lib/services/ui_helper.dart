import 'package:flutter/material.dart';

class UIHelper{

   static Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this item?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    ) ?? false; // Returning false if the dialog is dismissed
  }

   static void showNotification(BuildContext context, String message) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text(
           message,
           style: TextStyle(
             color: Theme.of(context).colorScheme.onTertiary,
           ),
         ),
         backgroundColor: Theme.of(context).colorScheme.tertiary,
       ),
     );
   }

}