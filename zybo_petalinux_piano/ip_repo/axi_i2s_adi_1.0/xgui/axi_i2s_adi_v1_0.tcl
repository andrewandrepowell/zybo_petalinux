#Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
	set Page0 [ ipgui::add_page $IPINST  -name "Page 0" -layout vertical]
	set Component_Name [ ipgui::add_param  $IPINST  -parent  $Page0  -name Component_Name ]
	set tabgroup0 [ipgui::add_group $IPINST -parent $Page0 -name {DMA Configuration} -layout vertical]
	set C_HAS_RX [ipgui::add_param $IPINST -parent $tabgroup0 -name C_HAS_RX -widget comboBox]
	set C_HAS_TX [ipgui::add_param $IPINST -parent $tabgroup0 -name C_HAS_TX -widget comboBox]
	set C_NUM_CH [ipgui::add_param $IPINST -parent $tabgroup0 -name C_NUM_CH -widget comboBox]
	set C_DMA_TYPE [ipgui::add_param $IPINST -parent $tabgroup0 -name C_DMA_TYPE -widget comboBox]
	set tabgroup1 [ipgui::add_group $IPINST -parent $Page0 -name {I2S Configuration} -layout vertical]
	set C_BCLK_POL [ipgui::add_param $IPINST -parent $tabgroup1 -name C_BCLK_POL -widget comboBox]
	set C_LRCLK_POL [ipgui::add_param $IPINST -parent $tabgroup1 -name C_LRCLK_POL -widget comboBox]
}

proc update_PARAM_VALUE.C_HAS_RX { PARAM_VALUE.C_HAS_RX } {
	# Procedure called to update C_HAS_RX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_HAS_RX { PARAM_VALUE.C_HAS_RX } {
	# Procedure called to validate C_HAS_RX
	return true
}

proc update_PARAM_VALUE.C_HAS_TX { PARAM_VALUE.C_HAS_TX } {
	# Procedure called to update C_HAS_TX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_HAS_TX { PARAM_VALUE.C_HAS_TX } {
	# Procedure called to validate C_HAS_TX
	return true
}

proc update_PARAM_VALUE.C_NUM_CH { PARAM_VALUE.C_NUM_CH } {
	# Procedure called to update C_NUM_CH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_NUM_CH { PARAM_VALUE.C_NUM_CH } {
	# Procedure called to validate C_NUM_CH
	return true
}

proc update_PARAM_VALUE.C_DMA_TYPE { PARAM_VALUE.C_DMA_TYPE } {
	# Procedure called to update C_DMA_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DMA_TYPE { PARAM_VALUE.C_DMA_TYPE } {
	# Procedure called to validate C_DMA_TYPE
	return true
}

proc update_PARAM_VALUE.C_BCLK_POL { PARAM_VALUE.C_BCLK_POL } {
	# Procedure called to update C_BCLK_POL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_BCLK_POL { PARAM_VALUE.C_BCLK_POL } {
	# Procedure called to validate C_BCLK_POL
	return true
}

proc update_PARAM_VALUE.C_LRCLK_POL { PARAM_VALUE.C_LRCLK_POL } {
	# Procedure called to update C_LRCLK_POL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_LRCLK_POL { PARAM_VALUE.C_LRCLK_POL } {
	# Procedure called to validate C_LRCLK_POL
	return true
}


proc update_MODELPARAM_VALUE.C_LRCLK_POL { MODELPARAM_VALUE.C_LRCLK_POL PARAM_VALUE.C_LRCLK_POL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_LRCLK_POL}] ${MODELPARAM_VALUE.C_LRCLK_POL}
}

proc update_MODELPARAM_VALUE.C_BCLK_POL { MODELPARAM_VALUE.C_BCLK_POL PARAM_VALUE.C_BCLK_POL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_BCLK_POL}] ${MODELPARAM_VALUE.C_BCLK_POL}
}

proc update_MODELPARAM_VALUE.C_DMA_TYPE { MODELPARAM_VALUE.C_DMA_TYPE PARAM_VALUE.C_DMA_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DMA_TYPE}] ${MODELPARAM_VALUE.C_DMA_TYPE}
}

proc update_MODELPARAM_VALUE.C_NUM_CH { MODELPARAM_VALUE.C_NUM_CH PARAM_VALUE.C_NUM_CH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_NUM_CH}] ${MODELPARAM_VALUE.C_NUM_CH}
}

proc update_MODELPARAM_VALUE.C_HAS_TX { MODELPARAM_VALUE.C_HAS_TX PARAM_VALUE.C_HAS_TX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_HAS_TX}] ${MODELPARAM_VALUE.C_HAS_TX}
}

proc update_MODELPARAM_VALUE.C_HAS_RX { MODELPARAM_VALUE.C_HAS_RX PARAM_VALUE.C_HAS_RX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_HAS_RX}] ${MODELPARAM_VALUE.C_HAS_RX}
}

