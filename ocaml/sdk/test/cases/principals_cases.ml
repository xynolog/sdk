(* Generated from protocol/specs/src/principals/cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type people_item = {
  why : string;
  domain : string;
  subject : string;
  did : string;
}

let people_item_json (r : people_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("domain", (fun s -> `String s) r.domain);
         Option.Some ("subject", (fun s -> `String s) r.subject);
         Option.Some ("did", (fun s -> `String s) r.did);
       ])

type t = {
  comment : string;
  person : string;
  people : people_item list;
  agent : string;
  agents : people_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some ("person", (fun s -> `String s) r.person);
         Option.Some
           ("people", (fun l -> `List (List.map people_item_json l)) r.people);
         Option.Some ("agent", (fun s -> `String s) r.agent);
         Option.Some
           ("agents", (fun l -> `List (List.map people_item_json l)) r.agents);
       ])

let table : t =
  ({
     comment =
       "How the gateway names the principals it acts for, under the knowledge \
        base's domain (its committed `site.domain`). Every principal is named \
        by the subject its issuer asserted, under the kind its token says it \
        is: an agent's account carries the claim `kind` holding `agent`, and \
        any other is a person's. A person is \
        `did:web:{domain}:users:{subject}` and an agent \
        `did:web:{domain}:agents:{subject}`, where the subject is the value of \
        the claim `identity.subjectClaim` names. Every part of a DID after the \
        domain is percent-encoded as ECMAScript's encodeURIComponent does: \
        each UTF-8 byte of a character other than A\226\128\147Z \
        a\226\128\147z 0\226\128\1479 - _ . ! ~ * ' ( ) becomes %XX in \
        uppercase hex; the domain is written as it is. Every implementation \
        that names these principals runs every case and fails on a difference, \
        and a running gateway is held to every case too.";
     person = "did:web:{domain}:users:{subject}";
     people =
       [
         ({
            why = "a subject of letters and digits is itself";
            domain = "example.org:test-kb";
            subject = "alice";
            did = "did:web:example.org:test-kb:users:alice";
          }
           : people_item);
         ({
            why = "a UUID subject is itself";
            domain = "example.org:test-kb";
            subject = "3f1c2e0a-9b7d-4c1e-8a2f-6d5b4c3a2e10";
            did =
              "did:web:example.org:test-kb:users:3f1c2e0a-9b7d-4c1e-8a2f-6d5b4c3a2e10";
          }
           : people_item);
         ({
            why = "an email-shaped subject encodes its @";
            domain = "example.org:test-kb";
            subject = "alice@example.org";
            did = "did:web:example.org:test-kb:users:alice%40example.org";
          }
           : people_item);
         ({
            why =
              "a colon in the subject is encoded, so it cannot split the DID";
            domain = "example.org:test-kb";
            subject = "google-oauth2:104859221";
            did = "did:web:example.org:test-kb:users:google-oauth2%3A104859221";
          }
           : people_item);
         ({
            why = "a slash in the subject is encoded";
            domain = "example.org:test-kb";
            subject = "tenant/alice";
            did = "did:web:example.org:test-kb:users:tenant%2Falice";
          }
           : people_item);
         ({
            why = "a space is %20";
            domain = "example.org:test-kb";
            subject = "Alice Smith";
            did = "did:web:example.org:test-kb:users:Alice%20Smith";
          }
           : people_item);
         ({
            why =
              "a character outside ASCII is its UTF-8 bytes, each \
               percent-encoded";
            domain = "example.org:test-kb";
            subject = "jos\195\169";
            did = "did:web:example.org:test-kb:users:jos%C3%A9";
          }
           : people_item);
         ({
            why =
              "the characters encodeURIComponent leaves alone stay as they are";
            domain = "example.org:test-kb";
            subject = "a-b_c.d!e~f*g'h(i)j";
            did = "did:web:example.org:test-kb:users:a-b_c.d!e~f*g'h(i)j";
          }
           : people_item);
       ];
     agent = "did:web:{domain}:agents:{subject}";
     agents =
       [
         ({
            why = "a subject of letters, digits and hyphens is itself";
            domain = "example.org:test-kb";
            subject = "xynolog-worker-local";
            did = "did:web:example.org:test-kb:agents:xynolog-worker-local";
          }
           : people_item);
         ({
            why =
              "a UUID subject, as an issuer names a client's own account, is \
               itself";
            domain = "example.org:test-kb";
            subject = "7c1f3d2a-5b6e-4f80-9a1b-2c3d4e5f6a7b";
            did =
              "did:web:example.org:test-kb:agents:7c1f3d2a-5b6e-4f80-9a1b-2c3d4e5f6a7b";
          }
           : people_item);
         ({
            why =
              "a colon in the subject is encoded, so it cannot split the DID";
            domain = "example.org:test-kb";
            subject = "service-account:worker";
            did = "did:web:example.org:test-kb:agents:service-account%3Aworker";
          }
           : people_item);
         ({
            why = "an email-shaped subject encodes its @";
            domain = "example.org:test-kb";
            subject = "worker@example.org";
            did = "did:web:example.org:test-kb:agents:worker%40example.org";
          }
           : people_item);
         ({
            why = "a slash in the subject is encoded";
            domain = "example.org:test-kb";
            subject = "tenant/worker";
            did = "did:web:example.org:test-kb:agents:tenant%2Fworker";
          }
           : people_item);
       ];
   }
    : t)
