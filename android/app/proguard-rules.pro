# =========================================================
# ATURAN DASAR FLUTTER WRAPPER
# =========================================================
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep custom model classes for your actual package
-keep class com.reta.unair.ticketing_helpdesk.models.** { *; }
-keep class com.reta.unair.ticketing_helpdesk.** { *; }

# =========================================================
# ATURAN GSON & SYSTEM (Meredam Bug Visual Linter Android Studio)
# =========================================================
-dontwarn sun.misc.Unsafe
-dontwarn com.google.gson.annotations.SerializedName

-keepattributes Signature
-keepattributes *Annotation*
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.stream.** { *; }
-keep class com.google.gson.** { *; }

# Keep R8 compatibility
-keepclassmembers,allowobfuscation class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# =========================================================
# TAMBAHAN MANDIRI (Penyelamat Error R8 Sebelumnya)
# =========================================================
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.gms.internal.**