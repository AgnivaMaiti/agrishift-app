import 'package:agro/providers/language_provider.dart';
import 'package:agro/services/crop_recommendation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CropRecommendationWidget extends StatefulWidget {
  const CropRecommendationWidget({super.key});

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage)));
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
      color: Color(0xff01342C),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageProvider.translate('crop_recommendation_tool'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            if (_isLoading)
              Center(child: CircularProgressIndicator(color: Color(0xff4EBE44)))
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
    final double h = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(10),
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
          SizedBox(height: h * 0.04),
          Text(_errorMessage),
          SizedBox(height: h * 0.08),
          ElevatedButton(onPressed: _initializeService, child: Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildInputForm(LanguageProvider languageProvider) {
    final double h = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            languageProvider.translate('enter_soil_climate_data'),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: h * 0.02),
          buildTextField(
            '${languageProvider.translate('nitrogen')} (N)',
            _nitrogenController,
            TextInputType.number,
            languageProvider,
            'kg/ha',
            (value) {
              if (value == null || value.isEmpty) {
                return languageProvider.translate('required_field');
              }
              return null;
            },
          ),
          SizedBox(height: h * 0.015),

          buildTextField(
            '${languageProvider.translate('phosphorus')} (P)',
            _phosphorusController,
            TextInputType.number,
            languageProvider,
            'kg/ha',
            (value) {
              if (value == null || value.isEmpty) {
                return languageProvider.translate('required_field');
              }
              return null;
            },
          ),
          SizedBox(height: h * 0.015),
          buildTextField(
            "${languageProvider.translate('potassium')} (K)",
            _potassiumController,
            TextInputType.number,
            languageProvider,
            'kg/ha',
            (value) {
              if (value == null || value.isEmpty) {
                return languageProvider.translate('required_field');
              }
              return null;
            },
          ),
          SizedBox(height: h * 0.015),
          buildTextField(
            languageProvider.translate('temperature'),
            _temperatureController,
            TextInputType.number,
            languageProvider,
            '°C',
            (value) {
              if (value == null || value.isEmpty) {
                return languageProvider.translate('required_field');
              }
              return null;
            },
          ),
          SizedBox(height: h * 0.015),
          buildTextField(
            languageProvider.translate('humidity'),
            _humidityController,
            TextInputType.number,
            languageProvider,
            '%',
            (value) {
              if (value == null || value.isEmpty) {
                return languageProvider.translate('required_field');
              }
              return null;
            },
          ),
          SizedBox(height: h * 0.015),
          buildTextField(
            languageProvider.translate('ph_value'),
            _phController,
            TextInputType.number,
            languageProvider,
            '',
            (value) {
              if (value == null || value.isEmpty) {
                return languageProvider.translate('required_field');
              }
              return null;
            },
          ),
          SizedBox(height: h * 0.015),
          buildTextField(
            languageProvider.translate('rainfall'),
            _rainfallController,
            TextInputType.number,
            languageProvider,
            "mm",
            (value) {
              if (value == null || value.isEmpty) {
                return languageProvider.translate('required_field');
              }
              return null;
            },
          ),

          SizedBox(height: h * 0.02),
          InkWell(
            onTap: _predictCrop,
            child: Container(
              height: h * 0.07,
              decoration: BoxDecoration(
                color: Color(0xff4EBE44),
                borderRadius: BorderRadius.circular(h * 0.035),
              ),
              child: Center(
                child: Text(
                  languageProvider.translate('get_recommendation'),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller,
    TextInputType type,
    LanguageProvider languageProvider,
    String? suffixText,
    String? Function(String?)? validator,
  ) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        suffixText: suffixText,
        suffixStyle: TextStyle(color: Colors.white),
      ),
      validator: validator,
    );
  }

  Widget _buildRecommendationResult(LanguageProvider languageProvider) {
    final double h = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${languageProvider.translate('recommended_crop')} :',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        SizedBox(height: h * 0.02),
        Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFFFF8F0),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFF147b2c)),
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
        SizedBox(height: h * 0.02),
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
