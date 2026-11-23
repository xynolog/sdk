# @xynolog/react-ui

[![Tests](https://github.com/xynolog/sdk/actions/workflows/ci.yml/badge.svg)](https://github.com/xynolog/sdk/actions/workflows/ci.yml?query=branch%3Amain+is%3Asuccess+job%3A%22Test+react-ui%22)
[![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=typescript-react-ui)](https://app.codecov.io/gh/xynolog/sdk/components)
[![npm version](https://img.shields.io/npm/v/@xynolog/react-ui.svg)](https://www.npmjs.com/package/@xynolog/react-ui)
[![npm downloads](https://img.shields.io/npm/dm/@xynolog/react-ui.svg)](https://www.npmjs.com/package/@xynolog/react-ui)
[![License](https://img.shields.io/npm/l/@xynolog/react-ui.svg)](https://github.com/xynolog/sdk/blob/main/LICENSE)
[![WCAG 2.1 AA](https://img.shields.io/badge/WCAG-2.1%20AA-blue.svg)](https://www.w3.org/WAI/WCAG2AA-Conformance)

Framework-agnostic React component library for building Xynolog knowledge management applications.

## Overview

`@xynolog/react-ui` provides reusable React components, hooks, and utilities for creating Xynolog applications. The library is designed to be **completely framework-agnostic**, working seamlessly with Next.js, Create React App, Vite, Remix, or any other React framework.

## Install

```bash
npm install @xynolog/react-ui @xynolog/sdk @xynolog/core
```

Below 1.0 the minor number is the break, and the caret range npm writes into `package.json`
takes the releases up to the next minor and no further.

`@xynolog/sdk` is the primary dependency — it provides the `XynologBrowser`,
`XynologClient`, the read-through cache, and the state machinery that
`@xynolog/react-ui` renders. `@xynolog/core` provides the shared API types.

### Peer Dependencies

```json
{
  "react": "^19.0.0",
  "react-dom": "^19.0.0"
}
```

### CSS Setup

Import the styles in your app's main CSS file:

```css
/* Your app's main CSS file (e.g., globals.css, app.css) */
@import '@xynolog/react-ui/styles';
```

**Requirements:**
- Your build system must support PostCSS with `postcss-import` plugin
- This is standard in Next.js, Vite, and most modern build tools
- The package exports source CSS files, which your build system will process

**What this does:**
- Imports all component styles, design tokens, and CSS variables
- Your build tool processes the `@import` statements and bundles the CSS
- No additional configuration needed in most frameworks

## Quick Start

### 1. Set Up Providers

```tsx
import {
  XynologProvider,
  TranslationProvider,
  ProtectedErrorBoundary,
  SessionEndedModal,
  PermissionDeniedModal,
  type TranslationManager,
} from '@xynolog/react-ui';

function App({ translationManager, children }: { translationManager: TranslationManager; children: React.ReactNode }) {
  // `translationManager` is your implementation (see "Use Translations" below)
  return (
    <TranslationProvider translationManager={translationManager}>
      {/* XynologProvider puts the XynologBrowser singleton into context.
          useXynolog() hands it back; the active XynologSession (and its
          XynologClient) flow from there. */}
      <XynologProvider>
        <ProtectedErrorBoundary>
          <SessionEndedModal />
          <PermissionDeniedModal />
          {children}
        </ProtectedErrorBoundary>
      </XynologProvider>
    </TranslationProvider>
  );
}
```

### 2. Use Components

```tsx
import { ResourceViewer, useResourceLoader, useXynolog, useObservable } from '@xynolog/react-ui';

function Resource({ rId }: { rId: ResourceId }) {
  // The active session (null until one is signed in) and its client
  const session = useObservable(useXynolog().activeSession$) ?? null;
  // browse.resource() and browse.annotations() are SDK live queries backed by
  // the read-through cache; useResourceLoader subscribes to both.
  const { resource, annotations } = useResourceLoader(session?.client ?? null, rId);

  if (!resource) return <div>Loading...</div>;

  // `content` is the decoded text the host fetched (see useResourceContent)
  return <ResourceViewer locale="en" session={session} resource={{ ...resource, content }} annotations={annotations} />;
}
```

### 3. Use Translations

```tsx
import { TranslationProvider, useTranslations, type TranslationManager } from '@xynolog/react-ui';

// Reads the nearest TranslationProvider, and throws when there is none
function SettingsButton() {
  const t = useTranslations('Toolbar');
  return <button>{t('settings')}</button>;
}

// Option 1: Built-in locales
function SpanishApp() {
  return (
    <TranslationProvider locale="es">
      <SettingsButton />
    </TranslationProvider>
  );
}

// Option 2: Custom translation system
const messages: Record<string, Record<string, string>> = {
  Toolbar: { settings: 'Ajustes' },
};

const myTranslationManager: TranslationManager = {
  t: (namespace, key) => messages[namespace]?.[key] ?? `${namespace}.${key}`,
};

function CustomApp() {
  return (
    <TranslationProvider translationManager={myTranslationManager}>
      <SettingsButton />
    </TranslationProvider>
  );
}
```

### 4. Embed the Viewer With a Bare Session

`ResourceViewer`, `BrowseView` and `AnnotateView` need no provider. Each takes a session and its
language as props, and mounts its own `TranslationProvider` from the language. The language is
required: a `locale` of react-ui's own, or the host's `translationManager`. react-ui assumes
none, so a host that leaves it out does not compile.

```tsx
import { ResourceViewer, useResourceLoader } from '@xynolog/react-ui';
import type { ResourceId } from '@xynolog/core';
import type { XynologSession } from '@xynolog/sdk';

function EmbeddedResource({ session, rId, content }: { session: XynologSession; rId: ResourceId; content: string }) {
  const { resource, annotations } = useResourceLoader(session.client, rId);
  if (!resource) return null;
  return <ResourceViewer locale="en" session={session} resource={{ ...resource, content }} annotations={annotations} />;
}
```

A locale's strings load the first time a view of that locale mounts; every view after that renders
at once. Colours, the JSON-LD view's among them, follow the page's `data-theme` attribute through
react-ui's stylesheet, so dark mode needs nothing more.

## Key Features

- **Framework Independence** - Zero dependencies on Next.js, next-auth, or next-intl
- **Component Composition** - Components accept framework-specific implementations (Link, routing) as props
- **Provider Pattern** - Consistent approach for session, translations, and routing
- **SDK Live Queries** - Read data with `useObservable()` over the SDK's read-through cache; no bespoke fetching layer
- **Authentication Components** - Error display; signing in happens at the knowledge base's issuer
- **Navigation Components** - Collapsible sidebar with drag & drop resource tabs
- **Modal Components** - Global search and resource selection modals
- **Accessibility First** - WCAG compliant with keyboard navigation, screen reader support
- **Comprehensive Testing** - 1250+ tests with extensive coverage
- **Annotation System** - Rich annotation and tagging capabilities
- **Built-in Translations** - one per supported language (`LOCALE_CODES` from `@xynolog/core`), each loaded on demand
- **Flexible i18n** - Two modes: built-in locales or a custom translation system. There is no default language

## Architecture

The library follows strict architectural principles:

- **No Aliasing or Wrappers** - Direct API access, no compatibility layers
- **Provider Pattern** - Consistent dependency injection via React Context
- **Framework Agnostic** - Apps provide framework-specific implementations
- **TypeScript First** - Full type safety throughout

## CSS Architecture

**This package ships plain CSS and no utility framework.** No Tailwind, no
`@apply`, no utility classes — only `xynolog-`-prefixed BEM classes, data
attributes, and CSS custom properties. The rule exists so the stylesheet drops
into any stack a host happens to use, and it is enforced, not merely intended:
`npm run lint:no-utility-classes` plus the `xynolog/invariants` stylelint rule
fail on a utility class or a non-`xynolog-` selector.

The rule binds the library, not its hosts. An app is free to use whatever it
likes — `images/browser` uses Tailwind — and consumes this package by whichever
route fits:

| Host stack | Consume via |
|---|---|
| Anything with PostCSS | `@import '@xynolog/react-ui/styles'` |
| Own design system | `@xynolog/react-ui/styles/variables.css` for the tokens alone |

The styles are organized into a modular, maintainable structure:

- **Design Tokens** - Centralized variables for consistent theming
- **Core UI Elements** - Fundamental, reusable components (buttons, toggles, sliders, etc.)
- **W3C Motivations** - Dedicated styles for Web Annotation standard motivations
- **Component/Panel Separation** - Complex components vs. layout containers
- **Dark Theme Support** - Comprehensive dark mode using `[data-theme="dark"]`

Key directories:
- `styles/core/` - Fundamental UI elements (buttons, toggles, progress bars, sliders, badges, tags, indicators)
- `styles/motivations/` - W3C Web Annotation motivation styles (reference, highlight, assessment, comment, tag)
- `styles/components/` - Complex, composed components
- `styles/panels/` - Panel layouts and containers
- `styles/features/` - Feature-specific styling

See [STYLES.md](https://github.com/xynolog/docs/blob/main/builder/react-ui/STYLES.md) for detailed CSS documentation.

## Core Concepts

### Providers

Cross-cutting concerns use the Provider Pattern:

- **XynologProvider** - The single React provider for session state. Puts the module-scoped `XynologBrowser` singleton into context; `useXynolog()` returns it. The browser owns the KB list, active KB, and validated session lifecycle — it's the single source of truth for "which KB and what's the session against it." The active `XynologSession` (and its `XynologClient`) flow from `browser.activeSession$`.
- **TranslationProvider** - Internationalization
- **Routing** - Not a provider: components that link take the host's `Link` and `routes` as props (`LinkComponentProps`, `RouteBuilder`)

See [SESSION.md](https://github.com/xynolog/docs/blob/main/builder/react-ui/SESSION.md) for details.

### Page state machines

`@xynolog/react-ui` houses the framework-neutral state machinery for the Xynolog Browser's specific pages and shell. These are RxJS-based factories (no React inside; pure observables and async functions) but they're shaped around the Browser's page taxonomy, so they belong with the components that render them rather than in `@xynolog/sdk`:

- **Shell** — `createShellStateUnit` (toolbar panel state with `'knowledge-base' | 'common' | 'resource'` taxonomy)
- **Pages** — `createComposePageStateUnit`, `createResourceViewerPageStateUnit`, `createResourceLoaderStateUnit`
- **Discovery + moderation** — `createDiscoverStateUnit`, `createEntityTagsStateUnit`

Adjacent to the state units: `useKBDiscovery` binds the sdk's
launcher-KB discovery subscription (`subscribeDiscovery`) to React state —
see [SESSION.md](https://github.com/xynolog/docs/blob/main/builder/react-ui/SESSION.md#usekbdiscovery--launcher-published-kbs).

Each lives in `src/features/<feature>/state/` (or `src/state/` for cross-feature ones) next to the components that consume it. The `useStateUnit` hook wires them into React lifecycles.

Use them via `import { createComposePageStateUnit } from '@xynolog/react-ui'`. UI-shape-neutral state machines (flow VMs, worker adapters, search pipeline) live in `@xynolog/sdk` and are re-exported from here for convenience.

### API Integration

Data fetching and caching are an SDK concern. The SDK exposes an RxJS
read-through cache (stale-while-revalidate); react-ui consumes it as live
queries via `useObservable()`. Reads come from `client.browse.*(...)`
observables; writes go through the typed namespaces (`client.mark.*`,
`client.bind.*`, etc.).

```tsx
import { useXynolog, useObservable } from '@xynolog/react-ui';
import { readyValue } from '@xynolog/sdk';

function Example() {
  const client = useObservable(useXynolog().activeSession$)?.client;

  // Read: live query over the read-through cache. Emissions are
  // CacheState<ResourceList>; readyValue projects out the ready envelope.
  const state = useObservable(client?.browse.resources({ limit: 10 }));
  const resources = state && readyValue(state)?.resources; // undefined until ready

  // Write: typed namespace call (cache invalidation is handled by the SDK)
  const archive = (rUri: ResourceId) => client?.mark.archive(rUri);
}
```

See [API-INTEGRATION.md](https://github.com/xynolog/docs/blob/main/builder/react-ui/API-INTEGRATION.md) for details.

### Testing

Comprehensive test utilities included:

```tsx
import { renderWithProviders, screen } from '@xynolog/react-ui/test-utils';

it('should render component', () => {
  renderWithProviders(<Toolbar context="simple" activePanel={null} />);
  expect(screen.getByLabelText('Toolbar.settings')).toBeInTheDocument();
});
```

See [TESTING.md](https://github.com/xynolog/docs/blob/main/builder/react-ui/TESTING.md) for details.

## Documentation

- [SESSION.md](https://github.com/xynolog/docs/blob/main/builder/react-ui/SESSION.md) - Provider Pattern and manager interfaces
- [INTERNATIONALIZATION.md](https://github.com/xynolog/docs/blob/main/builder/react-ui/INTERNATIONALIZATION.md) - Translation approach
- [TESTING.md](https://github.com/xynolog/docs/blob/main/builder/react-ui/TESTING.md) - Testing utilities and patterns
- [API-INTEGRATION.md](https://github.com/xynolog/docs/blob/main/builder/react-ui/API-INTEGRATION.md) - Working with the Xynolog API
- [EVENTS.md](https://github.com/xynolog/docs/blob/main/builder/react-ui/EVENTS.md) - Subscribing and emitting from React, and reading the wire log
- [COMPONENTS.md](https://github.com/xynolog/docs/blob/main/builder/react-ui/COMPONENTS.md) - Component library reference
- [navigation-components.md](https://github.com/xynolog/docs/blob/main/builder/react-ui/navigation-components.md) - Navigation components (CollapsibleResourceNavigation, SimpleNavigation, NavigationMenu, ObservableLink)
- [modal-components.md](https://github.com/xynolog/docs/blob/main/builder/react-ui/modal-components.md) - Modal components (SearchModal)
- [ROUTING.md](https://github.com/xynolog/docs/blob/main/builder/react-ui/ROUTING.md) - Framework-agnostic routing
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - Design principles and decisions
- [STYLES.md](https://github.com/xynolog/docs/blob/main/builder/react-ui/STYLES.md) - Using the styles, design tokens and classes
- [ANNOTATIONS.md](https://github.com/xynolog/docs/blob/main/builder/react-ui/ANNOTATIONS.md) - Annotation system
- [ACCESSIBILITY.md](https://github.com/xynolog/docs/blob/main/builder/react-ui/ACCESSIBILITY.md) - Accessibility architecture and WCAG compliance

## Examples

### Vite Integration

```tsx
// src/App.tsx
import { TranslationProvider, XynologProvider, type TranslationManager } from '@xynolog/react-ui';

function useTranslationManager(): TranslationManager {
  return {
    t: (namespace, key) => `${namespace}.${key}` // Your i18n library
  };
}

function App({ children }: { children: React.ReactNode }) {
  const translationManager = useTranslationManager();

  // XynologProvider defaults to the canonical web setup (WebBrowserStorage +
  // an HTTP session factory). It reads the module-scoped XynologBrowser
  // singleton via getBrowser() — no client construction here. Sign-in flows
  // adopt the OAuth session onto the browser; browser.activeSession$ then
  // carries the live XynologClient.
  return (
    <TranslationProvider translationManager={translationManager}>
      <XynologProvider>{children}</XynologProvider>
    </TranslationProvider>
  );
}
```

The Xynolog Browser (`images/browser`, Vite + React Router) is the full reference: its
`images/browser/src/app/providers.tsx` mounts the whole provider stack, with a translation
manager built over react-i18next.

## License

[License information to be added]

## Related Packages

- [@xynolog/sdk](../sdk) - `XynologBrowser`, `XynologClient`, the read-through cache, and the state machinery. Its [**Developer Guide**](https://github.com/xynolog/docs/blob/main/builder/DEVELOPER-GUIDE.md) covers end-to-end use, including embedding this package's `ResourceViewer`.
- [@xynolog/core](../core) - Shared API types (`components`) generated from the OpenAPI spec
- [@xynolog/http-transport](../http-transport) - HTTP transport (`HttpTransport`, `HttpContentTransport`, `APIError`)
- [xynolog-browser](https://github.com/xynolog/images/tree/main/browser) - Reference implementation (Vite + React Router)

Working on the SDK itself? See [CONTRIBUTING.md](https://github.com/xynolog/sdk/blob/main/CONTRIBUTING.md).
