// Asegurate de tener esto al principio del archivo
buildscript {
    repositories {
        google()           // 🔹 Debe ir primero
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.3.15")
    }
}

// 🔹 No todos los proyectos usan esta sección, pero la dejamos correcta
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 🔧 Configuración de directorios personalizados (esto es opcional pero válido)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
