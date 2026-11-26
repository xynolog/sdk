// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlin.ExperimentalStdlibApi::class)

package xynolog.types

import kotlinx.serialization.Serializable
import xynolog.identifiers.AnnotationId
import xynolog.identifiers.JobId
import xynolog.identifiers.ResourceId

/** What uploading a resource is handed: its bytes, what the upload states of them, and, for a clone, its token. Each member is as a caller holds it; ResourceUpload is the multipart body the content transport sends of it. */
@Serializable
public data class PutBinaryRequest(
    /** Human-readable resource name */
    public val name: String,
    /** The bytes, opened for each sending of the upload: the multipart body's `file` part each time. */
    public val file: ByteSource,
    /** Media type of the content (e.g. text/plain, text/markdown, image/png) */
    public val format: String,
    /** Where the content lives (file://... for local). Required — the client names the location; the server does not derive one. */
    public val storageUri: String,
    /** ISO 639-1 language code */
    public val language: String? = null,
    public val entityTypes: kotlin.collections.List<String>? = null,
    @get:JvmExposeBoxed
    public val sourceAnnotationId: AnnotationId? = null,
    @get:JvmExposeBoxed
    public val sourceResourceId: ResourceId? = null,
    /** For AI-generated resources: the prompt that drove generation */
    public val generationPrompt: String? = null,
    /** The Software peer that produced the content, when software did. Its identity must be the emitter's own — the knowledge base refuses a generator naming anyone else, and supplies it from the verified emitter when omitted. `creator` and `wasAttributedTo` are never sent; the knowledge base derives them from the emitter and the cited job. */
    public val generator: OneOrMoreAgents? = null,
    @get:JvmExposeBoxed
    public val jobId: JobId? = null,
    public val isDraft: Boolean? = null,
    /** A clone token from `yield:clone-token-requested`. With it, the resource is created as a clone of the token's source, inheriting its entity types; `language`, `entityTypes` and the generation fields are then not read. */
    public val cloneToken: String? = null,
    public val archiveOriginal: Boolean? = null,
) {
    override fun equals(other: Any?): Boolean = other is PutBinaryRequest && name == other.name && file.contentEquals(other.file) && format == other.format && storageUri == other.storageUri && language == other.language && entityTypes == other.entityTypes && sourceAnnotationId == other.sourceAnnotationId && sourceResourceId == other.sourceResourceId && generationPrompt == other.generationPrompt && generator == other.generator && jobId == other.jobId && isDraft == other.isDraft && cloneToken == other.cloneToken && archiveOriginal == other.archiveOriginal

    override fun hashCode(): Int = listOf(name, file.contentHashCode(), format, storageUri, language, entityTypes, sourceAnnotationId, sourceResourceId, generationPrompt, generator, jobId, isDraft, cloneToken, archiveOriginal).hashCode()

    /** How Java makes a `PutBinaryRequest`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val file: ByteSource,
        private val format: String,
        private val storageUri: String,
    ) {
        private var language: String? = null
        private var entityTypes: kotlin.collections.List<String>? = null
        private var sourceAnnotationId: AnnotationId? = null
        private var sourceResourceId: ResourceId? = null
        private var generationPrompt: String? = null
        private var generator: OneOrMoreAgents? = null
        private var jobId: JobId? = null
        private var isDraft: Boolean? = null
        private var cloneToken: String? = null
        private var archiveOriginal: Boolean? = null

        public fun language(language: String?): Builder = apply { this.language = language }
        public fun entityTypes(entityTypes: kotlin.collections.List<String>?): Builder = apply { this.entityTypes = entityTypes }

        @JvmExposeBoxed
        public fun sourceAnnotationId(sourceAnnotationId: AnnotationId?): Builder = apply { this.sourceAnnotationId = sourceAnnotationId }

        @JvmExposeBoxed
        public fun sourceResourceId(sourceResourceId: ResourceId?): Builder = apply { this.sourceResourceId = sourceResourceId }

        public fun generationPrompt(generationPrompt: String?): Builder = apply { this.generationPrompt = generationPrompt }
        public fun generator(generator: OneOrMoreAgents?): Builder = apply { this.generator = generator }

        @JvmExposeBoxed
        public fun jobId(jobId: JobId?): Builder = apply { this.jobId = jobId }

        public fun isDraft(isDraft: Boolean?): Builder = apply { this.isDraft = isDraft }
        public fun cloneToken(cloneToken: String?): Builder = apply { this.cloneToken = cloneToken }
        public fun archiveOriginal(archiveOriginal: Boolean?): Builder = apply { this.archiveOriginal = archiveOriginal }

        public fun build(): PutBinaryRequest = PutBinaryRequest(name = name, file = file, format = format, storageUri = storageUri, language = language, entityTypes = entityTypes, sourceAnnotationId = sourceAnnotationId, sourceResourceId = sourceResourceId, generationPrompt = generationPrompt, generator = generator, jobId = jobId, isDraft = isDraft, cloneToken = cloneToken, archiveOriginal = archiveOriginal)
    }

    public companion object {
        /** A builder of a `PutBinaryRequest` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, file: ByteSource, format: String, storageUri: String): Builder = Builder(name, file, format, storageUri)
    }
}
