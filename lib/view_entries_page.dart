import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'entry_detail_page.dart';

class ViewEntriesPage extends StatefulWidget {
  @override
  _ViewEntriesPageState createState() => _ViewEntriesPageState();
}

class _ViewEntriesPageState extends State<ViewEntriesPage> {
  List<Map<String, String>> _entries = [];
  List<Map<String, String>> _filteredEntries = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  double _minPriority = 0.0;
  double _maxPriority = 5.0;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entries = prefs.getStringList('entries') ?? [];

    setState(() {
      _entries = entries.map((entry) {
        final parts = entry.split('|');
        return {
          'date': parts[0],
          'content': parts[1],
          'code': parts[2],
          'documentation': parts[3],
          'category': parts[4],
          'priority': parts[5],
          'tags': parts[6],
        };
      }).toList();
      _filteredEntries = _entries; // Initialize with full entries list
    });
    _filterEntries(); // Apply filter on load
  }

  void _filterEntries() {
    setState(() {
      _filteredEntries = _entries.where((entry) {
        final matchesSearch =
        entry['content']!.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory =
            _selectedCategory == 'All' || entry['category'] == _selectedCategory;
        final priority = double.parse(entry['priority']!);
        final matchesPriority =
            priority >= _minPriority && priority <= _maxPriority;
        return matchesSearch && matchesCategory && matchesPriority;
      }).toList();
    });
  }

  Future<void> _deleteEntry(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = prefs.getStringList('entries') ?? [];
    entries.removeAt(index);
    await prefs.setStringList('entries', entries);

    _loadEntries();
  }

  Future<void> _navigateToDetailPage(Map<String, String> entry) async {
    // Navigate to the entry detail page and wait for a result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntryDetailPage(entry: entry),
      ),
    );

    // Check if a result is returned to refresh the entries list
    if (result == true) {
      _loadEntries(); // Reload the entries if changes were made
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Entries'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadEntries,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterOptions(),
          Expanded(
            child: _filteredEntries.isEmpty
                ? Center(
              child: Text(
                'No entries found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _filteredEntries.length,
              itemBuilder: (context, index) {
                final entry = _filteredEntries[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        _formatDate(entry['date']!),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        entry['content']!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteEntry(index),
                      ),
                      onTap: () => _navigateToDetailPage(entry), // Updated to navigate
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Search entries',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _filterEntries();
          });
        },
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              items: <String>['All', 'Work', 'Personal', 'Other']
                  .map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                  _filterEntries();
                });
              },
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Priority Range'),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
                  ),
                  child: RangeSlider(
                    values: RangeValues(_minPriority, _maxPriority),
                    min: 0,
                    max: 5,
                    divisions: 5,
                    labels: RangeLabels(
                      _minPriority.toString(),
                      _maxPriority.toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _minPriority = values.start;
                        _maxPriority = values.end;
                        _filterEntries();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoDate) {
    final dateTime = DateTime.parse(isoDate);
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}
