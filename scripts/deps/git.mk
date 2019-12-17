# ####################################
# Git 操作 AREA
# ####################################


# 子库信息
BRANCH := master
SUB_SCRIPT_LIST := git-repo-mgr=git-repo-mgr
SUB_SCRIPT_GIT_PREFIX := git@github.com:open-guide
SUB_SCRIPT_LOCAL_PREFIX := scripts

SUB_TEMPLATE_LIST := go-templates=go ide-templates=ide
SUB_TEMPLATE_GIT_PREFIX := git@github.com:open-guide
SUB_TEMPLATE_LOCAL_PREFIX := templates

SUB_APP_DOCKER_LIST := go-docker-compose-apps=docker-compose base-docker-compose-apps=infra
SUB_APP_DOCKER_GIT_PREFIX := git@github.com:open-docker
SUB_APP_DOCKER_LOCAL_PREFIX := apps

SUB_APP_K8S_LIST := go-k8s-apps=k8s
SUB_APP_K8S_GIT_PREFIX := git@github.com:open-k8s
SUB_APP_K8S_LOCAL_PREFIX := apps


FCUT := cut -d '='


# ####################################
# git
# ####################################
gpom:
	git add .
	-git commit -am $(GUP_MSG)
	git push origin master
	git status
gfom:
	git pull origin master
gs: gstatus
ga:
	git add .


# ####################################
# Sub Git Tree AREA
# ####################################
gstatus:
	git status
	@echo SUB_SCRIPT=$(SUB_SCRIPT_LIST),$(SUB_SCRIPT_LOCAL_PREFIX),$(SUB_SCRIPT_GIT_PREFIX)
	@echo SUB_TEMPLATE=$(SUB_TEMPLATE_LIST),$(SUB_TEMPLATE_LOCAL_PREFIX),$(SUB_TEMPLATE_GIT_PREFIX)
	@echo SUB_APP_DOCKER=$(SUB_APP_DOCKER_LIST),$(SUB_APP_DOCKER_LOCAL_PREFIX),$(SUB_APP_DOCKER_GIT_PREFIX)
	@echo SUB_APP_K8S=$(SUB_APP_K8S_LIST),$(SUB_APP_K8S_LOCAL_PREFIX),$(SUB_APP_K8S_GIT_PREFIX)

ginit:
	$(call doSubListInit,$(SUB_SCRIPT_LIST),$(SUB_SCRIPT_LOCAL_PREFIX),$(SUB_SCRIPT_GIT_PREFIX))
	$(call doSubListInit,$(SUB_TEMPLATE_LIST),$(SUB_TEMPLATE_LOCAL_PREFIX),$(SUB_TEMPLATE_GIT_PREFIX))
	$(call doSubListInit,$(SUB_APP_DOCKER_LIST),$(SUB_APP_DOCKER_LOCAL_PREFIX),$(SUB_APP_DOCKER_GIT_PREFIX))
	$(call doSubListInit,$(SUB_APP_K8S_LIST),$(SUB_APP_K8S_LOCAL_PREFIX),$(SUB_APP_K8S_GIT_PREFIX))

gpull: gfom ginit
	$(call doSubListPull,$(SUB_SCRIPT_LIST),$(SUB_SCRIPT_LOCAL_PREFIX),$(SUB_SCRIPT_GIT_PREFIX))
	$(call doSubListPull,$(SUB_TEMPLATE_LIST),$(SUB_TEMPLATE_LOCAL_PREFIX),$(SUB_TEMPLATE_GIT_PREFIX))
	$(call doSubListPull,$(SUB_APP_DOCKER_LIST),$(SUB_APP_DOCKER_LOCAL_PREFIX),$(SUB_APP_DOCKER_GIT_PREFIX))
	$(call doSubListPull,$(SUB_APP_K8S_LIST),$(SUB_APP_K8S_LOCAL_PREFIX),$(SUB_APP_K8S_GIT_PREFIX))

gpush: gpom ginit
	$(call doSubListPush,$(SUB_SCRIPT_LIST),$(SUB_SCRIPT_LOCAL_PREFIX),$(SUB_SCRIPT_GIT_PREFIX))
	$(call doSubListPush,$(SUB_TEMPLATE_LIST),$(SUB_TEMPLATE_LOCAL_PREFIX),$(SUB_TEMPLATE_GIT_PREFIX))
	$(call doSubListPush,$(SUB_APP_DOCKER_LIST),$(SUB_APP_DOCKER_LOCAL_PREFIX),$(SUB_APP_DOCKER_GIT_PREFIX))
	$(call doSubListPush,$(SUB_APP_K8S_LIST),$(SUB_APP_K8S_LOCAL_PREFIX),$(SUB_APP_K8S_GIT_PREFIX))


# ####################################
# Git Sub Tree AREA
# ####################################
define doSubListInit
	for xy in $(1); do \
		x=`echo "$${xy}" | $(FCUT) -f1`; \
		y=`echo "$${xy}" | $(FCUT) -f2`; \
		grep "$$x" .git/config >/dev/null || git remote add -f $$x $(3)/$$x.git;    \
		[ ! -d "$(2)/$$y" ] && git subtree add --prefix=$(2)/$$y $$x $(BRANCH) --squash || >/dev/null; \
	done;
endef

define doSubListPull
	for xy in $(1); do \
		x=`echo "$${xy}" | $(FCUT) -f1`; \
		y=`echo "$${xy}" | $(FCUT) -f2`; \
		git subtree pull --prefix=$(2)/$$y $$x $(BRANCH) --squash; \
	done;
endef

define doSubListPush
	for xy in $(1); do \
		x=`echo "$${xy}" | $(FCUT) -f1`; \
		y=`echo "$${xy}" | $(FCUT) -f2`; \
		git subtree push --prefix=$(2)/$$y $$x $(BRANCH) || >/dev/null; \
	done;
endef
