import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:excel/excel.dart';

// --- Data Models ---

/// Represents a single entry of soil data from the dataset.
class SoilDataEntry {
  final String block;
  final String panchayat;
  final String surveyNo;
  final double ph;
  final double ec;
  final double oc;
  final double n;
  final double p;
  final double k;
  final double s;
  final double zn;
  final double fe;
  final double mn;
  final double cu;
  final double b;
  final String cropRecommendation;
  final String cropRemarks;

  SoilDataEntry({
    required this.block,
    required this.panchayat,
    required this.surveyNo,
    required this.ph,
    required this.ec,
    required this.oc,
    required this.n,
    required this.p,
    required this.k,
    required this.s,
    required this.zn,
    required this.fe,
    required this.mn,
    required this.cu,
    required this.b,
    required this.cropRecommendation,
    required this.cropRemarks,
  });

  /// Factory constructor to create a SoilDataEntry from a row in an Excel sheet.
  factory SoilDataEntry.fromExcelRow(List<Data?> row) {
    // Helper to safely parse a cell's value to a double, defaulting to 0.0
    double parseDouble(Data? cell) {
      if (cell == null || cell.value == null) return 0.0;
      if (cell.value is num) return cell.value.toDouble();
      return double.tryParse(cell.value.toString()) ?? 0.0;
    }

    // Helper to safely parse a cell's value to a string
    String parseString(Data? cell, [String defaultValue = '']) {
      return cell?.value?.toString() ?? defaultValue;
    }

    return SoilDataEntry(
      block: parseString(row.length > 0 ? row[0] : null, 'N/A'),
      panchayat: parseString(row.length > 1 ? row[1] : null, 'N/A'),
      surveyNo: parseString(row.length > 2 ? row[2] : null, 'N/A'),
      ph: parseDouble(row.length > 3 ? row[3] : null),
      ec: parseDouble(row.length > 4 ? row[4] : null),
      oc: parseDouble(row.length > 5 ? row[5] : null),
      n: parseDouble(row.length > 6 ? row[6] : null),
      p: parseDouble(row.length > 7 ? row[7] : null),
      k: parseDouble(row.length > 8 ? row[8] : null),
      s: parseDouble(row.length > 9 ? row[9] : null),
      zn: parseDouble(row.length > 10 ? row[10] : null),
      fe: parseDouble(row.length > 11 ? row[11] : null),
      mn: parseDouble(row.length > 12 ? row[12] : null),
      cu: parseDouble(row.length > 13 ? row[13] : null),
      b: parseDouble(row.length > 14 ? row[14] : null),
      cropRecommendation: parseString(row.length > 15 ? row[15] : null, 'Unknown'),
      cropRemarks: parseString(row.length > 16 ? row[16] : null, 'No remarks available.'),
    );
  }
}

/// Represents the result of a crop recommendation query.
class CropRecommendationResult {
  final String cropName;
  final String remarks;
  final double confidence;

  CropRecommendationResult({
    required this.cropName,
    required this.remarks,
    this.confidence = 1.0,
  });
}

// --- Enums ---
enum Season { kharif, rabi, zaid, any }

// --- Database Service (Singleton) ---

/// Manages loading, parsing, and providing access to the soil dataset from the XLSX asset.
class SoilDatabase {
  static final SoilDatabase _instance = SoilDatabase._internal();
  factory SoilDatabase() => _instance;
  SoilDatabase._internal();

  List<SoilDataEntry> _entries = [];
  List<String> _uniquePanchayats = [];
  Map<String, double> _minValues = {};
  Map<String, double> _maxValues = {};
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    await _loadDataFromExcel();
    _isInitialized = true;
  }

  // Public accessors
  List<SoilDataEntry> get entries => _entries;
  List<String> get uniquePanchayats => _uniquePanchayats;
  Map<String, double> get minValues => _minValues;
  Map<String, double> get maxValues => _maxValues;

  /// Loads the XLSX file from assets, iterates all sheets, and parses the data.
  Future<void> _loadDataFromExcel() async {
    try {
      ByteData data = await rootBundle.load("assets/crop_data.xlsx");
      var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      var excel = Excel.decodeBytes(bytes);

      List<SoilDataEntry> allEntries = [];
      for (var table in excel.tables.keys) { // Iterate over all sheets
        var sheet = excel.tables[table]!;
        for (var i = 1; i < sheet.maxRows; i++) { // Skip header row (i > 0)
          try {
            // Ensure the row has enough columns to be valid
            if (sheet.row(i).length > 15 && sheet.row(i)[15] != null) {
              allEntries.add(SoilDataEntry.fromExcelRow(sheet.row(i)));
            }
          } catch (e) {
            if (kDebugMode) {
              print('Skipping malformed row ${i + 1} in sheet $table: $e');
            }
          }
        }
      }
      _entries = allEntries;

      _uniquePanchayats = _entries.map((e) => e.panchayat).toSet().where((p) => p != 'N/A').toList()..sort();

      if (_entries.isNotEmpty) {
        _calculateNormalizationBounds();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading soil data from Excel: $e');
      }
      throw Exception('Failed to load crop database. Ensure "assets/crop_data.xlsx" exists and is correctly formatted.');
    }
  }

  /// Pre-calculates min/max values for data normalization.
  void _calculateNormalizationBounds() {
    final first = _entries.first;
    _minValues = {'ph': first.ph, 'ec': first.ec, 'oc': first.oc, 'n': first.n, 'p': first.p, 'k': first.k};
    _maxValues = {'ph': first.ph, 'ec': first.ec, 'oc': first.oc, 'n': first.n, 'p': first.p, 'k': first.k};

    for (var entry in _entries.skip(1)) {
      _minValues['ph'] = min(_minValues['ph']!, entry.ph);
      _maxValues['ph'] = max(_maxValues['ph']!, entry.ph);
      _minValues['ec'] = min(_minValues['ec']!, entry.ec);
      _maxValues['ec'] = max(_maxValues['ec']!, entry.ec);
      _minValues['oc'] = min(_minValues['oc']!, entry.oc);
      _maxValues['oc'] = max(_maxValues['oc']!, entry.oc);
      _minValues['n'] = min(_minValues['n']!, entry.n);
      _maxValues['n'] = max(_maxValues['n']!, entry.n);
      _minValues['p'] = min(_minValues['p']!, entry.p);
      _maxValues['p'] = max(_maxValues['p']!, entry.p);
      _minValues['k'] = min(_minValues['k']!, entry.k);
      _maxValues['k'] = max(_maxValues['k']!, entry.k);
    }
  }
}

