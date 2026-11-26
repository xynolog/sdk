// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class, kotlin.ExperimentalStdlibApi::class)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonIgnoreUnknownKeys
import xynolog.identifiers.AnnotationId
import xynolog.identifiers.JobId
import xynolog.identifiers.ResourceId

/** The multipart upload that creates a resource. A client sends it to the gateway's `POST /resources`; the gateway forwards it untouched to the Archivist's `POST /resources`, which stores the bytes and records the resource. One body, two hops. */
@Serializable
@JsonIgnoreUnknownKeys
public data class ResourceUpload(
    /** Human-readable resource name */
    public val name: String,
    /** Binary content */
    public val file: Binary,
    /** Media type of the content (e.g. text/plain, text/markdown, image/png) */
    public val format: String,
    /** Where the content lives (file://... for local). Required — the client names the location; the server does not derive one. */
    public val storageUri: String,
    /** ISO 639-1 language code */
    public val language: String? = null,
    /** JSON-stringified array of entity type names */
    public val entityTypes: String? = null,
    /** For AI-generated resources: the annotation that triggered generation. Nested into generatedFrom.annotationId on the persisted event. */
    @get:JvmExposeBoxed
    public val sourceAnnotationId: AnnotationId? = null,
    /** For AI-generated resources: the source resource the generating annotation lives on. Nested into generatedFrom.resourceId on the persisted event. */
    @get:JvmExposeBoxed
    public val sourceResourceId: ResourceId? = null,
    /** For AI-generated resources: the prompt that drove generation */
    public val generationPrompt: String? = null,
    /** For AI-generated resources: JSON-stringified Agent naming the model/worker that produced the content. Its identity must be the uploading agent's own — the knowledge base refuses a generator naming anyone else. `creator` and `wasAttributedTo` are never sent; the knowledge base derives them from the cited job. */
    public val generator: String? = null,
    /** The job this resource fulfils, when a worker is creating it. Forwarded onto yield:create; the knowledge base derives who requested the resource from the cited job's own events, and refuses a worker-role create that cites none. Absent for a person's own upload. */
    @get:JvmExposeBoxed
    public val jobId: JobId? = null,
    /** 'true' or 'false' — whether the resource is a draft */
    public val isDraft: String? = null,
    /** A clone token from `yield:clone-token-requested`. With it, the resource is created as a clone of the token's source, inheriting its entity types; `language`, `entityTypes` and the generation fields are then not read. */
    public val cloneToken: String? = null,
    /** With `cloneToken`: 'true' archives the source once the clone exists. */
    public val archiveOriginal: String? = null,
) {
    override fun equals(other: Any?): Boolean = other is ResourceUpload && name == other.name && file.contentEquals(other.file) && format == other.format && storageUri == other.storageUri && language == other.language && entityTypes == other.entityTypes && sourceAnnotationId == other.sourceAnnotationId && sourceResourceId == other.sourceResourceId && generationPrompt == other.generationPrompt && generator == other.generator && jobId == other.jobId && isDraft == other.isDraft && cloneToken == other.cloneToken && archiveOriginal == other.archiveOriginal

    override fun hashCode(): Int = listOf(name, file.contentHashCode(), format, storageUri, language, entityTypes, sourceAnnotationId, sourceResourceId, generationPrompt, generator, jobId, isDraft, cloneToken, archiveOriginal).hashCode()

    /** How Java makes a `ResourceUpload`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val file: Binary,
        private val format: String,
        private val storageUri: String,
    ) {
        private var language: String? = null
        private var entityTypes: String? = null
        private var sourceAnnotationId: AnnotationId? = null
        private var sourceResourceId: ResourceId? = null
        private var generationPrompt: String? = null
        private var generator: String? = null
        private var jobId: JobId? = null
        private var isDraft: String? = null
        private var cloneToken: String? = null
        private var archiveOriginal: String? = null

        public fun language(language: String?): Builder = apply { this.language = language }
        public fun entityTypes(entityTypes: String?): Builder = apply { this.entityTypes = entityTypes }

        @JvmExposeBoxed
        public fun sourceAnnotationId(sourceAnnotationId: AnnotationId?): Builder = apply { this.sourceAnnotationId = sourceAnnotationId }

        @JvmExposeBoxed
        public fun sourceResourceId(sourceResourceId: ResourceId?): Builder = apply { this.sourceResourceId = sourceResourceId }

        public fun generationPrompt(generationPrompt: String?): Builder = apply { this.generationPrompt = generationPrompt }
        public fun generator(generator: String?): Builder = apply { this.generator = generator }

        @JvmExposeBoxed
        public fun jobId(jobId: JobId?): Builder = apply { this.jobId = jobId }

        public fun isDraft(isDraft: String?): Builder = apply { this.isDraft = isDraft }
        public fun cloneToken(cloneToken: String?): Builder = apply { this.cloneToken = cloneToken }
        public fun archiveOriginal(archiveOriginal: String?): Builder = apply { this.archiveOriginal = archiveOriginal }

        public fun build(): ResourceUpload = ResourceUpload(name = name, file = file, format = format, storageUri = storageUri, language = language, entityTypes = entityTypes, sourceAnnotationId = sourceAnnotationId, sourceResourceId = sourceResourceId, generationPrompt = generationPrompt, generator = generator, jobId = jobId, isDraft = isDraft, cloneToken = cloneToken, archiveOriginal = archiveOriginal)
    }

    public companion object {
        /** A builder of a `ResourceUpload` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, file: Binary, format: String, storageUri: String): Builder = Builder(name, file, format, storageUri)
    }
}
