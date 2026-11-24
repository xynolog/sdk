-- Generated from protocol/specs/src/service-environment/variables.json; do not edit.
-- Regenerate: make generate (codegen/lib/service_environment/service_environment.ml)
module Xynolog.Internal.Generated.ServiceEnvironmentValues (serviceEnvironmentValues) where

import Data.Map.Strict qualified as Map
import Xynolog.ServiceEnvironment

serviceEnvironmentValues :: Map.Map String String
serviceEnvironmentValues = Map.fromList [("JWT_SECRET", jwtSecret), ("XYNOLOG_OIDC_CLIENT_ID", xynologOidcClientId), ("XYNOLOG_OIDC_CLIENT_SECRET", xynologOidcClientSecret), ("XYNOLOG_OIDC_CLIENT_KEY", xynologOidcClientKey), ("OTEL_EXPORTER_OTLP_ENDPOINT", otelExporterOtlpEndpoint), ("OTEL_SERVICE_NAME", otelServiceName), ("OTEL_SDK_DISABLED", otelSdkDisabled), ("OTEL_CONSOLE_EXPORTER", otelConsoleExporter), ("OTEL_METRICS_EXPORTER", otelMetricsExporter), ("OTEL_METRIC_EXPORT_INTERVAL", otelMetricExportInterval), ("OTEL_BSP_SCHEDULE_DELAY", otelBspScheduleDelay), ("XYNOLOG_BUS_LOG", xynologBusLog), ("SUPERVISE_EVENTS", superviseEvents), ("SUPERVISE_NAME", superviseName)]