// --- Main Recommendation Service ---

/// Provides methods to get crop recommendations based on the loaded soil data.
class CropRecommendationService {
  final SoilDatabase _db = SoilDatabase();

  /// Tier 1: Simple prediction based on region (Panchayat) and season.
  Future<List<CropRecommendationResult>> getSimpleRecommendation({
    required String panchayat,
    required Season season,
  }) async {
    await _db.initialize();
    await Future.delayed(const Duration(milliseconds: 300));

    var filteredEntries = _db.entries.where((e) => e.panchayat == panchayat).toList();

    if (season != Season.any) {
      filteredEntries = filteredEntries.where((e) {
        final remarks = e.cropRemarks.toLowerCase();
        switch (season) {
          case Season.kharif:
            return remarks.contains('kharif') || remarks.contains('june') || remarks.contains('july');
          case Season.rabi:
            return remarks.contains('rabi') || remarks.contains('oct') || remarks.contains('nov');
          case Season.zaid:
            return remarks.contains('zaid') || remarks.contains('march') || remarks.contains('april');
          default:
            return true;
        }
      }).toList();
    }
    
    if (filteredEntries.isEmpty) return [];

    final cropCounts = <String, int>{};
    for (var entry in filteredEntries) {
      cropCounts[entry.cropRecommendation] = (cropCounts[entry.cropRecommendation] ?? 0) + 1;
    }

    final sortedCrops = cropCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topCrops = sortedCrops.take(3).toList();

    return topCrops.map((cropEntry) {
      final representativeEntry = filteredEntries.firstWhere((e) => e.cropRecommendation == cropEntry.key);
      return CropRecommendationResult(cropName: representativeEntry.cropRecommendation, remarks: representativeEntry.cropRemarks);
    }).toList();
  }

  /// Tier 2: Detailed prediction using a weighted nearest neighbor algorithm.
  Future<CropRecommendationResult> getDetailedRecommendation({
    required double n,
    required double p,
    required double k,
    required double ph,
    required double ec,
    required double oc,
  }) async {
    await _db.initialize();
    await Future.delayed(const Duration(milliseconds: 500));

    double normalize(double value, String key) {
      final minVal = _db.minValues[key]!;
      final maxVal = _db.maxValues[key]!;
      if ((maxVal - minVal).abs() < 1e-6) return 0.5;
      return (value - minVal) / (maxVal - minVal);
    }
    
    final normalizedInput = {
      'n': normalize(n, 'n'), 'p': normalize(p, 'p'), 'k': normalize(k, 'k'),
      'ph': normalize(ph, 'ph'), 'ec': normalize(ec, 'ec'), 'oc': normalize(oc, 'oc'),
    };

    SoilDataEntry? nearestNeighbor;
    double minDistance = double.infinity;

    for (var entry in _db.entries) {
      // **FIXED TYPO HERE**
      final normalizedEntry = {
        'n': normalize(entry.n, 'n'), 'p': normalize(entry.p, 'p'), 'k': normalize(entry.k, 'k'),
        'ph': normalize(entry.ph, 'ph'), 'ec': normalize(entry.ec, 'ec'), 'oc': normalize(entry.oc, 'oc'),
      };

      double distance = 0;
      normalizedInput.forEach((key, value) {
        distance += pow(value - normalizedEntry[key]!, 2);
      });
      distance = sqrt(distance);

      if (distance < minDistance) {
        minDistance = distance;
        nearestNeighbor = entry;
      }
    }
    
    if (nearestNeighbor == null) {
      throw Exception('Could not find a suitable crop match. Please verify your input values.');
    }
    
    final confidence = max(0, 1.0 - (minDistance / sqrt(normalizedInput.length)));

    return CropRecommendationResult(
      cropName: nearestNeighbor.cropRecommendation,
      remarks: nearestNeighbor.cropRemarks,
      // **FIXED TYPE ERROR HERE**
      confidence: confidence.toDouble(),
    );
  }
}