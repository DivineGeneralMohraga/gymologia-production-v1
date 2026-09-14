# R8 rules for the release build.
#
# Tink is Google's crypto library, pulled in by flutter_secure_storage to
# back EncryptedSharedPreferences -- which is where this app keeps its
# session tokens. Tink's classes carry compile-time-only annotations from
# errorprone and javax, and those annotation JARs are deliberately not on
# the runtime classpath. R8 sees the references, cannot resolve them, and
# fails the whole build.
#
# `-dontwarn` is the right answer rather than a workaround: these exist only
# to inform a compiler. Nothing reads them at runtime, so a class that
# cannot resolve one still works. The alternative -- adding errorprone as a
# dependency -- ships a JAR to every phone so R8 can read six annotations at
# build time and then throw them away.
#
# These lines are what the Android Gradle plugin generated in
# build/app/outputs/mapping/release/missing_rules.txt, not a guess.
-dontwarn com.google.errorprone.annotations.CanIgnoreReturnValue
-dontwarn com.google.errorprone.annotations.CheckReturnValue
-dontwarn com.google.errorprone.annotations.Immutable
-dontwarn com.google.errorprone.annotations.InlineMe
-dontwarn com.google.errorprone.annotations.RestrictedApi
-dontwarn javax.annotation.Nullable
-dontwarn javax.annotation.concurrent.GuardedBy
-dontwarn javax.annotation.concurrent.ThreadSafe

# NO blanket `-keep class com.google.crypto.tink.** { *; }`.
#
# The first version of this file had one, and it made things strictly
# worse. Keeping all of Tink forces R8 to retain `KeysDownloader` -- a class
# for fetching remote keysets that this app never touches -- and that class
# references Google's API HTTP client and Joda-Time, neither of which is in
# the app. So the blanket keep turned six unresolved annotations into
# eleven unresolved real classes.
#
# Left to itself R8 strips KeysDownloader as unreachable, and what
# EncryptedSharedPreferences actually calls is reachable from the app, so it
# survives on its own merits. Reachability is what a shrinker is for;
# overriding it by hand is how you end up shipping code nothing calls.
