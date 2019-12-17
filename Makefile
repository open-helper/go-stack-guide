# ####################################
# Name: go-stack-guide Go开源Guide
# FileVersion: 20191217
# ####################################

.PHONY: all clean


DATA_SUF = $(shell date +"%Y.%m.%d.%H.%M.%S")
GUP_MSG = "Auto Commited at $(DATA_SUF)"

ifdef MSG
	GUP_MSG = "$(MSG)"
endif


# ####################################
# Dashboard AREA
# ####################################
start:


sync:
	make -C scripts/git-repo-mgr init sync merge

merge:
	make -C scripts/git-repo-mgr merge

build:
	dirs=`find src/repo -name ".open-helper"`; \
	for x in $$dirs; do \
		echo "$$x/Makefile"; \
		[ -f "$$x/Makefile" ] && make build -C "$$x" || true; \
	done;


# ####################################
# Git AREA
# ####################################
include ./scripts/deps/git.mk


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
