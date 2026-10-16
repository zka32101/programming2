import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
val hasReleaseSigning = keystorePropertiesFile.exists()
if (hasReleaseSigning) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.yourwish.shougakukore.eigo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // flutter_local_notifications に必要
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.yourwish.shougakukore.eigo"
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                // Play 提出用の AAB を、release 署名なし(debug 署名)で作ってしまう事故を防ぐ。
                // CI(CI=true)で bundle 系タスクを実行し、key.properties が無ければビルドを失敗させる。
                // APK の動作確認や、手元の `flutter run --release` は、従来どおり debug 署名で通る。
                val wantsBundle = gradle.startParameter.taskNames.any { it.contains("bundle", ignoreCase = true) }
                if (System.getenv("CI") == "true" && wantsBundle) {
                    throw GradleException(
                        "release 署名(android/key.properties)がありません。debug 署名の AAB を作らないよう、ビルドを中止します。"
                    )
                }
                signingConfigs.getByName("debug")
            }
        }
    }
}

dependencies {
    // flutter_local_notifications の desugaring 対応
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
