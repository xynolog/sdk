(* What of Protocol's client surface (specs/src/client/surface.json) each SDK
   lacks: an item an SDK does not have, with why, or one it is still to have,
   with what is to be built. An item named nowhere here is one every SDK has.
   coverage_census.exe holds every item named here to the pinned Protocol's
   surface. *)

open Xynolog_codegen
open Coverage_sdk

(* An item of the surface, by the names the table gives it. *)
type item =
  (* A module, by its name. *)
  | Module of string
  (* A member of a module: the module's name and the member's. *)
  | Module_member of string * string
  (* A member of what a worker is handed: what is handed, and the member. *)
  | Worker_member of string * string
  (* A member of a state unit: the unit, and the member. *)
  | State_unit_member of string * string
  (* A member of the typed bus a client hands out as `wire`. *)
  | Wire_member of string

type lack =
  (* The SDK does not have the item, with why. *)
  | Absent of string
  (* The SDK is still to have the item, with what is to be built. *)
  | Not_yet_reached of string

(* Each item some SDK lacks, with each SDK that lacks it. *)
let lacking : (item * (Coverage_sdk.t * lack) list) list =
  [
    ( Module_member ("annotations", "textPositionSelector"),
      [
        ( Python,
          Absent
            "TypeScript's alone: the selectors react-ui's viewer draws by. A \
             reader of a selector in another SDK reads the selector itself." );
        ( Rust,
          Absent
            "TypeScript's alone: the selectors react-ui's viewer draws by. A \
             reader of a selector in another SDK reads the selector itself." );
        ( Go,
          Absent
            "TypeScript's alone: the selectors react-ui's viewer draws by. A \
             reader of a selector in another SDK reads the selector itself." );
        ( Kotlin,
          Absent
            "TypeScript's alone: the selectors react-ui's viewer draws by. A \
             reader of a selector in another SDK reads the selector itself." );
      ] );
    ( Module_member ("annotations", "svgSelector"),
      [
        ( Python,
          Absent
            "TypeScript's alone: the selectors react-ui's viewer draws by. A \
             reader of a selector in another SDK reads the selector itself." );
        ( Rust,
          Absent
            "TypeScript's alone: the selectors react-ui's viewer draws by. A \
             reader of a selector in another SDK reads the selector itself." );
        ( Go,
          Absent
            "TypeScript's alone: the selectors react-ui's viewer draws by. A \
             reader of a selector in another SDK reads the selector itself." );
        ( Kotlin,
          Absent
            "TypeScript's alone: the selectors react-ui's viewer draws by. A \
             reader of a selector in another SDK reads the selector itself." );
      ] );
    ( Module_member ("annotations", "fragmentSelector"),
      [
        ( Python,
          Absent
            "TypeScript's alone: the selectors react-ui's viewer draws by. A \
             reader of a selector in another SDK reads the selector itself." );
        ( Rust,
          Absent
            "TypeScript's alone: the selectors react-ui's viewer draws by. A \
             reader of a selector in another SDK reads the selector itself." );
        ( Go,
          Absent
            "TypeScript's alone: the selectors react-ui's viewer draws by. A \
             reader of a selector in another SDK reads the selector itself." );
        ( Kotlin,
          Absent
            "TypeScript's alone: the selectors react-ui's viewer draws by. A \
             reader of a selector in another SDK reads the selector itself." );
      ] );
    ( Module_member ("annotations", "MatchQuality"),
      [
        ( Typescript,
          Absent
            "TypeScript states it inline, as ReconciledSpan's matchQuality, \
             and names no type for it." );
      ] );
    ( Module_member ("annotations", "SpanRefusedError"),
      [
        ( Rust,
          Absent
            "Rust refuses a span with errors::SpanRefusal, which is itself an \
             error." );
        ( Kotlin,
          Absent
            "Kotlin's is xynolog.errors.SpanRefusedError: a XynologError, and \
             that family is sealed, so every member of it is in \
             xynolog.errors." );
      ] );
    ( Module_member ("annotations", "SpanRefusal"),
      [
        ( Typescript,
          Absent "TypeScript's is with @xynolog/core's other error codes." );
        ( Rust,
          Absent
            "Rust's is errors::SpanRefusal, which is itself the error a \
             refused span is." );
        ( Go,
          Absent
            "Go's is api.SpanRefusal, generated with the other error codes." );
        ( Csharp,
          Absent "C# reports the shared refusal code on SpanRefusedError." );
        ( Kotlin,
          Absent
            "Kotlin's is xynolog.errors.SpanRefusal, generated with the other \
             error codes." );
      ] );
    ( Module_member ("annotations", "Spanned"),
      [
        ( Typescript,
          Absent
            "Rust's alone: its annotation_of_span takes a text or a PDF as one \
             enum, where the others take a PDF's anchored text beside the \
             text." );
        ( Python,
          Absent
            "Rust's alone: its annotation_of_span takes a text or a PDF as one \
             enum, where the others take a PDF's anchored text beside the \
             text." );
        ( Go,
          Absent
            "Rust's alone: its annotation_of_span takes a text or a PDF as one \
             enum, where the others take a PDF's anchored text beside the \
             text." );
        ( Kotlin,
          Absent
            "Rust's alone: its annotation_of_span takes a text or a PDF as one \
             enum, where Kotlin's annotationOfSpan is overloaded for each." );
      ] );
    ( Module_member ("annotations", "OfSpan"),
      [
        ( Typescript,
          Absent
            "Go's alone: Go's builder takes what it builds from as one struct, \
             which it names, where TypeScript's states the object's type \
             inline." );
        ( Python,
          Absent
            "Go's alone: Go's builder takes what it builds from as one struct, \
             where Python's takes each as an argument." );
        ( Rust,
          Absent
            "Go's alone: Go's builder takes what it builds from as one struct, \
             where Rust's takes each as an argument." );
        ( Haskell,
          Absent
            "The Haskell builder takes its typed inputs as arguments, without \
             an input record." );
        ( Kotlin,
          Absent
            "Go's alone: Go's builder takes what it builds from as one struct, \
             where Kotlin's takes each as an argument." );
        ( Ocaml,
          Absent "The OCaml builder takes its inputs as labeled arguments." );
      ] );
    ( Module_member ("annotations", "OfResource"),
      [
        ( Typescript,
          Absent
            "Go's alone: Go's builder takes what it builds from as one struct, \
             which it names, where TypeScript's states the object's type \
             inline." );
        ( Python,
          Absent
            "Go's alone: Go's builder takes what it builds from as one struct, \
             where Python's takes each as an argument." );
        ( Rust,
          Absent
            "Go's alone: Go's builder takes what it builds from as one struct, \
             where Rust's takes each as an argument." );
        ( Haskell,
          Absent
            "The Haskell builder takes its typed inputs as arguments, without \
             an input record." );
        ( Kotlin,
          Absent
            "Go's alone: Go's builder takes what it builds from as one struct, \
             where Kotlin's takes each as an argument." );
        ( Ocaml,
          Absent "The OCaml builder takes its inputs as labeled arguments." );
      ] );
    ( Module_member ("tokens", "renewalDelay"),
      [
        ( Typescript,
          Absent
            "TypeScript's session reads when to renew from the token itself \
             (refreshDelayMs), and hands out no reckoning from a lifetime and \
             what is left of it." );
      ] );
    ( Module_member ("bus", "unsubscribed"),
      [
        ( Typescript,
          Absent
            "TypeScript makes the refusal where it refuses, and hands out no \
             maker of it." );
        ( Ocaml,
          Absent
            "Subscription.request returns the Unsubscribed constructor \
             directly." );
      ] );
    ( Module_member ("bus", "persistedEventTypes"),
      [
        ( Rust,
          Absent
            "Rust tells the record's events by their channels' type, \
             `Recorded`." );
      ] );
    ( Module_member ("bus", "FrameRefusalReason"),
      [
        ( Typescript,
          Absent
            "TypeScript's refusal states its reason as one of two strings, \
             `lacks` and `malformed`." );
        ( Python,
          Absent
            "Python's refusal states its reason as a Literal of the two \
             spellings, `lacks` and `malformed`." );
      ] );
    ( Module_member ("bus", "Carried"),
      [
        ( Typescript,
          Absent
            "TypeScript's transport delivers a refusal where a frame's payload \
             would be, on the frame's envelope (`BusFrame<P | FrameRefusal>`), \
             as its client's bus does." );
        ( Python,
          Absent
            "Python's transport delivers a frame or its refusal as the union \
             `Frame | FrameRefusal`." );
        ( Rust,
          Absent
            "Rust's transport delivers a frame or its refusal as a \
             `Result<Frame, FrameRefusal>`." );
        ( Go,
          Absent
            "Go's transport delivers a frame or, as its error, its refusal \
             (`iter.Seq2[Frame, error]`)." );
        ( Ocaml,
          Absent
            "Bus.frames delivers the standard OCaml result of a frame or its \
             refusal." );
      ] );
    ( Module_member ("registry", "newXynologBrowser"),
      [
        ( Typescript,
          Absent "TypeScript makes one with `new XynologBrowser(config)`." );
        ( Python,
          Absent
            "Python makes one with `XynologBrowser(config)`, held with `async \
             with`." );
        (Rust, Absent "Rust makes one with `XynologBrowser::new(config)`.");
        ( Csharp,
          Absent "C# makes one with the public XynologBrowser constructor." );
        ( Kotlin,
          Absent
            "Kotlin makes one with `XynologBrowser(config)`, closed with \
             `close()`." );
      ] );
    ( Module_member ("registry", "SignedIn"),
      [
        ( Typescript,
          Absent
            "TypeScript's `completeSignIn` lands a sign-in itself, and names \
             no type for what the registry is handed." );
      ] );
    ( Module_member ("registry", "Expected"),
      [
        ( Typescript,
          Absent
            "TypeScript states what a person believed inside `SignInOutcome`, \
             and names no type for it." );
      ] );
    ( Module_member ("registry", "KbReadKind"),
      [
        ( Typescript,
          Absent "TypeScript's verdict is a union told apart by its `kind`." );
        (Rust, Absent "Rust's verdict is an enum, whose variants are its kinds.");
        (Ocaml, Absent "OCaml represents the read verdict as a variant.");
      ] );
    ( Module_member ("registry", "TabVerdict"),
      [
        ( Typescript,
          Absent "TypeScript's check is a union told apart by its `verdict`." );
        ( Rust,
          Absent "Rust's check is an enum, whose variants are its verdicts." );
        (Ocaml, Absent "OCaml represents the tab check as a variant.");
      ] );
    ( Module_member ("registry", "beginSignIn"),
      [ (Typescript, Absent "TypeScript's is a method of `XynologBrowser`.") ]
    );
    ( Module_member ("registry", "completeSignIn"),
      [ (Typescript, Absent "TypeScript's is a method of `XynologBrowser`.") ]
    );
    ( Module_member ("signInStore", "stateDir"),
      [
        ( Csharp,
          Absent
            "C#'s state home is SignInStore.StateDirectory, a static member of \
             the store, which takes the system's name as text." );
      ] );
    ( Module_member ("signInStore", "System"),
      [
        ( Csharp,
          Absent
            "C#'s SignInStore.StateDirectory takes the system's name as text."
        );
        ( Haskell,
          Absent "Haskell's stateDirectory takes the system's name as text." );
      ] );
    ( Module_member ("signInStore", "thisSystem"),
      [
        ( Typescript,
          Absent
            "TypeScript reads nothing of the system it runs on: its caller \
             says which it is." );
        (Rust, Absent "Rust's is a function of the type, System::of_this_build.");
        (Csharp, Absent "C#'s caller names the system it runs on.");
        (Ocaml, Absent "The OCaml caller supplies the platform.");
        (Swift, Absent "Swift's caller says which system it runs on.");
      ] );
    ( Module_member ("signInStore", "fileName"),
      [
        ( Typescript,
          Absent
            "TypeScript's is SIGN_IN_STORE_FILE, generated into @xynolog/core, \
             which the store hands to its caller's files." );
        ( Csharp,
          Absent
            "C#'s store is made in a directory its caller gives, and names the \
             file there itself." );
        ( Ocaml,
          Absent
            "The OCaml store names tokens.json inside the directory supplied \
             by its caller." );
        (Swift, Absent "Swift's store is made at a path its caller gives.");
      ] );
    ( Module_member ("signInStore", "SignInFiles"),
      [
        ( Python,
          Absent
            "Python reads, writes and locks the file itself, through its \
             standard library and ctypes." );
        ( Rust,
          Absent
            "Rust reads, writes and locks the file itself, through its \
             standard library." );
        ( Go,
          Absent
            "Go reads, writes and locks the file itself, through its standard \
             library." );
        ( Csharp,
          Absent
            "C# reads, writes and locks the file itself, through .NET and the \
             C library." );
        ( Haskell,
          Absent
            "Haskell reads, writes and locks the file itself, through its \
             directory and file libraries and the C library." );
        ( Kotlin,
          Absent
            "Kotlin reads, writes and locks the file itself, through the JDK \
             and its foreign-function interface." );
        ( Ocaml,
          Absent
            "The OCaml store uses Unix file operations and a native flock \
             binding." );
        ( Swift,
          Absent
            "Swift reads, writes and locks the file itself, through Foundation \
             and the C library." );
      ] );
    ( Module "keptSignIn",
      [
        ( Ocaml,
          Not_yet_reached
            "OCaml keeps a sign-in only in the launcher's store \
             (Sign_in_store), with OAuth's device grant beside it: it is to \
             have a SignInKept a session holds and renews wherever it is kept, \
             a MemorySignIn, and signInDevice, sessionFromKept, renewKept and \
             signOut over one." );
      ] );
    ( Module_member ("keptSignIn", "MemorySignIn"),
      [
        ( Haskell,
          Absent
            "Haskell makes one with newMemorySignIn, a KeptSignIn held in \
             memory, and names no type for it." );
      ] );
    ( Module_member ("keptSignIn", "signInDevice"),
      [
        ( Typescript,
          Absent
            "TypeScript's is XynologSession.signInDevice, a static method of \
             the session." );
        ( Csharp,
          Absent "C#'s is Issuer.SignInDeviceAsync, a method of the issuer." );
      ] );
    ( Module_member ("keptSignIn", "sessionFromKept"),
      [
        ( Typescript,
          Absent
            "TypeScript's is XynologSession.fromKept, a static method of the \
             session." );
        ( Csharp,
          Absent
            "C#'s is XynologSession.FromKeptAsync, a static method of the \
             session." );
      ] );
    ( Module_member ("keptSignIn", "renewKept"),
      [
        (Go, Absent "Go's is Issuer.RenewKept, a method of the issuer.");
        (Csharp, Absent "C#'s is Issuer.RenewAsync, a method of the issuer.");
      ] );
    ( Module_member ("keptSignIn", "signOut"),
      [
        (Csharp, Absent "C#'s is Issuer.SignOutAsync, a method of the issuer.");
      ] );
    ( Module_member ("discovery", "discoveryInterval"),
      [
        ( Typescript,
          Absent
            "TypeScript's subscription is given its interval by its caller." );
        ( Haskell,
          Absent
            "DiscoveryOptions requires its interval from the caller; \
             Xynolog.Timing supplies the protocol default." );
      ] );
    ( Module_member ("discovery", "Absent"),
      [
        ( Typescript,
          Absent "TypeScript's state is a union told apart by its `kind`." );
        (Rust, Absent "Rust's state is an enum, whose variants are its kinds.");
        ( Haskell,
          Absent
            "Haskell represents this case as an algebraic data constructor of \
             DiscoveryState or DiscoveryRead, rather than a separate type." );
        (Ocaml, Absent "OCaml represents absence as a variant constructor.");
      ] );
    ( Module_member ("discovery", "Managed"),
      [
        ( Typescript,
          Absent "TypeScript's state is a union told apart by its `kind`." );
        (Rust, Absent "Rust's state is an enum, whose variants are its kinds.");
        ( Haskell,
          Absent
            "Haskell represents this case as an algebraic data constructor of \
             DiscoveryState or DiscoveryRead, rather than a separate type." );
        ( Ocaml,
          Absent "OCaml represents a managed document as a variant constructor."
        );
      ] );
    ( Module_member ("discovery", "Unchanged"),
      [
        ( Typescript,
          Absent "TypeScript's read is a union told apart by its `kind`." );
        (Rust, Absent "Rust's read is an enum, whose variants are its kinds.");
        ( Haskell,
          Absent
            "Haskell represents this case as an algebraic data constructor of \
             DiscoveryState or DiscoveryRead, rather than a separate type." );
        ( Ocaml,
          Absent "OCaml represents an unchanged read as a variant constructor."
        );
      ] );
    ( Module_member ("testing", "Respond"),
      [
        ( Typescript,
          Absent
            "TypeScript's spec states how the gateway answers as a function it \
             names no type for." );
      ] );
    ( Module_member ("testing", "TestSession"),
      [
        ( Typescript,
          Absent
            "TypeScript gives the session, and what it was built over, as an \
             object it names no type for." );
      ] );
    ( Module_member ("testing", "ScriptedSessions"),
      [
        ( Typescript,
          Absent
            "TypeScript's testing module has no factory of scripted sessions."
        );
      ] );
    ( Module_member ("testing", "Renewal"),
      [
        ( Typescript,
          Absent
            "TypeScript's testing module has no factory of scripted sessions."
        );
        ( Python,
          Absent
            "Python's scripted sessions are given what a renewal gives as it \
             is: a token, None, or the SignInError it raises, which Python \
             makes with the issuer's status." );
        ( Rust,
          Absent
            "Rust's scripted sessions are given what a renewal gives as it is: \
             a token, none, or the SignInError it fails with, which Rust makes \
             with the issuer's status." );
        ( Haskell,
          Absent
            "The scripted factory queues Either SignInError (Maybe Text): the \
             renewal result itself, with no separate wrapper." );
        ( Kotlin,
          Absent
            "Kotlin's scripted sessions are given a token (queueRenewals) or \
             the SignInError a renewal fails with (failRenewal), which Kotlin \
             makes with the issuer's status." );
      ] );
    ( Module_member ("testing", "SharedStorage"),
      [
        ( Typescript,
          Absent
            "TypeScript's testing module has no storage several contexts share."
        );
      ] );
    ( Module_member ("refusals", "faultSaid"),
      [
        ( Typescript,
          Absent
            "TypeScript's transport finds a body's fault with faultOf and says \
             it with said." );
        ( Python,
          Absent
            "Its HTTP transport is in the SDK's own package, and reads its \
             answers by the table there." );
        ( Go,
          Absent
            "Its HTTP transport is in the SDK's own module, and reads its \
             answers by the table there." );
        (Csharp, Absent "Its HTTP transport is in the SDK's own assembly.");
        ( Haskell,
          Absent
            "Its HTTP transport is in the same Cabal package and reads \
             refusals internally." );
        ( Kotlin,
          Absent
            "Its HTTP transport is in the SDK's own module, and reads its \
             answers by the table there." );
        (Ocaml, Absent "OCaml renders the shared fault with said.");
        (Swift, Absent "Its HTTP transport is in the SDK's own package.");
      ] );
    ( Module_member ("refusals", "faultOf"),
      [
        ( Python,
          Absent
            "Its HTTP transport is in the SDK's own package, and reads its \
             answers by the table there." );
        ( Rust,
          Absent
            "Rust's transport crate is told a body's fault in words \
             (fault_said), and a refused frame's as its refusal \
             (FrameRefusal::of)." );
        ( Go,
          Absent
            "Its HTTP transport is in the SDK's own module, and reads its \
             answers by the table there." );
        (Csharp, Absent "Its HTTP transport is in the SDK's own assembly.");
        ( Haskell,
          Absent
            "Its HTTP transport is in the same Cabal package and reads \
             refusals internally." );
        ( Kotlin,
          Absent
            "Its HTTP transport is in the SDK's own module, and reads its \
             answers by the table there." );
        (Swift, Absent "Its HTTP transport is in the SDK's own package.");
      ] );
    ( Module_member ("refusals", "said"),
      [
        ( Python,
          Absent
            "Its HTTP transport is in the SDK's own package, and reads its \
             answers by the table there." );
        ( Rust,
          Absent
            "Rust's transport crate is told a body's fault in words \
             (fault_said), and a refused frame's as its refusal \
             (FrameRefusal::of)." );
        ( Go,
          Absent
            "Its HTTP transport is in the SDK's own module, and reads its \
             answers by the table there." );
        (Csharp, Absent "Its HTTP transport is in the SDK's own assembly.");
        ( Haskell,
          Absent
            "Its HTTP transport is in the same Cabal package and reads \
             refusals internally." );
        ( Kotlin,
          Absent
            "Its HTTP transport is in the SDK's own module, and reads its \
             answers by the table there." );
        (Swift, Absent "Its HTTP transport is in the SDK's own package.");
      ] );
    ( Module_member ("refusals", "Fault"),
      [
        ( Python,
          Absent
            "Its HTTP transport is in the SDK's own package, and reads its \
             answers by the table there." );
        ( Rust,
          Absent
            "Rust's transport crate is told a body's fault in words \
             (fault_said), and a refused frame's as its refusal \
             (FrameRefusal::of)." );
        ( Go,
          Absent
            "Its HTTP transport is in the SDK's own module, and reads its \
             answers by the table there." );
        (Csharp, Absent "Its HTTP transport is in the SDK's own assembly.");
        ( Kotlin,
          Absent
            "Its HTTP transport is in the SDK's own module, and reads its \
             answers by the table there." );
        (Swift, Absent "Its HTTP transport is in the SDK's own package.");
      ] );
    ( Worker_member ("claims", "next"),
      [
        ( Typescript,
          Absent
            "The claims are an rxjs Observable, read by subscribing to them: \
             `subscribe` is rxjs's own, and the SDK declares no member for it."
        );
        ( Python,
          Absent
            "The claims are an asynchronous iterator, read with `async for`: \
             `__anext__` is the language's protocol." );
        ( Swift,
          Absent
            "Claims is an AsyncSequence. Its iterator implements Swift's \
             next()." );
      ] );
    ( Worker_member ("claims", "refused"),
      [
        ( Python,
          Absent
            "The claims are iterated with `async for`, and an exception raised \
             into the loop would end it; a claim that was refused does not end \
             a worker's claims, so it is handed out where a job would be, as a \
             `ClaimRefusal`." );
        ( Rust,
          Absent
            "`next` answers a `Result`, and a claim that was refused is its \
             `Err`: it is handed out where a job would be." );
        ( Go,
          Absent
            "The claims are ranged over as pairs of a job and an error, and a \
             claim that was refused is the error, a `*ClaimRefusal`: it is \
             handed out where a job would be." );
      ] );
    ( Worker_member ("heldJob", "settled"),
      [
        ( Rust,
          Absent
            "`complete`, `fail` and `cancel` take the job by value: a job its \
             holder has settled is gone, and nothing is left to ask it." );
      ] );
    ( State_unit_member ("cache", "keptFetching"),
      [
        ( Typescript,
          Absent
            "TypeScript's is PersistableCache.fetching, which the SDK does not \
             export: the client that makes a cache reads it as its disposal \
             seals the stream's places." );
        ( Rust,
          Absent
            "Rust's is pub(crate), the fetching of the persistence a cache \
             reports: the client reads it as its close seals the stream's \
             places." );
        ( Go,
          Absent
            "Go's is unexported: the client reads it as its Close seals the \
             stream's places." );
        ( Csharp,
          Absent
            "C#'s is internal (Cache.Fetching): its client's CachePersistence \
             reads it as it seals the stream's places." );
        ( Haskell,
          Absent
            "Haskell's is in the internal library \
             (Xynolog.Internal.Cache.fetching): the client reads it as its \
             close seals the stream's places." );
        ( Kotlin,
          Absent
            "Kotlin's is internal (keptFetchInFlight): the client reads it as \
             its close seals the stream's places." );
        ( Ocaml,
          Absent
            "OCaml's client keeps no stream places beside its caches, so its \
             close asks no cache whether it is fetching." );
        ( Swift,
          Absent
            "A Swift cache counts each fetch in the work under way of what \
             keeps its values, given when it is made, and its client reads \
             that count." );
      ] );
    ( State_unit_member ("cache", "attach"),
      [
        ( Typescript,
          Absent
            "TypeScript's client gives a cache what keeps its values through \
             createPersistableCache, which the SDK does not export." );
        ( Rust,
          Absent
            "Rust's is pub(crate): the client that makes a cache gives it what \
             keeps its values." );
        ( Go,
          Absent
            "Go's is unexported: the client that makes a cache gives it what \
             keeps its values." );
        ( Csharp,
          Absent
            "A C# cache keeps nothing itself: its client's CachePersistence \
             keeps what its caches hold." );
        ( Haskell,
          Absent
            "A Haskell cache is given what keeps its values when it is made, \
             in its CacheOptions." );
        ( Kotlin,
          Absent
            "Kotlin's is internal: the client that makes a cache gives it what \
             keeps its values." );
        ( Ocaml,
          Absent
            "An OCaml cache is given what keeps its values when it is made, as \
             its restore and save." );
        ( Swift,
          Absent "A Swift cache is given what keeps its values when it is made."
        );
      ] );
    ( State_unit_member ("cache", "query"),
      [
        ( Typescript,
          Absent
            "This SDK returns its live observation directly from observe; \
             Haskell also constructs a composable Query value, whose reader is \
             scoped by watch." );
        ( Python,
          Absent
            "This SDK returns its live observation directly from observe; \
             Haskell also constructs a composable Query value, whose reader is \
             scoped by watch." );
        ( Rust,
          Absent
            "This SDK returns its live observation directly from observe; \
             Haskell also constructs a composable Query value, whose reader is \
             scoped by watch." );
        ( Go,
          Absent
            "This SDK returns its live observation directly from observe; \
             Haskell also constructs a composable Query value, whose reader is \
             scoped by watch." );
        ( Csharp,
          Absent
            "This SDK returns its live observation directly from observe; \
             Haskell also constructs a composable Query value, whose reader is \
             scoped by watch." );
        ( Kotlin,
          Absent
            "This SDK returns its live observation directly from observe; \
             Haskell also constructs a composable Query value, whose reader is \
             scoped by watch." );
        ( Ocaml,
          Absent
            "The OCaml cache observes a key directly; Client.query provides \
             the public client query." );
        ( Swift,
          Absent
            "This SDK returns its live observation directly from observe; \
             Haskell also constructs a composable Query value, whose reader is \
             scoped by watch." );
      ] );
    ( State_unit_member ("session", "renewer"),
      [
        ( Typescript,
          Absent
            "A TypeScript transport is handed a closure that calls the \
             session's `refresh` with the token refused, and a closure can \
             name the session it is built before. Rust's ownership forbids a \
             transport and its session holding each other, so Rust hands its \
             transport a weak handle instead." );
        ( Python,
          Absent
            "A Python transport is handed a closure that calls the session's \
             `refresh` with the token refused (`refresher`), and a closure can \
             name the session it is built before. Rust's ownership forbids a \
             transport and its session holding each other, so Rust hands its \
             transport a weak handle instead." );
        ( Go,
          Absent
            "A Go transport is handed a TokenRefresher that asks the session's \
             `Refresh` with the token refused (SessionFromKept's \
             `refreshedBy`), and a closure can name the session it is built \
             before. Rust's ownership forbids a transport and its session \
             holding each other, so Rust hands its transport a weak handle \
             instead." );
        ( Csharp,
          Absent
            "The transport takes a callback bound to the kept session when the \
             transport is constructed." );
        ( Haskell,
          Absent
            "The HTTP transport calls the session refresh closure with the \
             refused token; it needs no separate weak renewal handle." );
        ( Kotlin,
          Absent
            "A Kotlin transport is handed a refresher that asks the session to \
             renew the token a request was refused with (sessionFromKept's), \
             and a closure can name the session it is built before. Rust's \
             ownership forbids a transport and its session holding each other, \
             so Rust hands its transport a weak handle instead." );
        ( Ocaml,
          Absent "The client transport uses the credential session directly." );
        ( Swift,
          Absent
            "The transport uses a closure that calls the session's `refresh` \
             with the token refused through a weak session reference." );
      ] );
    ( Wire_member "framesOf",
      [
        ( Typescript,
          Absent
            "`frames` is overloaded: a channel of a resource's scope is read \
             as `frames(channel, resourceId)`. Rust, which has no overloading, \
             names that read apart." );
        ( Python,
          Absent
            "`frames` is overloaded (`typing.overload`): a channel of a \
             resource's scope is read as `frames(channel, resource)`. Rust, \
             which has no overloading, names that read apart." );
        ( Csharp,
          Absent
            "C# uses generated channel and operation values, and Frames \
             accepts a resource scope." );
        ( Haskell,
          Absent
            "Haskell passes typed channel/operation values and a ScopeArg to \
             the same functions." );
        ( Kotlin,
          Absent
            "`frames` is overloaded: a channel of a resource's scope \
             (`ScopedChannel`) is read as `frames(channel, resource)`. Rust, \
             which has no overloading, names that read apart." );
        ( Ocaml,
          Absent
            "Bus uses typed channel and operation values and exposes frames \
             through a subscription callback." );
        ( Swift,
          Absent
            "Swift uses typed channel and operation values; frames is \
             overloaded for a resource scope." );
      ] );
    ( Wire_member "emitOn",
      [
        ( Typescript,
          Absent
            "A TypeScript channel is a value, checked against the registry's \
             names, so a channel chosen at run time is emitted on with `emit`. \
             Rust's typed `emit` takes its channel as a type parameter, and a \
             channel named at run time needs a method of its own." );
        ( Python,
          Absent
            "A Python channel is a value (`Channel`), so a channel chosen at \
             run time is emitted on with `emit`. Rust's typed `emit` takes its \
             channel as a type parameter, and a channel named at run time \
             needs a method of its own." );
        ( Csharp,
          Absent
            "C# uses generated channel and operation values, and Frames \
             accepts a resource scope." );
        ( Haskell,
          Absent
            "Haskell passes typed channel/operation values and a ScopeArg to \
             the same functions." );
        ( Kotlin,
          Absent
            "A Kotlin channel is a value (`Channel`), so a channel chosen at \
             run time is emitted on with `emit`. Rust's typed `emit` takes its \
             channel as a type parameter, and a channel named at run time \
             needs a method of its own." );
        ( Ocaml,
          Absent
            "Bus uses typed channel and operation values and exposes frames \
             through a subscription callback." );
        ( Swift,
          Absent
            "Swift uses typed channel and operation values; frames is \
             overloaded for a resource scope." );
      ] );
    ( Wire_member "framesOn",
      [
        ( Typescript,
          Absent
            "A TypeScript channel is a value, checked against the registry's \
             names, so a channel chosen at run time is read with `frames`. \
             Rust's typed `frames` takes its channel as a type parameter, and \
             a channel named at run time needs a method of its own." );
        ( Python,
          Absent
            "A Python channel is a value (`Channel`), so a channel chosen at \
             run time is read with `frames`. Rust's typed `frames` takes its \
             channel as a type parameter, and a channel named at run time \
             needs a method of its own." );
        ( Csharp,
          Absent
            "C# uses generated channel and operation values, and Frames \
             accepts a resource scope." );
        ( Haskell,
          Absent
            "Haskell passes typed channel/operation values and a ScopeArg to \
             the same functions." );
        ( Kotlin,
          Absent
            "A Kotlin channel is a value (`Channel`), so a channel chosen at \
             run time is read with `frames`. Rust's typed `frames` takes its \
             channel as a type parameter, and a channel named at run time \
             needs a method of its own." );
        ( Ocaml,
          Absent
            "Bus uses typed channel and operation values and exposes frames \
             through a subscription callback." );
        ( Swift,
          Absent
            "Swift uses typed channel and operation values; frames is \
             overloaded for a resource scope." );
      ] );
    ( Wire_member "requestOf",
      [
        ( Typescript,
          Absent
            "A TypeScript operation is a value, checked against the registry's \
             operations, so one chosen at run time is asked with `request`. \
             Rust's typed `request` takes its operation as a type parameter, \
             and an operation named at run time needs a method of its own." );
        ( Python,
          Absent
            "A Python operation is a value (`Operation`), so one chosen at run \
             time is asked with `request`. Rust's typed `request` takes its \
             operation as a type parameter, and an operation named at run time \
             needs a method of its own." );
        ( Csharp,
          Absent
            "C# uses generated channel and operation values, and Frames \
             accepts a resource scope." );
        ( Haskell,
          Absent
            "Haskell passes typed channel/operation values and a ScopeArg to \
             the same functions." );
        ( Kotlin,
          Absent
            "A Kotlin operation is a value (`Operation`), so one chosen at run \
             time is asked with `request`. Rust's typed `request` takes its \
             operation as a type parameter, and an operation named at run time \
             needs a method of its own." );
        ( Ocaml,
          Absent
            "Bus uses typed channel and operation values and exposes frames \
             through a subscription callback." );
        ( Swift,
          Absent
            "Swift uses typed channel and operation values; frames is \
             overloaded for a resource scope." );
      ] );
  ]
