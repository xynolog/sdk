package xynolog;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.util.List;
import org.junit.jupiter.api.Test;
import xynolog.identifiers.AnnotationId;
import xynolog.identifiers.InvalidIdentifier;
import xynolog.identifiers.ResourceId;
import xynolog.types.GetAnnotationsResponse;
import xynolog.types.MarkDeleteCommand;
import xynolog.types.Motivation;
import xynolog.types.Stated;

/** The protocol's types as a Java program makes and reads them: through builders and checked ids, with no cast and no mangled name. */
final class BuildersTest {
    @Test
    void aModelIsBuiltThroughItsBuilder() {
        AnnotationId annotation = new AnnotationId("ann-1");
        ResourceId resource = new ResourceId("res-1");
        MarkDeleteCommand command = MarkDeleteCommand.builder(annotation).resourceId(resource).build();
        assertEquals(annotation, command.getAnnotationId());
        assertEquals(resource, command.getResourceId());
        assertNull(command.getUserId());
    }

    @Test
    void anIdIsMadeOnlyThroughItsCheck() {
        assertEquals("res-1", ResourceId.parse("res-1").getValue());
        assertNull(ResourceId.parse("a b"));
        InvalidIdentifier refused = assertThrows(InvalidIdentifier.class, () -> new ResourceId("a b"));
        assertEquals("ResourceId", refused.getKind());
    }

    @Test
    void anOptionalNullableMemberIsAbsentNullOrAValue() {
        assertSame(Stated.Absent.INSTANCE, GetAnnotationsResponse.builder(List.of(), 0.0).build().getMotivation());
        assertSame(Stated.Null.INSTANCE, GetAnnotationsResponse.builder(List.of(), 0.0).motivation(null).build().getMotivation());
        assertEquals(new Stated.Value<>(Motivation.Linking), GetAnnotationsResponse.builder(List.of(), 0.0).motivation(Motivation.Linking).build().getMotivation());
    }
}
