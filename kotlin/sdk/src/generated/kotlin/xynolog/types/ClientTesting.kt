// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** client/testing.json: the testing kit every SDK ships. */
@Serializable
public data class ClientTesting(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** What a faulty transport does to a request. */
    public val faultActions: kotlin.collections.List<ClientTestingFaultActionsItem>,
    public val delayMs: ClientTestingDelayMs,
    public val scheduleLength: ClientTestingScheduleLength,
    public val slack: ClientTestingSlack,
    public val deliveryOps: ClientTestingDeliveryOps,
    /** The kit's records. */
    public val records: kotlin.collections.List<ClientTestingRecordsItem>,
) {
    /** How Java makes a `ClientTesting`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val faultActions: kotlin.collections.List<ClientTestingFaultActionsItem>,
        private val delayMs: ClientTestingDelayMs,
        private val scheduleLength: ClientTestingScheduleLength,
        private val slack: ClientTestingSlack,
        private val deliveryOps: ClientTestingDeliveryOps,
        private val records: kotlin.collections.List<ClientTestingRecordsItem>,
    ) {
        public fun build(): ClientTesting = ClientTesting(comment = comment, faultActions = faultActions, delayMs = delayMs, scheduleLength = scheduleLength, slack = slack, deliveryOps = deliveryOps, records = records)
    }

    public companion object {
        /** A builder of a `ClientTesting` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, faultActions: kotlin.collections.List<ClientTestingFaultActionsItem>, delayMs: ClientTestingDelayMs, scheduleLength: ClientTestingScheduleLength, slack: ClientTestingSlack, deliveryOps: ClientTestingDeliveryOps, records: kotlin.collections.List<ClientTestingRecordsItem>): Builder = Builder(comment, faultActions, delayMs, scheduleLength, slack, deliveryOps, records)
    }
}
