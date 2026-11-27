package xynolog.signin

import xynolog.types.System
import java.util.Locale

/** The system this process runs on, as the launcher's state home differs by it. */
public fun thisSystem(): System {
    val name = java.lang.System.getProperty("os.name").lowercase(Locale.ROOT)
    return when {
        name.startsWith("mac") -> System.Macos
        name.startsWith("windows") -> System.Windows
        else -> System.Other
    }
}

private fun under(separator: Char, base: String, vararg names: String): String = (listOf(base.trimEnd(separator)) + names).joinToString(separator.toString())

/**
 * The launcher's state home, from what the system says of the person's
 * directories (protocol/specs/src/sign-in-store/cases.json): `home` is the home
 * directory (`HOME`, or `USERPROFILE` on Windows), `xdgStateHome` is
 * `XDG_STATE_HOME` and `localAppData` is `LOCALAPPDATA`, each null when it is
 * not set. The SDK reads none of them: the application hands them in. Null
 * when there is no home. The path is written with the system's own separator,
 * not this machine's, so a case gives one answer whichever machine reads it.
 */
public fun stateDir(system: System, home: String?, xdgStateHome: String?, localAppData: String?): String? {
    if (home.isNullOrEmpty()) return null
    return when (system) {
        System.Macos -> under('/', home, "Library", "Application Support", "xynolog")
        System.Windows -> if (!localAppData.isNullOrEmpty()) under('\\', localAppData, "xynolog") else under('\\', home, "AppData", "Local", "xynolog")
        System.Other -> if (!xdgStateHome.isNullOrEmpty()) under('/', xdgStateHome, "xynolog") else under('/', home, ".local", "state", "xynolog")
    }
}
