# 实习信息管理系统 Makefile
# 一键启动前后端服务（Git Bash on Windows）

SHELL := /bin/bash

# Windows 下 Git Bash 可能找不到 netstat/taskkill，用完整路径
NETSTAT := $(shell command -v netstat 2>/dev/null || echo /c/WINDOWS/system32/netstat.exe)
TASKKILL := $(shell command -v taskkill 2>/dev/null || echo /c/WINDOWS/system32/taskkill.exe)

# 配置
BACKEND_PORT = 8080
FRONTEND_PORT = 8081
BACKEND_DIR = biyeshengshixiyujiuye
FRONTEND_DIR = biyeshengshixiyujiuye/src/main/resources/admin/admin

# 颜色
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m

.PHONY: help dev start stop restart status backend frontend install clean

help:
	@echo -e "$(GREEN)实习信息管理系统 Makefile$(NC)"
	@echo ""
	@echo -e "可用命令："
	@echo -e "  $(YELLOW)make dev$(NC)       - 启动开发环境（前台运行，Ctrl+C 停止）"
	@echo -e "  $(YELLOW)make start$(NC)     - 后台启动所有服务"
	@echo -e "  $(YELLOW)make stop$(NC)      - 停止所有服务"
	@echo -e "  $(YELLOW)make restart$(NC)   - 重启所有服务"
	@echo -e "  $(YELLOW)make status$(NC)    - 查看服务状态"
	@echo -e "  $(YELLOW)make backend$(NC)   - 单独启动后端（前台）"
	@echo -e "  $(YELLOW)make frontend$(NC)  - 单独启动前端（前台）"
	@echo -e "  $(YELLOW)make install$(NC)   - 安装依赖"
	@echo -e "  $(YELLOW)make clean$(NC)     - 清理临时文件和日志"

# 根据端口号精确查找并杀死进程
define kill_by_port
	@pid=$$($(NETSTAT) -ano 2>/dev/null | grep ":$(1) .*LISTENING" | awk '{print $$NF}' | head -1); \
	if [ -n "$$pid" ] && [ "$$pid" != "0" ]; then \
		echo -e "$(YELLOW)停止端口 $(1) PID $$pid$(NC)"; \
		$(TASKKILL) //F //PID $$pid || true; \
	fi
endef

# 开发环境（前台运行，Ctrl+C 可停止所有进程）
dev:
	@echo -e "$(GREEN)启动开发环境...$(NC)"; \
	cleanup() { \
		echo -e "\n$(YELLOW)正在停止服务...$(NC)"; \
		pid=$$( $(NETSTAT) -ano 2>/dev/null | grep ":$(BACKEND_PORT) .*LISTENING" | awk '{print $$NF}' | head -1); \
		[ -n "$$pid" ] && [ "$$pid" != "0" ] && $(TASKKILL) //F //PID $$pid 2>&1; \
		pid=$$( $(NETSTAT) -ano 2>/dev/null | grep ":$(FRONTEND_PORT) .*LISTENING" | awk '{print $$NF}' | head -1); \
		[ -n "$$pid" ] && [ "$$pid" != "0" ] && $(TASKKILL) //F //PID $$pid 2>&1; \
		echo -e "$(GREEN)服务已停止$(NC)"; \
		exit 0; \
	}; \
	trap cleanup INT TERM; \
	cd $(BACKEND_DIR) && mvn spring-boot:run & \
	cd $(FRONTEND_DIR) && cnpm run serve & \
	sleep 5; \
	echo ""; \
	echo -e "$(GREEN)服务已启动：$(NC)"; \
	echo -e "  后端: http://localhost:$(BACKEND_PORT)/biyeshengshixiyujiuye"; \
	echo -e "  前端: http://localhost:$(FRONTEND_PORT)"; \
	echo ""; \
	echo -e "$(YELLOW)按 Ctrl+C 停止所有服务$(NC)"; \
	wait

# 后台启动
start:
	@echo -e "$(GREEN)后台启动服务...$(NC)"
	@if curl -s --connect-timeout 2 http://localhost:$(BACKEND_PORT)/biyeshengshixiyujiuye >/dev/null 2>&1; then \
		echo -e "$(YELLOW)后端已运行中$(NC)"; \
	else \
		cd $(BACKEND_DIR) && nohup mvn spring-boot:run > ../backend.log 2>&1 & \
		echo -e "$(GREEN)后端启动中...$(NC)"; \
	fi
	@if curl -s --connect-timeout 2 http://localhost:$(FRONTEND_PORT) >/dev/null 2>&1; then \
		echo -e "$(YELLOW)前端已运行中$(NC)"; \
	else \
		cd $(FRONTEND_DIR) && nohup cnpm run serve > ../../../backend.log 2>&1 & \
		echo -e "$(GREEN)前端启动中...$(NC)"; \
	fi
	@sleep 5
	@$(MAKE) status

# 停止服务（按端口精确杀进程）
stop:
	@echo -e "$(YELLOW)停止服务...$(NC)"
	$(call kill_by_port,$(BACKEND_PORT))
	$(call kill_by_port,$(FRONTEND_PORT))
	@echo -e "$(GREEN)服务已停止$(NC)"

# 重启
restart:
	@$(MAKE) stop
	@sleep 2
	@$(MAKE) start

# 状态检查
status:
	@echo -e "$(GREEN)服务状态：$(NC)"
	@if curl -s --connect-timeout 2 http://localhost:$(BACKEND_PORT)/biyeshengshixiyujiuye >/dev/null 2>&1; then \
		echo -e "  $(GREEN)● 后端运行中$(NC) http://localhost:$(BACKEND_PORT)/biyeshengshixiyujiuye"; \
	else \
		echo -e "  $(RED)○ 后端未运行$(NC)"; \
	fi
	@if curl -s --connect-timeout 2 http://localhost:$(FRONTEND_PORT) >/dev/null 2>&1; then \
		echo -e "  $(GREEN)● 前端运行中$(NC) http://localhost:$(FRONTEND_PORT)"; \
	else \
		echo -e "  $(RED)○ 前端未运行$(NC)"; \
	fi

# 单独启动后端
backend:
	@echo -e "$(GREEN)启动后端...$(NC) http://localhost:$(BACKEND_PORT)/biyeshengshixiyujiuye"
	@cd $(BACKEND_DIR) && mvn spring-boot:run

# 单独启动前端
frontend:
	@echo -e "$(GREEN)启动前端...$(NC) http://localhost:$(FRONTEND_PORT)"
	@cd $(FRONTEND_DIR) && cnpm run serve

# 安装依赖
install:
	@echo -e "$(GREEN)安装后端依赖...$(NC)"
	@cd $(BACKEND_DIR) && mvn dependency:resolve -q
	@echo -e "$(GREEN)安装前端依赖...$(NC)"
	@cd $(FRONTEND_DIR) && cnpm install
	@echo -e "$(GREEN)全部依赖安装完成$(NC)"

# 清理
clean:
	@rm -f backend.log frontend.log
	@echo -e "$(GREEN)清理完成$(NC)"
