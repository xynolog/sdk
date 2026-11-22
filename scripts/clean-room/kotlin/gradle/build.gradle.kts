// A Java application of the publication alone: the bundle's Maven repository
// for it, Maven Central for what its module metadata names.
plugins { java }

repositories {
    maven { url = uri("file:///tmp/repo") }
    mavenCentral()
}

dependencies {
    implementation("org.xynolog:xynolog:${providers.gradleProperty("xynologVersion").get()}")
}

tasks.withType<JavaCompile>().configureEach {
    options.release = providers.gradleProperty("javaRelease").get().toInt()
}
