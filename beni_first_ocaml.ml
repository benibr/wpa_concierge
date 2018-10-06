open Sys

(* network device handling *)

(* iwlist scan 
 *
 *)
let find_interface = 
  let interface = "wlan0" in
  Logs.debug (fun m -> m "found the following wlan interface %s" interface);
  interface


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


(* Configfile handling *)

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

let find_configfile interface = 
  let default = "./test" in
  let path = String.concat "" [ "/etc/wpa_supplicant/wpa_supplicant-"; interface; ".conf" ] in
  if Sys.file_exists path then
    Logs.debug (fun m -> m "found configfile for interface %s %s" interface path);
  let path = String.concat "" [ "/etc/wpa_supplicant-"; interface; ".conf" ] in
  if Sys.file_exists path then
    Logs.debug (fun m -> m "found configfile for interface %s %s" interface path);
  default

let write_config network file =
  Logs.debug (fun m -> m "appending to file %s" file);
  let write_chan = open_out_gen [Open_append] 0o664 file in
  output_string write_chan "\n";
  List.iter (output_string write_chan) network;
  close_out write_chan

let example_net = [ "network={\n"; "\tssid=\"karlsruhe.freifunk.net\"\n"; "\tkey_mgmt=NONE\n"; "\tauth_alg=OPEN\n"; "}\n"]

(* main loop *)

let main () =
  let interface = find_interface in
  let configfile = find_configfile interface in
  write_config example_net configfile;
  let config = list_file configfile in
  List.iter print_endline config

let () = main ()
