allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Some transitive plugins (pulled in by the older supabase_flutter 1.x) hardcode
// compileSdk 31, but their androidx deps require 34+. Force every Android module
// up to 34 so AAR metadata checks pass. Guard on state.executed because :app is
// eagerly evaluated above via evaluationDependsOn.
subprojects {
    val bumpCompileSdk = {
        (extensions.findByName("android") as? com.android.build.gradle.BaseExtension)?.let { ext ->
            val current = ext.compileSdkVersion?.removePrefix("android-")?.toIntOrNull() ?: 0
            if (current < 34) {
                ext.compileSdkVersion(34)
            }
        }
    }
    if (state.executed) bumpCompileSdk() else afterEvaluate { bumpCompileSdk() }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
