allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Redirect the root project's build directory to the Flutter project's build folder.
rootProject.layout.buildDirectory.value(rootProject.layout.projectDirectory.dir("../build"))

subprojects {
    // Only redirect the build directory for subprojects that are physically 
    // located inside the main project directory (e.g., :app).
    // External plugins (stored in Pub cache on C:) must use their default build directory
    // to avoid "different roots" errors when source and build are on different drives.
    if (project.projectDir.absolutePath.startsWith(rootProject.projectDir.absolutePath)) {
        project.layout.buildDirectory.value(rootProject.layout.buildDirectory.dir(project.name))
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
