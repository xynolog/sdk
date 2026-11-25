package xynolog.types

import kotlinx.serialization.json.Json

/**
 * How the SDK reads and writes the protocol. A property left out stays left
 * out (no defaults are written), a null stays null, and a property an object
 * does not name is refused by an object whose schema admits none and ignored
 * by the rest, which the generator marks to ignore what a later gateway adds.
 */
internal val wireJson: Json = Json { encodeDefaults = false }
