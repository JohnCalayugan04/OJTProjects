// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart'; // For ChangeNotifier
// import 'package:provider/provider.dart'; // For Provider
//
// /// A ChangeNotifier class to manage the search history.
// /// It provides methods to add, promote, and clear history entries.
// class SearchHistory extends ChangeNotifier {
//   final List<String> _history;
//
//   /// Initializes the search history with some default terms.
//   SearchHistory() : _history = <String>['flutter', 'dart', 'widgets'];
//
//   /// Returns an unmodifiable list of all history items, with the most recent at the end.
//   List<String> get allHistory => List<String>.unmodifiable(_history);
//
//   /// Returns an unmodifiable list of history items, with the most recent at the beginning,
//   /// suitable for displaying as recent suggestions.
//   List<String> get recentHistory =>
//       List<String>.unmodifiable(_history.reversed.toList());
//
//   /// Adds a new term to the history, or promotes it to the most recent if it already exists.
//   /// The comparison is case-insensitive.
//   void addOrPromote(String term) {
//     if (term.trim().isEmpty) {
//       return; // Do not add empty terms to history
//     }
//     final String lowerTerm = term.toLowerCase();
//     _history.removeWhere((String h) => h.toLowerCase() == lowerTerm);
//     _history.add(term);
//     notifyListeners();
//   }
//
// }
//
// /// A custom SearchDelegate for implementing search functionality with history.
// /// It leverages the SearchHistory ChangeNotifier for data management.
// class MySearchDelegate extends SearchDelegate<String> {
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     final SearchHistory searchHistory = Provider.of<SearchHistory>(
//       context,
//       listen: false,
//     );
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     // Add the current query to the search history when results are built.
//     // This ensures that user-typed terms are saved.
//     Provider.of<SearchHistory>(context, listen: false).addOrPromote(query);
//
//     return Center(child: Text('Search results for: $query'));
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final SearchHistory searchHistory = Provider.of<SearchHistory>(
//       context,
//       listen: true,
//     );
//     final List<String> historyItems = searchHistory.recentHistory;
//
//     final List<String> filteredSuggestions = query.isEmpty
//         ? historyItems
//         : historyItems
//         .where(
//           (String term) =>
//           term.toLowerCase().startsWith(query.toLowerCase()),
//     )
//         .toList();
//
//     if (filteredSuggestions.isEmpty && query.isNotEmpty) {
//       return Center(child: Text('No suggestions found for "$query"'));
//     } else if (filteredSuggestions.isEmpty &&
//         query.isEmpty &&
//         historyItems.isEmpty) {
//       return const Center(
//         child: Text('Start typing to search or see recent searches.'),
//       );
//     }
//
//     return ListView.builder(
//       itemCount: filteredSuggestions.length,
//       itemBuilder: (BuildContext context, int index) {
//         final String suggestion = filteredSuggestions[index];
//         return ListTile(
//           title: Text(suggestion),
//           onTap: () {
//             query = suggestion;
//             // When a suggestion is tapped, promote it and show results.
//             // addOrPromote is already called in buildResults, so it's handled there.
//             showResults(context);
//           },
//         );
//       },
//     );
//   }
// }
