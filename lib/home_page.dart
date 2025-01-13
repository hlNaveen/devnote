import 'package:flutter/cupertino.dart';
import 'package:devnotes/view_entries_page.dart';


import 'add_new_entry_page.dart';

class JournalHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Dev Notes'),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.systemGroupedBackground,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Welcome to your Gratitude Journal',
                style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                'Reflect on your day and keep track of what you are grateful for.',
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontSize: 16,
                  color: CupertinoColors.secondaryLabel,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            CupertinoButton.filled(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => ViewEntriesPage()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.book),
                  SizedBox(width: 8),
                  Text('View Entries'),
                ],
              ),
            ),
            SizedBox(height: 20),
            CupertinoButton.filled(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => AddNewEntryPage()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.add),
                  SizedBox(width: 8),
                  Text('Add New Entry'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}