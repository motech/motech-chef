name "swapfile1gb"
description "Role that creates a 1024mb swapfile"

run_list "swapfile"

override_attributes(
  "swapfile" => {
     "swap_size_megabytes" => "1024"
  }
)