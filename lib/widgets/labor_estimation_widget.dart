import 'package:agro/Providers/language_provider.dart';
import 'package:agro/services/labor_estimation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LaborEstimationWidget extends StatefulWidget {
  const LaborEstimationWidget({super.key});

  @override
  _LaborEstimationWidgetState createState() => _LaborEstimationWidgetState();
}

class _LaborEstimationWidgetState extends State<LaborEstimationWidget> {
  final LaborEstimationService _estimationService = LaborEstimationService();

  String _selectedCrop = 'Tomato';
  String _selectedCropType = 'Vegetable';
  double _area = 1.0;
  String _selectedSeason = 'Summer';
  String _selectedWageType = 'Govt';
  final double _govtWage = 350.0;
  final double _expectedWage = 450.0;

  Map<String, dynamic>? _estimationResult;
  bool _isLoading = false;

  final List<String> _cropOptions = [
    'Tomato',
    'Potato',
    'Onion',
    'Wheat',
    'Rice',
    'Corn',
    'Chickpea',
    'Apple',
    'Banana'
  ];
  final List<String> _seasonOptions = ['Spring', 'Summer', 'Fall', 'Winter'];
  final List<String> _wageTypeOptions = ['Govt', 'Expected'];

  @override
  void initState() {
    super.initState();
    _loadModels();
  }

  Future<void> _loadModels() async {
    await _estimationService.loadModels();
  }

  Future<void> _calculateEstimation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _estimationService.estimateCost(
          _selectedCrop,
          _selectedCropType,
          _area,
          _selectedWageType,
          _selectedSeason,
          _govtWage,
          _expectedWage);

      setState(() {
        _estimationResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error calculating estimation: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Crop selection
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: languageProvider.translate('crop'),
              border: OutlineInputBorder(),
            ),
            value: _selectedCrop,
            items: _cropOptions.map((String crop) {
              return DropdownMenuItem<String>(
                value: crop,
                child: Text(crop),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedCrop = newValue;
                  _selectedCropType =
                      _estimationService.getCropTypeForCrop(newValue);
                });
              }
            },
          ),
          SizedBox(height: 12),

          // Area input
          TextFormField(
            decoration: InputDecoration(
              labelText: languageProvider.translate('area_in_hectares'),
              border: OutlineInputBorder(),
              suffixText: 'ha',
            ),
            keyboardType: TextInputType.number,
            initialValue: _area.toString(),
            onChanged: (value) {
              setState(() {
                _area = double.tryParse(value) ?? 1.0;
              });
            },
          ),
          SizedBox(height: 12),

          // Season selection
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: languageProvider.translate('season'),
              border: OutlineInputBorder(),
            ),
            value: _selectedSeason,
            items: _seasonOptions.map((String season) {
              return DropdownMenuItem<String>(
                value: season,
                child: Text(season),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedSeason = newValue;
                });
              }
            },
          ),
          SizedBox(height: 12),

          // Wage type selection
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: languageProvider.translate('wage_type'),
              border: OutlineInputBorder(),
            ),
            value: _selectedWageType,
            items: _wageTypeOptions.map((String wageType) {
              return DropdownMenuItem<String>(
                value: wageType,
                child: Text(wageType),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedWageType = newValue;
                });
              }
            },
          ),
          SizedBox(height: 20),

          // Calculate button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _calculateEstimation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF147b2c),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      languageProvider.translate('calculate_labor_cost'),
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ),
          SizedBox(height: 16),

          // Results section
          if (_estimationResult != null)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageProvider.translate('estimation_results'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildResultRow(
                    languageProvider.translate('crop'),
                    _estimationResult!['crop'].toString(),
                  ),
                  _buildResultRow(
                    languageProvider.translate('area'),
                    '${_estimationResult!['area']} ha',
                  ),
                  _buildResultRow(
                    languageProvider.translate('season'),
                    _estimationResult!['season'].toString(),
                  ),
                  _buildResultRow(
                    languageProvider.translate('labor_required'),
                    '${_estimationResult!['labor_demand']} ${languageProvider.translate('workers')}',
                  ),
                  _buildResultRow(
                    languageProvider.translate('cost_per_hectare'),
                    '₹${_estimationResult!['cost_per_ha']}',
                  ),
                  _buildResultRow(
                    languageProvider.translate('total_cost'),
                    '₹${_estimationResult!['total_cost']}',
                    isTotal: true,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _estimationService.dispose();
    super.dispose();
  }
}
