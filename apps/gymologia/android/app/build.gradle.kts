import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Signing material lives in android/key.properties, which is gitignored
// along with the keystore itself. Neither is in the repository and neither
// should ever be.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile.exists()) {
        FileInputStream(keystorePropertiesFile).use { load(it) }
    }
}
val hasReleaseKeystore = keystorePropertiesFile.exists()

android {
    namespace = "com.gandagrouptechnologies.gymologia.member"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.gandagrouptechnologies.gymologia.member"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            // This used to read `signingConfigs.getByName("debug")`, which is
            // Flutter's generated default. It is the worst kind of wrong: the
            // build succeeds, produces an .aab that installs and runs, and is
            // rejected at upload because Play will not accept the debug key --
            // and a debug key is a published, shared secret, so an artifact
            // signed with it is not a release artifact in any meaningful sense.
            //
            // A missing keystore now FAILS the release build rather than
            // quietly falling back. Anyone can produce a debug build on
            // purpose; nobody wants one by accident with "release" in its name.
            if (!hasReleaseKeystore) {
                throw GradleException(
                    "No android/key.properties -- refusing to build a release " +
                        "signed with debug keys. Play rejects those, and a debug " +
                        "key is a shared public secret. Create key.properties with " +
                        "storePassword / keyPassword / keyAlias / storeFile, or " +
                        "build a debug variant instead.",
                )
            }
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
