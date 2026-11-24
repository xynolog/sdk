(* Generated from protocol/specs/src/jobs/storage.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type stream = { name : string; subject_root : string }

let stream_json (r : stream) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("subjectRoot", (fun s -> `String s) r.subject_root);
       ])

type consumer = { durable_name : string }

let consumer_json (r : consumer) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("durableName", (fun s -> `String s) r.durable_name) ])

type bucket = { name : string; record : string }

let bucket_json (r : bucket) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("record", (fun s -> `String s) r.record);
       ])

type t = {
  comment : string;
  stream : stream;
  consumer : consumer;
  bucket : bucket;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some ("stream", stream_json r.stream);
         Option.Some ("consumer", consumer_json r.consumer);
         Option.Some ("bucket", bucket_json r.bucket);
       ])

let table : t =
  ({
     comment =
       "Where the job queue keeps its state on the broker: the names and \
        subjects every implementation of the queue must use, so that work \
        queued by one survives a switch to another. The queue is JetStream. A \
        job is published once, when it is created, on \
        `<subjectRoot>.<jobType>` into the work-queue stream `stream.name`, \
        which captures every subject under the root; the durable consumer \
        `consumer.durableName` delivers each message to the dispatcher that \
        holds it as the job's lease. The job itself lives in the KV bucket \
        `bucket.name`, one JobRecord per job keyed by the job's id, and every \
        change to a record is a compare-and-swap on its revision. The stream \
        is a work queue; the consumer acknowledges explicitly, delivers from \
        the start, and never gives a message up on its own count (the queue \
        decides retries); the bucket keeps one revision per key. The \
        dispatcher creates the stream, the consumer and the bucket when they \
        are missing and never updates them, so a changed setting takes effect \
        only on a broker that has not seen them.";
     stream = ({ name = "JOBS"; subject_root = "jobs" } : stream);
     consumer = ({ durable_name = "dispatcher-leases" } : consumer);
     bucket = ({ name = "jobs"; record = "JobRecord" } : bucket);
   }
    : t)
