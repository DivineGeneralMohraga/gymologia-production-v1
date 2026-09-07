import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Signing material lives in android/key.properties, which is gitignored
// along with the keystore itself. Neither is in the repository and neither
// should ever be.
//
// THE KEYSTORE ALREADY EXISTS. DO NOT GENERATE A NEW ONE.
//
//   C:\projects\gymologia-keystore\gymologia-release.jks
//
// It holds one alias per app -- gymologia-member, gymologia-staff,
// gymologia-admin, gymologia-referral -- and THIS app signs with
// `gymologia-referral`. That alias is already reserved for it.
//
// The member app learned this the expensive way: nothing in the repository
// recorded where the keystore was, so a fresh one was generated and the
// bundle it signed was rejected at upload with "signed with the wrong
// key". Play pins the certificate on first upload and every later build
// must match it forever. This app has not been uploaded yet, so its
// certificate is not pinned — which makes right now the only cheap moment
// to get it right, and the reason this file says so before there is a
// listing to break.
//
// The store password also serves as the key password. The credentials file
// beside the keystore describes that in prose rather than giving a value,
// which is worth knowing before trying to parse it.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile.exists()) {
        FileInputStream(keystorePropertiesFile).use { load(it) }
    }
}
val hasReleaseKeystore = keystorePropertiesFile.exists()

android {
    namespace = "com.gandagrouptechnologies.gymologia.referral"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.gandagrouptechnologies.gymologia.referral"
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
            // Flutter's generated default here is
            // `signingConfigs.getByName("debug")`, which is the worst kind of
            // wrong: the build succeeds, produces an .aab that installs and
            // runs, and is rejected at upload because Play will not accept the
            // debug key -- and a debug key is a published, shared secret, so an
            // artifact signed with it is not a release artifact in any
            // meaningful sense.
            //
            // Left unset when there is no keystore, so merely configuring this
            // build type cannot fail. The refusal below fires when a release is
            // actually asked for. Anyone can produce a debug build on purpose;
            // nobody wants one by accident with "release" in its name.
            if (hasReleaseKeystore) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

// Refuse a release build with no keystore -- at the moment one is asked
// for, not while Gradle is merely configuring the project.
//
// The first version of this guard threw at configuration time, which
// happens on every build, so `flutter run` and `flutter build apk --debug`
// both died on a message about release signing that ended "or build a
// debug variant instead" while refusing exactly that. Configuration runs
// for all variants; only the task graph knows which one you asked for.
if (!hasReleaseKeystore) {
    gradle.taskGraph.whenReady {
        val releaseTask = allTasks.firstOrNull {
            it.project == project &&
                it.name.contains("Release") &&
                (it.name.startsWith("assemble") ||
                    it.name.startsWith("bundle") ||
                    it.name.startsWith("package"))
        }
        if (releaseTask != null) {
            throw GradleException(
                "No android/key.properties -- refusing to build a release " +
                    "signed with debug keys. Play rejects those, and a debug key " +
                    "is a shared public secret. Create key.properties with " +
                    "storePassword / keyPassword / keyAlias / storeFile " +
                    "(keyAlias gymologia-referral), or build a debug variant " +
                    "instead.",
            )
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
