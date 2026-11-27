package xynolog.control

import kotlinx.serialization.KSerializer
import xynolog.types.ControlSender

/** A notification of the launcher's control API (protocol/specs/src/control/methods.json): its name, which side sends it, and what its params are. [ControlMethods] holds each one. */
public class ControlNotification<P> internal constructor(
    public val name: String,
    public val sentBy: ControlSender,
    public val params: KSerializer<P>,
) {
    override fun toString(): String = name
}

/** A method of the launcher's control API (protocol/specs/src/control/methods.json): its name, what its params and its result are, whether it runs alone, and the notifications it sends besides notifications/progress. [ControlMethods] holds each one. */
public class ControlMethod<P, R> internal constructor(
    public val name: String,
    public val params: KSerializer<P>,
    public val result: KSerializer<R>,
    public val exclusive: Boolean,
    public val sends: List<ControlNotification<*>>,
) {
    override fun toString(): String = name
}
