import 'package:flutter/material.dart';
import 'package:agri/services/crop_recommendation_service.dart';
import 'package:agri/Providers/language_provider.dart';
import 'package:provider/provider.dart';

class CropRecommendationWidget extends StatefulWidget {
  const CropRecommendationWidget({Key? key}) : super(key: key);

  @override
  State<CropRecommendationWidget> createState() =>
      _CropRecommendationWidgetState();
}

class _CropRecommendationWidgetState extends State<CropRecommendationWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nitrogenController = TextEditingController();
  final _phosphorusController = TextEditingController();
  final _potassiumController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _humidityController = TextEditingController();
  final _phController = TextEditingController();
  final _rainfallController = TextEditingController();

  final CropRecommendationService _service = CropRecommendationService();
  String _recommendedCrop = '';
  bool _isLoading = false;
  bool _hasRecommendation = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _service.loadModel();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading model: $e';
      });
    }
  }

  Future<void> _predictCrop() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final nitrogen = double.parse(_nitrogenController.text);
      final phosphorus = double.parse(_phosphorusController.text);
      final potassium = double.parse(_potassiumController.text);
      final temperature = double.parse(_temperatureController.text);
      final humidity = double.parse(_humidityController.text);
      final ph = double.parse(_phController.text);
      final rainfall = double.parse(_rainfallController.text);

      final cropName = await _service.predictCrop(
        nitrogen: nitrogen,
        phosphorus: phosphorus,
        potassium: potassium,
        temperature: temperature,
        humidity: humidity,
        ph: ph,
        rainfall: rainfall,
      );

      setState(() {
        _recommendedCrop = cropName;
        _hasRecommendation = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error predicting crop: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$_errorMessage')),
      );
    }
  }

  @override
  void dispose() {
    _nitrogenController.dispose();
    _phosphorusController.dispose();
    _potassiumController.dispose();
    _temperatureController.dispose();
    _humidityController.dispose();
    _phController.dispose();
    _rainfallController.dispose();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageProvider.translate('crop_recommendation_tool'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_errorMessage.isNotEmpty)
              _buildErrorWidget()
            else if (_hasRecommendation)
              _buildRecommendationResult(languageProvider)
            else
              _buildInputForm(languageProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Error Loading Model',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          SizedBox(height: 8),
          Text(_errorMessage),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _initializeService,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildInputForm(LanguageProvider languageProvider) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(languageProvider.translate('enter_soil_climate_data')),
          SizedBox(height: 16),

          // Nitrogen input
          TextFormField(
            controller: _nitrogenController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: languageProvider.translate('nitrogen') + ' (N)',
              border: OutlineInputBorder(),
              suffixText: 'kg/ha',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return languageProvider.translate('required_field');
              }
              return null;
            },
          ),
          SizedBox(height: 8),

          // Phosphorus input
          TextFormField(
            controller: _phosphorusController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: languageProvider.translate('phosphorus') + ' (P)',
              border: OutlineInputBorder(),
              suffixText: 'kg/ha',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return languageProvider.translate('required_field');
              }
              return null;
            },
          ),
          SizedBox(height: 8),

          // Potassium input
          TextFormField(
            controller: _potassiumController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: languageProvider.translate('potassium') + ' (K)',
              border: OutlineInputBorder(),
              suffixText: 'kg/ha',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return languageProvider.translate('required_field');
              }
              return null;
            },
          ),
          SizedBox(height: 8),

          // Temperature input
          TextFormField(
            controller: _temperatureController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: languageProvider.translate('temperature'),
              border: OutlineInputBorder(),
              suffixText: '°C',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return languageProvider.translate('required_field');
              }
              return null;
            },
          ),
          SizedBox(height: 8),

          // Humidity input
          TextFormField(
            controller: _humidityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: languageProvider.translate('humidity'),
              border: OutlineInputBorder(),
              suffixText: '%',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return languageProvider.translate('required_field');
              }
              return null;
            },
          ),
          SizedBox(height: 8),

          // pH input
          TextFormField(
            controller: _phController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: languageProvider.translate('ph_value'),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return languageProvider.translate('required_field');
              }
              return null;
            },
          ),
          SizedBox(height: 8),

          // Rainfall input
          TextFormField(
            controller: _rainfallController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: languageProvider.translate('rainfall'),
              border: OutlineInputBorder(),
              suffixText: 'mm',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return languageProvider.translate('required_field');
              }
              return null;
            },
          ),
          SizedBox(height: 16),

          ElevatedButton(
            onPressed: _predictCrop,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF147b2c),
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text(
              languageProvider.translate('get_recommendation'),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationResult(LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageProvider.translate('recommended_crop') + ':',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFF147b2c).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFF147b2c).withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _recommendedCrop.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF147b2c),
                ),
              ),
              SizedBox(height: 8),
              Text(
                languageProvider.translate('recommendation_note'),
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _hasRecommendation = false;
              _nitrogenController.clear();
              _phosphorusController.clear();
              _potassiumController.clear();
              _temperatureController.clear();
              _humidityController.clear();
              _phController.clear();
              _rainfallController.clear();
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text(
            languageProvider.translate('start_new_prediction'),
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
