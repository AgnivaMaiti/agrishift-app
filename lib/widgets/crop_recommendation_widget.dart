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

class _CropRecommendationWidgetState extends State<CropRecommendationWidget>
    with TickerProviderStateMixin {
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
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
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
      _animationController.forward();
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text(_errorMessage)),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
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
    _animationController.dispose();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff01342C), Color(0xff0a4a3e), Color(0xff147b5a)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(26),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xff4EBE44),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff4EBE44).withAlpha(79),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(Icons.agriculture, color: Colors.white, size: 24),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        languageProvider.translate('crop_recommendation_tool'),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'AI-powered crop selection',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withAlpha(204),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Padding(
            padding: EdgeInsets.all(20),
            child:
                _isLoading
                    ? _buildLoadingWidget()
                    : _errorMessage.isNotEmpty
                    ? _buildErrorWidget()
                    : _hasRecommendation
                    ? _buildRecommendationResult(languageProvider)
                    : FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildInputForm(languageProvider),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    color: Color(0xff4EBE44),
                    strokeWidth: 4,
                  ),
                ),
                Icon(Icons.eco, color: Color(0xff4EBE44), size: 28),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Analyzing soil conditions...',
              style: TextStyle(
                color: Colors.white.withAlpha(204),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[200]!, width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red[600], size: 48),
          SizedBox(height: 16),
          Text(
            'Model Loading Failed',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red[600], fontSize: 14),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _initializeService,
            icon: Icon(Icons.refresh, size: 18),
            label: Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputForm(LanguageProvider languageProvider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withAlpha(51)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.white.withAlpha(204),
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    languageProvider.translate('enter_soil_climate_data'),
                    style: TextStyle(
                      color: Colors.white.withAlpha(230),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Soil Nutrients Section
          _buildSectionHeader('Soil Nutrients', Icons.scatter_plot),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'Nitrogen (N)',
                  _nitrogenController,
                  'kg/ha',
                  Icons.science,
                  languageProvider,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  'Phosphorus (P)',
                  _phosphorusController,
                  'kg/ha',
                  Icons.science,
                  languageProvider,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'Potassium (K)',
                  _potassiumController,
                  'kg/ha',
                  Icons.science,
                  languageProvider,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  'pH Value',
                  _phController,
                  '',
                  Icons.analytics,
                  languageProvider,
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Climate Conditions Section
          _buildSectionHeader('Climate Conditions', Icons.wb_sunny),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'Temperature',
                  _temperatureController,
                  '°C',
                  Icons.thermostat,
                  languageProvider,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  'Humidity',
                  _humidityController,
                  '%',
                  Icons.water_drop,
                  languageProvider,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildTextField(
            'Rainfall',
            _rainfallController,
            'mm',
            Icons.cloud_queue,
            languageProvider,
          ),

          SizedBox(height: 32),

          // Predict Button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff4EBE44), Color(0xff66d455)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff4EBE44).withAlpha(102),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _predictCrop,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.psychology, color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Text(
                        languageProvider.translate('get_recommendation'),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Color(0xff4EBE44), size: 20),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            margin: EdgeInsets.only(left: 12),
            color: Colors.white.withAlpha(79),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String suffix,
    IconData icon,
    LanguageProvider languageProvider,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(79)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(color: Colors.white, fontSize: 14),
        cursorColor: Color(0xff4EBE44),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white.withAlpha(204),
            fontSize: 13,
          ),
          prefixIcon: Icon(icon, color: Colors.white.withAlpha(179), size: 18),
          suffixText: suffix,
          suffixStyle: TextStyle(
            color: Colors.white.withAlpha(179),
            fontSize: 12,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required';
          }
          if (double.tryParse(value) == null) {
            return 'Invalid number';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildRecommendationResult(LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Success Header
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.check_circle, color: Colors.white, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Recommendation Ready!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 20),

        // Recommended Crop Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFFFF8F0)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFF147b2c), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.agriculture, color: Color(0xFF147b2c), size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Recommended Crop',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                _recommendedCrop.toUpperCase(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF147b2c),
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF147b2c).withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFF147b2c),
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        languageProvider.translate('recommendation_note'),
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 13,
                          color: Color(0xFF147b2c),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 24),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
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
                icon: Icon(Icons.refresh, size: 18),
                label: Text('New Prediction'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF147b2c),
                  side: BorderSide(color: Color(0xFF147b2c)),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
