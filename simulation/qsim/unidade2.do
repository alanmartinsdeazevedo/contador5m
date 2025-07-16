onerror {quit -f}
vlib work
vlog -work work unidade2.vo
vlog -work work unidade2.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.Principal_vlg_vec_tst
vcd file -direction unidade2.msim.vcd
vcd add -internal Principal_vlg_vec_tst/*
vcd add -internal Principal_vlg_vec_tst/i1/*
add wave /*
run -all
