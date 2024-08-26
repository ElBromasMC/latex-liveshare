BUILD_DIR := ./build

TEX_FILES := $(wildcard *.tex)

# Compile all .tex files in the current directory
.PHONY: all
all: $(patsubst %.tex,$(BUILD_DIR)/%.pdf,$(TEX_FILES))

# Latex build
$(BUILD_DIR)/%.pdf: %.tex
	mkdir -p $(dir $@)
	lualatex -interaction=batchmode -output-directory=$(dir $@) $<

# Live reload
.PHONY: live
live:
	trap 'kill 0' EXIT; \
	python -m http.server 8000 & \
	watchexec --exts tex,sty make build/main.pdf & \
	wait

.PHONY: clean
clean:
	@if [ -z "$(BUILD_DIR)" ]; then \
		echo "Error: BUILD_DIR is not set."; \
		exit 1; \
	fi
	rm -rf "$(BUILD_DIR)"

.SECONDARY:
