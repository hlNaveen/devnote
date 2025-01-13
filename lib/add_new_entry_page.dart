import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewEntryPage extends StatefulWidget {
  @override
  _AddNewEntryPageState createState() => _AddNewEntryPageState();
}

class _AddNewEntryPageState extends State<AddNewEntryPage> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _codeSnippetController = TextEditingController();
  final TextEditingController _documentationController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  String _category = 'Work';
  double _priority = 3.0;

  Future<void> _saveEntry() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> entries = prefs.getStringList('entries') ?? [];

    final newEntry = '${DateTime.now().toIso8601String()}|'
        '${_contentController.text}|'
        '${_codeSnippetController.text}|'
        '${_documentationController.text}|'
        '$_category|'
        '$_priority|'
        '${_tagsController.text}';

    entries.add(newEntry);
    await prefs.setStringList('entries', entries);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Entry'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveEntry,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInputField(
              controller: _contentController,
              label: 'Content',
              hintText: 'Enter content here',
            ),
            _buildInputField(
              controller: _codeSnippetController,
              label: 'Code Snippet',
              hintText: 'Enter code snippet here',
              maxLines: 5,
            ),
            _buildInputField(
              controller: _documentationController,
              label: 'Documentation',
              hintText: 'Enter documentation here',
              maxLines: 5,
            ),
            _buildDropdownField(
              value: _category,
              label: 'Category',
              items: ['Work', 'Personal', 'Other'],
              onChanged: (value) {
                setState(() {
                  _category = value!;
                });
              },
            ),
            _buildSliderField(
              value: _priority,
              label: 'Priority: $_priority',
              onChanged: (value) {
                setState(() {
                  _priority = value;
                });
              },
            ),
            _buildInputField(
              controller: _tagsController,
              label: 'Tags',
              hintText: 'Enter tags here',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String label,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: onChanged,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSliderField({
    required double value,
    required String label,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Slider(
            value: value,
            min: 1.0,
            max: 5.0,
            divisions: 4,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
