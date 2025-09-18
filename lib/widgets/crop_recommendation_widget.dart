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
  // --- Services and Global State ---
  final CropRecommendationService _service = CropRecommendationService();
  final SoilDatabase _db = SoilDatabase();
  bool _isLoading = false;
  String _errorMessage = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isDbInitialized = false;

  // --- Tier 1 (Simple) State ---
  String? _selectedPanchayat;
  Season _selectedSeason = Season.any;
  List<CropRecommendationResult> _simpleRecommendations = [];

  // --- Tier 2 (Detailed) State ---
  final _formKey = GlobalKey<FormState>();
  final _nController = TextEditingController();
  final _pController = TextEditingController();
  final _kController = TextEditingController();
  final _phController = TextEditingController();
  final _ecController = TextEditingController();
  final _ocController = TextEditingController();
  CropRecommendationResult? _detailedRecommendation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      await _db.initialize();
      if (!mounted) return;
      setState(() {
        if (_db.uniquePanchayats.isNotEmpty) {
          _selectedPanchayat = _db.uniquePanchayats.first;
        }
        _isDbInitialized = true;
        _animationController.forward();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load database. Please restart the app.';
      });
    }
  }

  // --- Prediction Logic ---

  Future<void> _getSimpleRecommendation() async {
    if (_selectedPanchayat == null) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _simpleRecommendations = [];
    });
    try {
      final results = await _service.getSimpleRecommendation(
        panchayat: _selectedPanchayat!,
        season: _selectedSeason,
      );
      if (mounted) setState(() => _simpleRecommendations = results);
    } catch (e) {
      _handleError(e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _getDetailedRecommendation() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _detailedRecommendation = null;
    });

    try {
      final result = await _service.getDetailedRecommendation(
        n: double.parse(_nController.text),
        p: double.parse(_pController.text),
        k: double.parse(_kController.text),
        ph: double.parse(_phController.text),
        ec: double.parse(_ecController.text),
        oc: double.parse(_ocController.text),
      );
      if (mounted) setState(() => _detailedRecommendation = result);
    } catch (e) {
      _handleError(e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleError(Object e) {
    if (!mounted) return;
    setState(() {
      _errorMessage = 'Error getting recommendation: $e';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_errorMessage),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _resetForms() {
    setState(() {
      _simpleRecommendations = [];
      _detailedRecommendation = null;
      _nController.clear();
      _pController.clear();
      _kController.clear();
      _phController.clear();
      _ecController.clear();
      _ocController.clear();
      _animationController.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    _nController.dispose();
    _pController.dispose();
    _kController.dispose();
    _phController.dispose();
    _ecController.dispose();
    _ocController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // --- BUILD METHOD ---
  // The layout structure here is corrected to prevent crashes.

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff01342C), Color(0xff0a4a3e), Color(0xff147b5a)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          // This Column's size will be determined by its children.
          mainAxisSize: MainAxisSize.min, // Important for nested scrolling scenarios
          children: [
            _buildHeader(languageProvider),
            const TabBar(
              indicatorColor: Color(0xff4EBE44),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(icon: Icon(Icons.location_on_outlined), text: "Simple"),
                Tab(icon: Icon(Icons.science_outlined), text: "Detailed"),
              ],
            ),
            // **LAYOUT FIX HERE**
            // The TabBarView needs a defined height. We wrap it in a SizedBox
            // instead of Expanded to prevent layout errors when this widget is
            // placed in a vertically scrolling parent like a ListView.
            // The content inside the tabs is already scrollable.
            SizedBox(
              height: 600, // Adjust this height as needed for your UI
              child: !_isDbInitialized
                  ? _buildLoadingWidget("Initializing Database...")
                  : TabBarView(
                      children: [
                        _buildSimpleTab(languageProvider),
                        _buildDetailedTab(languageProvider),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSimpleTab(LanguageProvider languageProvider) {
    bool hasRecommendation = _simpleRecommendations.isNotEmpty;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: _isLoading
          ? _buildLoadingWidget("Finding best crops...")
          : hasRecommendation
              ? _buildSimpleResult(languageProvider)
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildSimpleInput(languageProvider),
                ),
    );
  }

  Widget _buildDetailedTab(LanguageProvider languageProvider) {
    bool hasRecommendation = _detailedRecommendation != null;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: _isLoading
          ? _buildLoadingWidget("Analyzing soil data...")
          : hasRecommendation
              ? _buildDetailedResult(languageProvider)
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildDetailedInput(languageProvider),
                ),
    );
  }

  // --- UI Components ---

  Widget _buildHeader(LanguageProvider languageProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(26),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xff4EBE44),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.agriculture, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageProvider.translate('crop_recommendation_tool'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
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
    );
  }

  Widget _buildLoadingWidget(String message) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xff4EBE44)),
            const SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(color: Colors.white.withAlpha(204), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleInput(LanguageProvider languageProvider) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedPanchayat,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xff01342C)),
              style: const TextStyle(
                color: Color(0xff01342C), 
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
              items: _db.uniquePanchayats.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) => setState(() => _selectedPanchayat = newValue),
              hint: const Text('Select Region', style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              )),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Season>(
              value: _selectedSeason,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xff01342C)),
              style: const TextStyle(
                color: Color(0xff01342C), 
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
              items: Season.values.map((Season season) {
                return DropdownMenuItem<Season>(
                  value: season,
                  child: Text(season.toString().split('.').last.capitalize()),
                );
              }).toList(),
              onChanged: (newValue) => setState(() => _selectedSeason = newValue!),
              hint: const Text('Select Season', style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              )),
            ),
          ),
        ),
        const SizedBox(height: 32),
        _buildPredictButton(_getSimpleRecommendation, languageProvider),
      ],
    );
  }

  Widget _buildDetailedInput(LanguageProvider languageProvider) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField('Nitrogen (N)', _nController, 'kg/ha', Icons.science, languageProvider),
          const SizedBox(height: 16),
          _buildTextField('Phosphorus (P)', _pController, 'kg/ha', Icons.science, languageProvider),
          const SizedBox(height: 16),
          _buildTextField('Potassium (K)', _kController, 'kg/ha', Icons.science, languageProvider),
          const SizedBox(height: 16),
          _buildTextField('pH Value', _phController, '', Icons.analytics, languageProvider),
          const SizedBox(height: 16),
          _buildTextField('EC (Conductivity)', _ecController, 'dS/m', Icons.flash_on, languageProvider),
          const SizedBox(height: 16),
          _buildTextField('Organic Carbon (OC)', _ocController, '%', Icons.eco, languageProvider),
          const SizedBox(height: 32),
          _buildPredictButton(_getDetailedRecommendation, languageProvider),
        ],
      ),
    );
  }

  Widget _buildSimpleResult(LanguageProvider languageProvider) {
    return Column(
      children: [
        if (_simpleRecommendations.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                "No recommendations found for this region/season.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ),
        ..._simpleRecommendations.map((rec) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.agriculture, color: Color(0xFF147b2c)),
                title: Text(rec.cropName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(rec.remarks),
                isThreeLine: true,
              ),
            )),
        const SizedBox(height: 24),
        _buildNewPredictionButton(),
      ],
    );
  }

  Widget _buildDetailedResult(LanguageProvider languageProvider) {
    if (_detailedRecommendation == null) return const SizedBox.shrink();
    return _buildResultCard(
      cropName: _detailedRecommendation!.cropName,
      remarks: _detailedRecommendation!.remarks,
      confidence: _detailedRecommendation!.confidence,
    );
  }

  Widget _buildResultCard({required String cropName, required String remarks, double? confidence}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Best Match Recommendation', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              cropName.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF147b2c),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (confidence != null) ...[
              const SizedBox(height: 8),
              Chip(
                avatar: const Icon(Icons.verified, size: 16, color: Colors.black54),
                label: Text('Match Confidence: ${(confidence * 100).toStringAsFixed(1)}%'),
                backgroundColor: Colors.green.shade100,
              ),
            ],
            const Divider(height: 32),
            Text('Cultivation Remarks:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(remarks, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            _buildNewPredictionButton(),
          ],
        ),
      ),
    );
  }
  
  // --- Common UI Components ---

  Widget _buildNewPredictionButton() {
    return ElevatedButton.icon(
      onPressed: _resetForms,
      icon: const Icon(Icons.refresh),
      label: const Text('New Prediction'),
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color(0xff147b5a),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  Widget _buildPredictButton(VoidCallback onPressed, LanguageProvider languageProvider) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xff4EBE44), Color(0xff66d455)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.psychology, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(
                  languageProvider.translate('get_recommendation'),
                  style: const TextStyle(
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
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String suffix, IconData icon, LanguageProvider languageProvider) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      cursorColor: const Color(0xff4EBE44),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withAlpha(204), fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.white.withAlpha(179), size: 18),
        suffixText: suffix,
        suffixStyle: TextStyle(color: Colors.white.withAlpha(179), fontSize: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withAlpha(79)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff4EBE44)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent.shade100),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent.shade200, width: 2),
        ),
        errorStyle: TextStyle(color: Colors.redAccent.shade100),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        if (double.tryParse(value) == null) return 'Invalid number';
        return null;
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}