// Top-level build file for Tripstick project (build.gradle.kts)

import org.gradle.api.tasks.Delete
import org.gradle.api.Project
import org.gradle.api.artifacts.dsl.RepositoryHandler

// Repositories available for all projects
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Change build directory to /build
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// ✨ Plugins Section
plugins {
    id("com.android.application") version "8.7.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false  // ✅ updated to match
    id("com.google.gms.google-services") version "4.4.2" apply false
}


// ✨ Buildscript Section
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.2") // ✅ Correct Firebase plugin dependency
    }
}
