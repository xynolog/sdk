// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The implementations manifest: the file a run of the conformance harness is given with --implementations, naming what the run holds to Protocol. Every service is run by the xynolog launcher, from the image the knowledge base's stack documents name (contract/LAUNCHER-CONTROL.md, service.run): an implementation is a knowledge base whose documents name its images, and another implementation is another manifest. Each SDK's drivers are programs the harness starts itself, since none is a service. There is no default manifest. The reader reads this schema in the table dialect and derives its model (Tables.Conformance_implementations), for the harness to decode a manifest by. */
@Serializable
public data class ConformanceImplementations(
    /** How the launcher's control API is served: the xynolog command, run with control. A command and its arguments, as the harness starts it. An argument that starts with ./ or ../ is a path, resolved against the manifest's own directory; every other is passed as written. */
    public val launcher: kotlin.collections.List<String>,
    /** The knowledge base whose stack documents name each service's image, and whose stack runs the record and index the suites need. A relative root is resolved against the manifest's own directory. */
    public val target: LocalTarget,
    /** Each SDK's drivers, by the SDK's name: the programs the SDK and worker suites talk to in its place (conformance/sdk/README.md, "The driver protocol"). */
    public val sdks: kotlin.collections.Map<String, ConformanceImplementationsSdksValue>,
    /** The model catalogue the implementation supplies, by its path; a relative one is resolved against the manifest's own directory. The Librarian's and the worker service's documents name one, so a run of either suite without it refuses to start. */
    public val modelCatalogue: String? = null,
) {
    /** How Java makes a `ConformanceImplementations`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val launcher: kotlin.collections.List<String>,
        private val target: LocalTarget,
        private val sdks: kotlin.collections.Map<String, ConformanceImplementationsSdksValue>,
    ) {
        private var modelCatalogue: String? = null

        public fun modelCatalogue(modelCatalogue: String?): Builder = apply { this.modelCatalogue = modelCatalogue }

        public fun build(): ConformanceImplementations = ConformanceImplementations(launcher = launcher, target = target, sdks = sdks, modelCatalogue = modelCatalogue)
    }

    public companion object {
        /** A builder of a `ConformanceImplementations` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(launcher: kotlin.collections.List<String>, target: LocalTarget, sdks: kotlin.collections.Map<String, ConformanceImplementationsSdksValue>): Builder = Builder(launcher, target, sdks)
    }
}
