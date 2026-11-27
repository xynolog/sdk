'use client';

/**
 * Inline upload-progress affordance for the compose page.
 *
 * Subscribes (via prop) to a `UploadProgress | null` value derived from
 * `composeVM.uploadProgress$`. Renders nothing when null; renders an
 * indeterminate state on `started`; renders a labeled bar with byte
 * counts on `progress`; renders a brief "Uploaded" success state on
 * `finished` (cleared by the state unit's `null` push on complete).
 *
 * Designed to live below the Save button in the compose form so the
 * visual association with the action that triggered the upload is
 * direct. Uses the existing `.xynolog-progress` styles in
 * `typescript/react-ui/src/styles/core/progress.css`.
 */

import React from 'react';
import type { UploadProgress } from '@xynolog/sdk';

export interface UploadProgressBarProps {
  progress: UploadProgress | null;
  /** What is being uploaded, named at the head of each line. */
  label: string;
}

function formatBytes(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  if (bytes < 1024 * 1024 * 1024)
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
  return `${(bytes / (1024 * 1024 * 1024)).toFixed(2)} GB`;
}

export function UploadProgressBar({
  progress,
  label,
}: UploadProgressBarProps): React.ReactElement | null {
  if (!progress) return null;

  if (progress.phase === 'started') {
    return (
      <div
        className="xynolog-progress-wrapper"
        role="status"
        aria-live="polite"
      >
        <div className="xynolog-progress__label">
          <span>{label}: starting…</span>
        </div>
        <div className="xynolog-progress xynolog-progress--indeterminate">
          <div className="xynolog-progress__fill" />
        </div>
      </div>
    );
  }

  if (progress.phase === 'progress') {
    const total =
      progress.totalBytes !== undefined && progress.totalBytes > 0
        ? progress.totalBytes
        : null;
    const indeterminate = total === null;
    const percentage =
      total === null
        ? 0
        : Math.min(100, Math.round((progress.bytesUploaded / total) * 100));
    return (
      <div
        className="xynolog-progress-wrapper"
        role="status"
        aria-live="polite"
      >
        <div className="xynolog-progress__label">
          {total === null ? (
            <span>
              {label}: {formatBytes(progress.bytesUploaded)}…
            </span>
          ) : (
            <>
              <span>
                {label}: {percentage}%
              </span>
              <span>
                {formatBytes(progress.bytesUploaded)} / {formatBytes(total)}
              </span>
            </>
          )}
        </div>
        <div
          className={`xynolog-progress${indeterminate ? ' xynolog-progress--indeterminate' : ''}`}
          role="progressbar"
          aria-valuemin={0}
          aria-valuemax={indeterminate ? undefined : 100}
          aria-valuenow={indeterminate ? undefined : percentage}
        >
          <div
            className="xynolog-progress__fill"
            style={indeterminate ? undefined : { width: `${percentage}%` }}
          />
        </div>
      </div>
    );
  }

  // phase === 'finished'
  return (
    <div className="xynolog-progress-wrapper" role="status" aria-live="polite">
      <div className="xynolog-progress__label">
        <span>{label}: uploaded</span>
      </div>
      <div
        className="xynolog-progress"
        role="progressbar"
        aria-valuemin={0}
        aria-valuemax={100}
        aria-valuenow={100}
      >
        <div
          className="xynolog-progress__fill xynolog-progress__fill--success"
          style={{ width: '100%' }}
        />
      </div>
    </div>
  );
}
