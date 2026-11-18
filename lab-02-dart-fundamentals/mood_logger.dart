import 'dart:io';

// ============================================================================
// MoodEntry Class
// ============================================================================

/// Represents a single mood log entry.
///
/// Fields:
///   - DateTime createdAt  -- when the entry was created
///   - int score           -- mood score from 1 (very bad) to 10 (excellent)
///   - String? note        -- an optional short description of the mood;
///                            null when the user wrote nothing
///
/// The Flutter Mood Tracker you build from Lab 3 onwards uses the same three
/// fields, so this class carries over almost unchanged.
class MoodEntry {
  final DateTime createdAt;
  final int score;
  final String? note;

  MoodEntry(this.score, [this.note])
    : assert(score >= 1 && score <= 10, 'Score must be between 1 and 10'),
      createdAt = DateTime.now();

  /// Returns a formatted string representation of this entry.
  /// Format: "[YYYY-MM-DD HH:MM] Score: <score>/10 - <note>"
  /// When there is no note, show "(no note)" in its place.
  @override
  String toString() {
    return '[${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}] Score: $score/10 - ${note ?? '(no note)'}';
  }
}

// ============================================================================
// MoodLogger Class
// ============================================================================

/// Manages a collection of MoodEntry objects.
class MoodLogger {
  final List<MoodEntry> _entries = [];

  /// Adds a new mood entry with the given score and optional note.
  /// Validates that score is between 1 and 10 (inclusive).
  /// If invalid, prints an error message and does NOT add the entry.
  /// A note that is empty or only spaces is stored as null.

  void addEntry(int score, String? note) {
    note = note?.trim();

    if (score > 10 || score < 1) {
      print('The score must be between 1-10');
      return;
    } else if (note == '') {
      note = null;
    }

    final entry = MoodEntry(score, note);
    _entries.add(entry);
    print('Entry added!');
  }

  /// Returns a copy of all entries.
  List<MoodEntry> getAllEntries() => List.from(_entries);

  /// Calculates and returns the average mood score.
  /// Returns null if there are no entries: there is no average to report,
  /// and 0.0 would look like a real (very bad) score.
  double? getAverageScore() {
    if (_entries.isEmpty) return null;
    return _entries.fold<int>(0, (acc, e) => acc + e.score) / _entries.length;
  }

  /// Returns all entries with a score greater than or equal to [threshold].
  List<MoodEntry> getEntriesAbove(int threshold) =>
      _entries.where((entry) => entry.score >= threshold).toList();

  /// Returns the total number of entries.
  int get entryCount {
    return _entries.length;
  }
}

// ============================================================================
// Main -- Interactive CLI
// ============================================================================

void main() {
  final logger = MoodLogger();

  print('=== Mood Logger ===');
  print('Track your daily mood on a scale of 1-10.\n');

  bool running = true;
  while (running) {
    print('1. Add mood entry');
    print('2. View all entries');
    print('3. View average mood');
    print('4. Filter by minimum score');
    print('5. Quit');
    stdout.write('\nChoose an option: ');

    String? input = stdin.readLineSync();
    int? choice = int.tryParse(input ?? '');

    switch (choice) {
      case 1:
        stdout.write('Enter a mood score (1-10): ');
        int? score = int.tryParse(stdin.readLineSync() ?? '');
        if (score == null) {
          print('Please enter a number.');
          break;
        }
        stdout.write('Enter a note (or press Enter for none): ');
        String? note = stdin.readLineSync();
        logger.addEntry(score, note);
        break;
      case 2:
        List<MoodEntry> entries = logger.getAllEntries();
        if (entries.isEmpty)
          print('No entries yet');
        else {
          for (final e in entries) print(e);
        }

        break;
      case 3:
        double? avg = logger.getAverageScore();
        if (avg == null)
          print('No entries yet. Add some entries first!');
        else
          print(
            'Average mood score: ${avg.toStringAsFixed(1)} (based on ${logger.entryCount} entries)',
          );
        break;
      case 4:
        stdout.write('Enter a threshold: ');
        int? threshold = int.tryParse(stdin.readLineSync() ?? '');
        if (threshold == null) {
          print('Please enter a number.');
          break;
        }
        List<MoodEntry> filtered = logger.getEntriesAbove(threshold);
        if (filtered.isEmpty)
          print('No entries with that score or higher');
        else
          for (final e in filtered) print(e);

        break;
      case 5:
        running = false;
        print('Goodbye!');
        break;
      default:
        print('Invalid option. Please choose 1-5.');
    }
    print('');
  }
}
