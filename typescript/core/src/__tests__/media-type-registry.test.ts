/**
 * The rules read from the media-type registry do what the shared cases state.
 *
 * protocol/specs/src/media-types/registry.json is the authority every SDK generates its
 * table from (codegen/lib/media_types/media_types.ml, which refuses a registry
 * that cannot be meant), so a generated row cannot drift from it. What is left
 * to hold here is the rules each SDK writes over the table, which
 * protocol/specs/src/media-types/cases.json states once for all of them.
 */

import { describe, it, expect } from 'vitest';
import {
  cloneFormat,
  derivesTextOf,
  isSupportedMediaType,
  mediaTypeForExtension,
  textSourceOf,
  yieldsGeometryOf,
} from '../media-types';
import { deriveStorageUri, storageFileName } from '../storage-uri';
import { table as cases } from './cases/media_types_cases';
import { table as registry } from './cases/media_types_registry';

describe('the rules read from the registry, as every SDK runs them', () => {
  it.each(cases.cloneFormat)(
    'a clone of $source: $why',
    ({ source, format }) => {
      expect(cloneFormat(source ?? undefined)).toBe(format);
    },
  );

  it.each(cases.storageFileName)(
    '$name as $format: $why',
    ({ name, format, fileName }) => {
      if (!isSupportedMediaType(format))
        throw new Error(`the case's format ${format} has no row`);
      expect(storageFileName(name, format)).toBe(fileName);
      expect(deriveStorageUri(name, format)).toBe(`file://${fileName}`);
    },
  );

  it('states, in every case of where a text comes from, the three answers and nothing more', () => {
    expect(cases.textSource.length).toBeGreaterThan(0);
    for (const stated of cases.textSource) {
      expect(Object.keys(stated).sort(), stated.why).toEqual([
        'derivesText',
        'format',
        'textSource',
        'why',
        'yieldsGeometry',
      ]);
    }
    // Each of the registry's words for where a text comes from is some case's answer.
    expect(
      Array.from(
        new Set(cases.textSource.map((stated) => stated.textSource)),
      ).sort(),
    ).toEqual([...registry.textSource].sort());
  });

  it.each(cases.textSource)(
    'the text of "$format": $why',
    ({ format, textSource, yieldsGeometry, derivesText }) => {
      expect(textSourceOf(format)).toBe(textSource);
      expect(yieldsGeometryOf(format)).toBe(yieldsGeometry);
      expect(derivesTextOf(format)).toBe(derivesText);
    },
  );

  it('reads an alias as the extension it is another spelling of', () => {
    const aliases = Object.entries(registry.extensionAliases);
    expect(aliases.length).toBeGreaterThan(0);
    for (const [alias, extension] of aliases) {
      expect(mediaTypeForExtension(alias), alias).toBe(
        mediaTypeForExtension(extension),
      );
      expect(mediaTypeForExtension(alias), alias).toBeDefined();
    }
  });
});
