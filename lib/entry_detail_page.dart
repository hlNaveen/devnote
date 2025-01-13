import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntryDetailPage extends StatefulWidget {
  final Map<String, String> entry;

  const EntryDetailPage({required this.entry});

  @override
  _EntryDetailPageState createState() => _EntryDetailPageState();
}

class _EntryDetailPageState extends State<EntryDetailPage> {
  late TextEditingController _contentController;
  late TextEditingController _codeController;
  late TextEditingController _documentationController;
  String _category = '';
  double _priority = 0.0;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _contentController = TextEditingController(text: widget.entry['content']);
    _codeController = TextEditingController(text: widget.entry['code']);
    _documentationController = TextEditingController(text: widget.entry['documentation']);
    _category = widget.entry['category'] ?? 'Work';
    _priority = double.parse(widget.entry['priority'] ?? '0.0');
  }

  Future<void> _saveChanges() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedEntries = prefs.getStringList('entries');

    if (storedEntries != null) {
      // Find the entry to update
      final index = storedEntries.indexWhere((entry) => entry.contains(widget.entry['date']!));

      if (index != -1) {
        final updatedEntry =
            '${widget.entry['date']}|${_contentController.text}|${_codeController.text}|${_documentationController.text}|$_category|$_priority|${widget.entry['tags']}';

        // Update the entry in the list
        storedEntries[index] = updatedEntry;

        // Save the updated list to SharedPreferences
        await prefs.setStringList('entries', storedEntries);

        // Notify user of success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Entry updated successfully!')),
        );

        // Go back or refresh
        Navigator.of(context).pop(true); // Returning true indicates that changes were made.
      }
    }
  }

  Future<void> _deleteEntry() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedEntries = prefs.getStringList('entries');

    if (storedEntries != null) {
      // Find the entry to delete
      final index = storedEntries.indexWhere((entry) => entry.contains(widget.entry['date']!));

      if (index != -1) {
        storedEntries.removeAt(index);

        // Save updated list
        await prefs.setStringList('entries', storedEntries);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Entry deleted successfully!')),
        );

        Navigator.pop(context); // Go back to the previous page
      }
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Entry'),
          content: Text('Are you sure you want to delete this entry?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteEntry();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entry Details'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
                _saveChanges();
              },
            ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailField('Date:', widget.entry['date']!),
              SizedBox(height: 16.0),
              _isEditing
                  ? _buildEditableTextField('Content:', _contentController)
                  : _buildDetailField('Content:', widget.entry['content']!),
              SizedBox(height: 16.0),
              _isEditing
                  ? _buildEditableTextField('Code Snippet:', _codeController, isCode: true)
                  : _buildDetailField('Code Snippet:', widget.entry['code']!),
              SizedBox(height: 16.0),
              _isEditing
                  ? _buildEditableTextField('Documentation:', _documentationController)
                  : _buildDetailField('Documentation:', widget.entry['documentation']!),
              SizedBox(height: 16.0),
              _isEditing
                  ? _buildCategoryDropdown()
                  : _buildDetailField('Category:', widget.entry['category']!),
              SizedBox(height: 16.0),
              _isEditing
                  ? _buildPrioritySlider()
                  : _buildDetailField('Priority:', widget.entry['priority']!),
              SizedBox(height: 16.0),
              _buildDetailField('Tags:', widget.entry['tags']!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailField(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8.0),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildEditableTextField(String label, TextEditingController controller, {bool isCode = false}) {
    return TextField(
      controller: controller,
      maxLines: isCode ? 10 : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _category,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      items: <String>['Work', 'Personal', 'Other'].map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _category = value!;
        });
      },
    );
  }

  Widget _buildPrioritySlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Priority'),
        Slider(
          value: _priority,
          min: 0,
          max: 5,
          divisions: 5,
          label: _priority.toString(),
          onChanged: (value) {
            setState(() {
              _priority = value;
            });
          },
        ),
      ],
    );
  }
}
