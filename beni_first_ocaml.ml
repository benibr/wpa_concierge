open Sys

(* iwlist scan 
 *
 *)
let iwlist_scan = 
  Logs.debug (fun m -> m "scanning for available networks");
  let lines = ref [] in
  let iwconfig_chan = Unix.open_process_in "iwlist scan 2>/dev/null" in
  try
  while true; do
    lines := input_line iwconfig_chan :: !lines
  done; !lines
  with End_of_file ->
  close_in iwconfig_chan;
  List.rev !lines ;;

(* list_file
 * opens a file, read it line by line and returns the content as a list
 *)
let list_file file =
  Logs.debug (fun m -> m "reading file %s" file);
  let lines = ref [] in
  let read_chan = open_in file in
  try
  while true; do
    lines := input_line read_chan :: !lines
  done; !lines
  with End_of_file ->
  close_in read_chan;
  List.rev !lines ;;

let find_config =
  Logs.info (fun m -> m "not implemented yet")

let write_config network file =
  Logs.info (fun m -> m "not implemented yet")

(* main loop *)
let main () =
  let conf = list_file "/home/benibr/Workspace/marakkesh/beni_first_ocaml/test" in
  List.iter print_endline conf

let () = main ()
