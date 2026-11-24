// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/archivist/openapi.json and its paths
// Regenerate:  make generate  (codegen/lib/typescript_types/table_modules.ml)

/** Each operation of the Archivist, by its operationId: its method, and its path (a `{name}` for each parameter, which the caller fills). */
export const archivistRoutes = {
  getHealth: { method: 'GET', path: '/health' },
  listStreams: { method: 'GET', path: '/events' },
  getResourceEvents: { method: 'GET', path: '/events/{resourceId}' },
  storeResource: { method: 'POST', path: '/resources' },
  getResourceContent: { method: 'GET', path: '/resources/{id}/content' },
  getResourceJsonLd: { method: 'GET', path: '/resources/{id}/jsonld' },
  getResourceAnnotations: {
    method: 'GET',
    path: '/resources/{id}/annotations',
  },
  getResourceAnchoredText: {
    method: 'GET',
    path: '/resources/{id}/anchored-text',
  },
  putResourceAnchoredText: {
    method: 'PUT',
    path: '/resources/{id}/anchored-text',
  },
  listAnchoredTextEntries: { method: 'GET', path: '/anchored-text/entries' },
  getStoredResourceAnchoredText: {
    method: 'GET',
    path: '/resources/{id}/anchored-text/stored',
  },
  putAnchoredTextStamp: { method: 'PUT', path: '/anchored-text/stamp' },
} as const;
