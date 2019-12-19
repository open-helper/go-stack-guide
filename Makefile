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

BUDDY_LOG_DIR := log/00-buddy


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

auto-merge: $(BUDDY_LOG_DIR)
	inotifywait -mrq --timefmt "%Y%m%d-%H:%M" --format="%T|%w|%f|%e" -e modify,delete,create,attrib $(CURDIR)/src/buddy | while read x; do \
		echo "$$x" >> $(BUDDY_LOG_DIR)/buddy-up.log; \
		make -C . merge; \
	done;

$(BUDDY_LOG_DIR):
	mkdir -p $@


# ####################################
# Git AREA
# ####################################
include ./scripts/deps/git.mk


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
