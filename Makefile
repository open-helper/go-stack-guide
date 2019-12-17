PWD = $(shell pwd)
DATE_SUF = $(shell date +%Y.%m.%d.%H.%M.%S)

# GIT_OPT := --depth=1

LOG_DIR 			:= ../../log
REPO_LIST_DIR	:= ../../conf/git.repos.d
REPO_SRC_DIR	:= ../../src/repo
TOPIC_SRC_DIR	:= ../../src/topics
BUDDY_SRC_DIR := ../../src/buddy
DOCKER_APP_DIR := ../../apps/docker-compose
K8S_APP_DIR		:= ../../apps/k8s
BUDDY_CTL_DIR := .open-helper


# ###########################
# MAIN AREA
# ###########################
.PHONY: init fini clean install uninstall sync export
init:
	$(call fetchRepoListR,gitee,$(REPO_SRC_DIR),https://gitee.com/)
	$(call fetchRepoListR,github,$(REPO_SRC_DIR),https://github.com/)
	$(call fetchRepoListR,gitlab,$(REPO_SRC_DIR),https://gitlab.com/)
	$(call initWorkDirR)
	@echo ALL DONE;
fini:
	echo "$@ - PASS"
clean:
	-rm -rvf *.log *.bak
	find $(TOPIC_SRC_DIR) -maxdepth 2 -type l -exec unlink {} \;

install:
uninstall:
sync:
	-find $(REPO_SRC_DIR) -type d -name ".git" | xargs -t -n1 -I _ git -C _/.. pull
	echo sync done.
merge:
	$(call mergeRepoWithBuddyR)
export:
	@echo TODO-RESERVED


# ###########################
# SUB AREA
# ###########################



# ######################
# 自定义 utils
# ######################
# usage: $(call verifyLink, src-file-or-dir, dst-link[, sudo])
define verifyLink
	[ -h $(2) ] && $(3) unlink $(2) || >/dev/null
	[ -e $(2) ] && $(3) mv $(2) $(2)-$(DATE_SUF) || >/dev/null
	[ ! -h $(2) ] && $(3) ln -s $(1) $(2) || >/dev/null
endef


define fetchRepoListR
	# 拉取列表
	# echo "cat $(REPO_LIST_DIR)/$(1).d/*.lst"
	for x in $(shell find $(REPO_LIST_DIR)/$(1).d -name "*.lst" | xargs cat | grep -v '#' | sort); do \
		echo $$x; \
		fname=$$(echo $$x | tr '/.' '-' | tr A-Z a-z); \
		dest_dir=$(2)/$$fname; \
		[ ! -d "$$dest_dir" ] && git clone --depth=1 $(GIT_OPT) "$(3)$${x}.git" "$$dest_dir"; \
		echo "$$x done"; \
	done;
	# 符号链接化(按标签分类)
	for flst_path in `find $(REPO_LIST_DIR)/$(1).d -name "*.lst"`; do \
		topic_name=`basename $$flst_path | cut -d. -f1`; \
		topic_dir=$(TOPIC_SRC_DIR)/$$topic_name; \
		[ -d "$$topic_dir" ] || mkdir -p "$$topic_dir"; \
		lst=`cat $$flst_path | grep -v "#"`; \
		for x in $$lst; do \
			dname=$$(echo $$x | tr '/.' '-' | tr A-Z a-z); \
			[ -L "$$topic_dir/$$dname" ] || ln -fs "../../repo/$$dname" "$$topic_dir/$$dname"; \
		done; \
		echo "$$topic_dir $$flst_path done"; \
	done;
endef


# 注: 目录树创建功能 mkdir -p $(K8S_APP_DIR)/$$x/{data,conf} 好像不支持哟.
define initWorkDirR
	names=`find $(REPO_SRC_DIR) -maxdepth 1 -type d -exec basename {} \;`; \
	echo "names=$$names"; \
	for x in $$names; do \
		[ -d "$(BUDDY_SRC_DIR)/$$x/$(BUDDY_CTL_DIR)" ] || mkdir -p "$(BUDDY_SRC_DIR)/$$x/$(BUDDY_CTL_DIR)"; \
		[ -d "$(DOCKER_APP_DIR)/$$x/data" ] || mkdir -p "$(DOCKER_APP_DIR)/$$x/data"; \
		[ -d "$(DOCKER_APP_DIR)/$$x/conf" ] || mkdir -p "$(DOCKER_APP_DIR)/$$x/conf"; \
		[ -d "$(K8S_APP_DIR)/$$x/data" ] || mkdir -p "$(K8S_APP_DIR)/$$x/data"; \
		[ -d "$(K8S_APP_DIR)/$$x/conf" ] || mkdir -p "$(K8S_APP_DIR)/$$x/conf"; \
		[ -d "$(LOG_DIR)/$$x" ] || mkdir -p $(LOG_DIR)/$$x; \
		[ -L "$(DOCKER_APP_DIR)/$$x/log" ] || ln -fs ../../../log/$$x "$(DOCKER_APP_DIR)/$$x/log"; \
		[ -L "$(K8S_APP_DIR)/$$x/log" ] || ln -fs ../../../log/$$x "$(K8S_APP_DIR)/$$x/log"; \
	done;
endef

# 合并代码buddy -> repo
define mergeRepoWithBuddyR
	names=`find $(BUDDY_SRC_DIR) -maxdepth 1 -type d -exec basename {} \;`; \
	for x in $$names; do \
		rsync -avP $(BUDDY_SRC_DIR)/$$x/ $(REPO_SRC_DIR)/$$x/; \
	done;
endef
