GPT_INI2BIN ?= ./device/intel/common/gpt_bin/gpt_ini2bin.py

.PHONY: $(BOARD_GPT_MFG_BIN)
$(BOARD_GPT_MFG_BIN): $(BOARD_GPT_MFG_INI) $(GPT_INI2BIN)
	$(hide) echo GEN $(notdir $@)
	$(hide) $(GPT_INI2BIN) $< > $@

.PHONY: gpt-mfg
gpt-mfg: $(BOARD_GPT_MFG_BIN)
