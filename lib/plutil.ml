(*
 * Copyright (c) 2015 David Sheets <sheets@alum.mit.edu>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

open Process

let lint plist =
  let proc = run ~stdin:plist "plutil" [|"-lint"; "-s"; "-"|] in
  Exit.(match proc.Output.exit_status with
    | Exit 0 -> Result.Ok ()
    | Exit 1 -> Result.Error proc.Output.stdout
    | Exit _ | Kill _ | Stop _ ->
      Result.Error [to_string proc.Output.exit_status]
  )

let plutil_fun args plist =
  let buf = Buffer.create 1024 in
  try
    let lines = read_stdout ~stdin:plist "plutil" args in
    List.iter (fun line ->
      Buffer.add_string buf line;
      Buffer.add_char buf '\n'
    ) lines;
    let len = Buffer.length buf in
    let contents = if len > 0 then Buffer.sub buf 0 (len - 1) else "" in
    Result.Ok contents
  with Exit.Error { Exit.status } -> Result.Error (Exit.to_string status)

let to_xml1 = plutil_fun [|"-convert"; "xml1"; "-"; "-o"; "-"|]

let to_binary1 = plutil_fun [|"-convert"; "binary1"; "-"; "-o"; "-"|]

let to_json = plutil_fun [|"-convert"; "json"; "-"; "-o"; "-"|]

let to_json_pretty = plutil_fun [|"-convert"; "json"; "-"; "-r"; "-o"; "-"|]

let to_human = plutil_fun [|"-p"; "-"|]
