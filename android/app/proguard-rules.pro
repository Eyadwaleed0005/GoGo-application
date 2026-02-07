# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Mapbox
-keep class com.mapbox.** { *; }
-dontwarn com.mapbox.**

# Dio (retrofit/okhttp)
-keepattributes Signature
-keepattributes *Annotation*
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**
-keep class okio.** { *; }
-dontwarn okio.**

# Geolocator
-keep class com.baseflow.geolocator.** { *; }
-dontwarn com.baseflow.geolocator.**

# Gson / JSON serialization
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Prevent stripping annotations
-keepattributes RuntimeVisibleAnnotations
-keepattributes RuntimeVisibleParameterAnnotations
-keepattributes RuntimeVisibleTypeAnnotations

# Flutter Secure Storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-dontwarn com.it_nomads.fluttersecurestorage.**

# AndroidX Security Crypto (مطلوبة لـ flutter_secure_storage)
-keep class androidx.security.crypto.** { *; }
-dontwarn androidx.security.crypto.**
