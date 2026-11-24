package xynolog

import java.time.Instant
import java.time.ZoneOffset
import java.time.format.DateTimeFormatter
import java.time.temporal.ChronoUnit

private val TO_THE_MILLISECOND: DateTimeFormatter = DateTimeFormatter.ofPattern("uuuu-MM-dd'T'HH:mm:ss.SSS'Z'").withZone(ZoneOffset.UTC)

/** `at` as RFC 3339, in UTC, to the millisecond: how every SDK writes a time it stamps. */
internal fun stamped(at: Instant): String = TO_THE_MILLISECOND.format(at.truncatedTo(ChronoUnit.MILLIS))
