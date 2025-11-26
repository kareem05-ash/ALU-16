transcript file logs.log
vlib work
vlog ALU.v TB_ALU.v
vsim -voptargs=+acc work.tb_alu
add wave *
run -all
#quit -sim