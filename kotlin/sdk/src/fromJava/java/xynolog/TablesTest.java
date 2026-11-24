package xynolog;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;
import xynolog.control.ControlMethods;
import xynolog.control.ControlSender;
import xynolog.services.ArchivistRoute;
import xynolog.services.ServiceTables;

/** The service tables and the control API's table, as Java reads them: each a static field. */
class TablesTest {
    @Test
    void aServiceTableIsAStaticField() {
        assertFalse(ServiceTables.JOBS_BUDGETS.getBudgets().isEmpty());
        assertSame(ServiceTables.JOBS_BUDGETS, ServiceTables.SERVICE_TABLES.get("jobs/budgets.json"));
        assertTrue(ArchivistRoute.values().length > 0);
    }

    @Test
    void aControlMethodIsAConstant() {
        assertEquals("launcher.about", ControlMethods.LAUNCHER_ABOUT.getName());
        assertEquals(ControlSender.Launcher, ControlMethods.NOTIFICATIONS_PROGRESS.getSentBy());
        assertSame(ControlMethods.LAUNCHER_ABOUT, ControlMethods.METHODS.get("launcher.about"));
    }
}
