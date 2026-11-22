import java.util.concurrent.CompletableFuture;
import kotlinx.coroutines.flow.StateFlow;
import kotlinx.serialization.json.JsonObject;
import xynolog.bus.BusKt;
import xynolog.bus.Operation;
import xynolog.http.AgentToken;
import xynolog.transport.Transport;

// Java that names the types the SDK's API takes and returns, from
// kotlinx-serialization-json and kotlinx-coroutines-core: it compiles only if
// the publication hands them to a consumer's compile classpath.
public final class Consumer {
  static CompletableFuture<?> ask(Transport transport, Operation operation, JsonObject body) {
    return BusKt.requestFuture(transport, operation, body, 30_000L);
  }

  static StateFlow<?> token(AgentToken agent) {
    return agent.getToken();
  }

  public static void main(String[] arguments) {
    System.out.println(Consumer.class.getName());
  }
}
