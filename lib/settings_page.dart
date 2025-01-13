import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _notificationsEnabled = true; // Placeholder for state management
    String _selectedLanguage = 'English'; // Placeholder for language selection
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Theme'),
            trailing: DropdownButton<String>(
              value: Theme.of(context).brightness == Brightness.dark ? 'Dark' : 'Light',
              items: ['Light', 'Dark'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue == 'Dark') {
                  // Add logic to change to dark theme
                } else {
                  // Add logic to change to light theme
                }
              },
            ),
          ),
          ListTile(
            title: Text('Notifications'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (bool value) {
                // Add logic to toggle notifications
                _notificationsEnabled = value;
              },
            ),
          ),
          ListTile(
            title: Text('Language'),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              items: ['English', 'Spanish', 'French'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // Add logic to change language
                _selectedLanguage = newValue!;
              },
            ),
          ),
          ListTile(
            title: Text('About'),
            subtitle: Text('Version 1.0.0'),
          ),
          ListTile(
            title: Text('Send Feedback'),
            trailing: Icon(Icons.feedback),
            onTap: () {
              // Add logic to open feedback form
            },
          ),
        ],
      ),
    );
  }
}
