import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("uat") {
            dimension = "flavor-type"
            applicationId = "com.formulascholar.formula_scholar"
            resValue(type = "string", name = "app_name", value = "Formula UAT")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.glimfo.formulascholar"
            resValue(type = "string", name = "app_name", value = "Formula Scholar")
        }
    }

    buildFeatures.resValues = true
}