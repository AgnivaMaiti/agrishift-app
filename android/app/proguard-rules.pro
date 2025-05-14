# Keep TensorFlow Lite classes
-keep class org.tensorflow.lite.** { *; }
-keep interface org.tensorflow.lite.** { *; }

# Keep TensorFlow Lite GPU delegate classes
-keep class org.tensorflow.lite.gpu.** { *; }
-keep interface org.tensorflow.lite.gpu.** { *; }

# Specific keep rules for the problematic classes
-keep class org.tensorflow.lite.gpu.GpuDelegate { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegate$Options { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep methods called from native code
-keepclasseswithmembers class * {
    @org.tensorflow.lite.annotations.UsedByReflection *;
}

# Keep metadata
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable

# General keep rules for commonly used libraries
-keep class androidx.core.app.CoreComponentFactory { *; }

# Don't warn about missing classes from Android APIs for different platform versions
-dontwarn org.tensorflow.lite.gpu.**
-dontwarn org.tensorflow.lite.**