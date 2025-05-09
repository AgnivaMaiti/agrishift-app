import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class CropRecommendationService {
  static final CropRecommendationService _instance =
      CropRecommendationService._internal();

  factory CropRecommendationService() => _instance;

  CropRecommendationService._internal();

  Interpreter? _interpreter;
  bool _modelLoaded = false;

  // Keep the mapping from model output indices to crop names
  final List<String> _cropLabels = [
    'apple',
    'banana',
    'blackgram',
    'chickpea',
    'coconut',
    'coffee',
    'cotton',
    'grapes',
    'jute',
    'kidneybeans',
    'lentil',
    'maize',
    'mango',
    'mothbeans',
    'mungbean',
    'muskmelon',
    'orange',
    'papaya',
    'pigeonpeas',
    'pomegranate',
    'rice',
    'watermelon'
  ];

  // Load the model from assets
  Future<void> loadModel() async {
    if (_modelLoaded) return;

    try {
      // Copy model from assets to a temporary file
      final appDir = await getTemporaryDirectory();
      final modelFile = File('${appDir.path}/crop_model.tflite');

      if (!await modelFile.exists()) {
        final modelBytes =
            await rootBundle.load('assets/models/crop_model.tflite');
        await modelFile.writeAsBytes(modelBytes.buffer
            .asUint8List(modelBytes.offsetInBytes, modelBytes.lengthInBytes));
      }

      // Load the model
      _interpreter = Interpreter.fromFile(modelFile);
      _modelLoaded = true;
      print('TFLite model loaded successfully');
    } catch (e) {
      print('Error loading model: $e');
      _modelLoaded = false;
      rethrow; // Rethrow so we can see the actual error
    }
  }

  // Normalize input using the same scaling as in the Python code
  List<double> _normalizeInput(List<double> input) {
    // These values should match your StandardScaler values from the Python code
    // Ideally, you would save these values during training and load them here
    // For simplicity, we'll hardcode mean and std values for each feature
    final means = [50.55, 53.36, 48.15, 25.62, 71.48, 6.47, 104.91];
    final stds = [36.92, 32.27, 49.58, 5.06, 22.26, 0.77, 50.65];

    List<double> normalizedInput = [];
    for (int i = 0; i < input.length; i++) {
      normalizedInput.add((input[i] - means[i]) / stds[i]);
    }
    return normalizedInput;
  }

  // Predict crop based on soil and climate features
  Future<String> predictCrop({
    required double nitrogen,
    required double phosphorus,
    required double potassium,
    required double temperature,
    required double humidity,
    required double ph,
    required double rainfall,
  }) async {
    // Ensure model is loaded before prediction
    if (!_modelLoaded || _interpreter == null) {
      await loadModel();
      // Double-check after loading
      if (_interpreter == null) {
        throw Exception('Failed to initialize TFLite interpreter');
      }
    }

    // Create input data
    final input = [
      nitrogen,
      phosphorus,
      potassium,
      temperature,
      humidity,
      ph,
      rainfall
    ];
    final normalizedInput = _normalizeInput(input);

    try {
      // Reshape the input to match the model's expected shape [1, 7]
      var inputArray = [normalizedInput];

      // Prepare output tensor
      var outputShape = _interpreter!.getOutputTensor(0).shape;
      // var outputType = _interpreter!.getOutputTensor(0).type;

      // Create output buffer
      var outputBuffer = List.filled(outputShape.reduce((a, b) => a * b), 0.0)
          .reshape(outputShape);

      // Run inference
      _interpreter!.run(inputArray, outputBuffer);

      // Get the index of the highest probability
      int maxIndex = 0;
      double maxValue = outputBuffer[0][0];

      for (int i = 0; i < outputBuffer[0].length; i++) {
        if (outputBuffer[0][i] > maxValue) {
          maxValue = outputBuffer[0][i];
          maxIndex = i;
        }
      }

      // Map the index to crop name
      // Make sure the index is within bounds
      if (maxIndex >= 0 && maxIndex < _cropLabels.length) {
        return _cropLabels[maxIndex];
      } else {
        return "Unknown crop";
      }
    } catch (e) {
      print('Error during prediction: $e');
      throw Exception('Error during prediction: $e');
    }
  }

  void dispose() {
    if (_modelLoaded && _interpreter != null) {
      _interpreter!.close();
      _modelLoaded = false;
      _interpreter = null;
    }
  }
}
