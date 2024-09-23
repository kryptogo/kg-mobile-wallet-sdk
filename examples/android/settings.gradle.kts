pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        maven(url = "https://storage.googleapis.com/download.flutter.io")
        maven(url="../../sdk/android/repo")
        maven(url="https://developer.huawei.com/repo/")}
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        maven(url = "https://storage.googleapis.com/download.flutter.io")
        maven(url="../../sdk/android/repo")
 maven(url="https://developer.huawei.com/repo/")}
}

rootProject.name = "android_example"
include(":app")
 