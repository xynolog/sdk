// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/identifiers/kinds.json and each kind's schema
// Regenerate:  make generate  (codegen/lib/identifiers/typescript.ml)

/**
 * The kinds of id. Each is a type of its own, so one kind is not taken for
 * another, and each is made by one constructor that holds text to the kind's
 * rule, which is the schema's pattern; its guard asks the same of text without
 * throwing. A constructor stands where text enters: a URL, a DOM attribute, a
 * script's argument. What the gateway answers is typed already and is not
 * checked again here.
 */

import type { components } from './types';
import { identifierKind } from './identifier';

/** A resource's id: a name, never the resource's URI or a path. 1 to 128 of the letters `A`–`Z` and `a`–`z`, the digits, `_` and `-`. It is one segment of a URL and one name in a file system, and it is held to that wherever it enters: a gateway refuses a payload that carries anything else. How one is made is no part of the rule. `__system__` is the one that names no resource: the scope events about the knowledge base itself are logged under. */
export type ResourceId = components['schemas']['ResourceId'];

const RESOURCE_ID = identifierKind<ResourceId>(
  'ResourceId',
  '^[A-Za-z0-9_-]{1,128}$',
);

/** Whether `value` is a `ResourceId`: where text enters and what is not an id is an answer, not a fault. */
export const isResourceId = RESOURCE_ID.is;

/** `value` as a `ResourceId`. Throws a `TypeError` when the kind's rule refuses it. */
export const resourceId = RESOURCE_ID.of;

/** An annotation's id: a name, never the annotation's URI. 1 to 128 of the letters `A`–`Z` and `a`–`z`, the digits, `_` and `-`. It is one segment of a URL and one name in a file system, and it is held to that wherever it enters: a gateway refuses a payload that carries anything else. How one is made is no part of the rule. */
export type AnnotationId = components['schemas']['AnnotationId'];

const ANNOTATION_ID = identifierKind<AnnotationId>(
  'AnnotationId',
  '^[A-Za-z0-9_-]{1,128}$',
);

/** Whether `value` is a `AnnotationId`: where text enters and what is not an id is an answer, not a fault. */
export const isAnnotationId = ANNOTATION_ID.is;

/** `value` as a `AnnotationId`. Throws a `TypeError` when the kind's rule refuses it. */
export const annotationId = ANNOTATION_ID.of;

/** A job's id. 1 to 128 of the letters `A`–`Z` and `a`–`z`, the digits, `_` and `-`. It is one segment of a URL and one name in a file system, and it is held to that wherever it enters: a gateway refuses a payload that carries anything else. How one is made is no part of the rule. */
export type JobId = components['schemas']['JobId'];

const JOB_ID = identifierKind<JobId>('JobId', '^[A-Za-z0-9_-]{1,128}$');

/** Whether `value` is a `JobId`: where text enters and what is not an id is an answer, not a fault. */
export const isJobId = JOB_ID.is;

/** `value` as a `JobId`. Throws a `TypeError` when the kind's rule refuses it. */
export const jobId = JOB_ID.of;

/** The identity of whoever did something, a person or a software agent alike: a DID (`did:web:<domain>:users:<subject>`, `did:web:<domain>:agents:<subject>`), with no whitespace in it. Never a name, an address, or a row in a table. What follows `did:` is not constrained further: a subject is the issuer's, percent-encoded, and that encoding leaves some punctuation as it is. */
export type UserId = components['schemas']['UserId'];

const USER_ID = identifierKind<UserId>('UserId', '^did:\\S+$');

/** Whether `value` is a `UserId`: where text enters and what is not an id is an answer, not a fault. */
export const isUserId = USER_ID.is;

/** `value` as a `UserId`. Throws a `TypeError` when the kind's rule refuses it. */
export const userId = USER_ID.of;
