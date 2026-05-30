# 基于 Spring Boot 的学生实习信息管理系统

## 项目简介

本项目是面向高校学生实习、校企合作招聘和师生互动答疑场景的 Web 管理系统，覆盖管理员、学生、老师和企业四类角色。系统围绕学生档案、教师档案、企业信息、实习记录、招聘岗位、学生应聘、公告评论、讨论区、问题解答、字典维护、文件上传和数据看板提供完整管理能力。

后端采用 Spring Boot + MyBatis-Plus + MySQL，前端采用 Vue 3 + Vite + Element Plus。系统通过自定义 Token 拦截器完成多角色鉴权，前端按角色提供独立工作台、业务菜单和操作权限。

完整项目文档见 [project-documentation.md](project-documentation.md)。

## 技术栈

| 层级 | 技术 | 说明 |
| --- | --- | --- |
| 后端 | Spring Boot 2.2.2.RELEASE | Web 服务、内嵌 Tomcat |
| 后端 | MyBatis-Plus 2.3 | ORM、分页、基础 CRUD |
| 后端 | MySQL 5.7+ | 业务数据存储 |
| 后端 | Apache POI 3.9 | Excel 批量导入 |
| 后端 | Baidu AI SDK 4.4.1 | 人脸比对接口支持 |
| 前端 | Vue 3.4 + Vite 5 | 管理端单页应用 |
| 前端 | Element Plus | 表单、表格、弹窗、分页等 UI 组件 |
| 前端 | Axios | API 请求封装，统一携带 Token |
| 前端 | lucide-vue-next | 菜单和操作图标 |

## 核心功能

- 多角色登录：管理员、学生、老师、企业。
- 基础档案管理：学生、教师、企业信息维护，支持字典映射、头像/图片上传和批量导入。
- 学生简历管理：学生档案支持上传简历文件，企业在应聘、实习场景可查看简历。
- 实习管理：维护学生实习企业、实习岗位、实习周期、实习类型和实习结果。
- 招聘应聘：企业发布招聘岗位，学生投递应聘，企业录用后自动生成实习记录并更新招聘进度。
- 公告与评论：管理员、老师、企业可发布公告；学生、老师、企业可参与评论。
- 讨论区：学生、老师、企业和管理员可发布讨论帖并回复交流。
- 问题解答：学生向本专业老师提问，老师回复后形成问题记录。
- 字典管理：维护性别、院系、专业、班级、企业行业、公告类型、实习类型、实习结果等枚举。
- 文件上传下载：支持头像、企业图片、学生简历等文件资源。
- 数据看板：提供学生、实习、招聘、企业和月度趋势等统计接口。
- 角色工作台：不同角色进入独立前端布局和菜单，限制可见模块与操作范围。

## 项目结构

```text
.
├── README.md
├── db.sql                              # 全部表结构和字典数据
├── db2.sql                             # 全部基础数据和补充演示数据
├── Makefile                            # Git Bash 下的一键启动脚本
├── project-documentation.md            # 完整项目文档
└── biyeshengshixiyujiuye/
    ├── pom.xml
    └── src/main/
        ├── java/com/
        │   ├── controller/             # REST 接口
        │   ├── service/                # 服务接口与实现
        │   ├── dao/                    # MyBatis Mapper
        │   ├── entity/                 # 实体、VO、View、Model
        │   ├── interceptor/            # Token 鉴权拦截器
        │   ├── config/                 # Spring 和 MyBatis 配置
        │   └── utils/                  # 通用工具类
        └── resources/
            ├── application.yml
            ├── mapper/                 # XML SQL 映射
            ├── static/upload/          # 上传资源目录
            └── admin/admin/            # Vue 3 + Vite 前端
```

## 快速启动

### 环境要求

| 依赖 | 建议版本 | 说明 |
| --- | --- | --- |
| JDK | 1.8 | 后端编译运行环境 |
| Maven | 3.6+ | 后端依赖和构建 |
| MySQL | 5.7+ | 数据库 |
| Node.js | 18+ | 前端 Vite 开发和构建 |
| npm 或 cnpm | 最新稳定版 | 前端依赖安装 |

### 1. 初始化数据库

新建数据库时按顺序导入：

```bash
mysql -u root -p < db.sql
mysql -u root -p < db2.sql
```

`db.sql` 会创建并使用数据库 `biyeshengshixiyujiuye`，包含全部表结构和 `dictionary` 字典数据。`db2.sql` 会写入示例账号、学生、教师、企业、实习、招聘、公告评论等全部基础数据和补充演示数据。

### 2. 修改数据库配置

编辑 `biyeshengshixiyujiuye/src/main/resources/application.yml`：

```yaml
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/biyeshengshixiyujiuye?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=GMT%2B8
    username: root
    password: 123456
```

### 3. 启动后端

```bash
cd biyeshengshixiyujiuye
mvn spring-boot:run
```

后端默认地址：

```text
http://localhost:8080/biyeshengshixiyujiuye
```

### 4. 启动前端

```bash
cd biyeshengshixiyujiuye/src/main/resources/admin/admin
npm install
npm run dev
```

前端默认地址：

```text
http://localhost:8081
```

前端开发环境通过 Vite 将 `/api` 代理到后端 `/biyeshengshixiyujiuye`。

也可以使用项目根目录的 Makefile 在 Git Bash 中启动：

```bash
make install
make dev
```

## 默认账号

| 角色 | 账号 | 密码 |
| --- | --- | --- |
| 管理员 | admin | admin |
| 学生 | 20210001 | 123456 |
| 老师 | T2020001 | 123456 |
| 企业 | QY001 | 123456 |

更多示例账号可在 `db2.sql` 中查看。

## 常用命令

```bash
# 后端打包
cd biyeshengshixiyujiuye
mvn clean package -DskipTests

# 前端开发
cd biyeshengshixiyujiuye/src/main/resources/admin/admin
npm run dev

# 前端构建
npm run build

# 前端预览构建结果
npm run preview

# Git Bash 一键启停
make dev
make start
make stop
make status
```

## 接口约定

- 统一上下文路径：`/biyeshengshixiyujiuye`
- 前端开发代理前缀：`/api`
- 登录后请求头携带：`Token: <登录返回 token>`
- 通用响应结构：`code`、`msg`、`data`
- 主要业务接口前缀：`/users`、`/xuesheng`、`/laoshi`、`/qiye`、`/shixi`、`/zhaopinGangwei`、`/yingpin`、`/gonggao`、`/gonggaoComment`、`/taolun`、`/taolunHuifu`、`/wentiJieda`、`/dictionary`、`/config`、`/dashboard`

## 文档索引

- [完整项目文档](project-documentation.md)：系统定位、架构、角色权限、接口、部署和维护说明。

## 部署建议

- 生产环境建议使用独立的 `application-prod.yml` 管理数据库、端口、上下文路径和外部服务密钥。
- 当前示例数据中密码为明文，正式部署前应改为 BCrypt 或其他安全散列方案。
- 当前 CORS 和开发代理适合本地开发，生产环境应限制为可信前端域名。
- 上传目录和文件类型建议补充白名单、大小限制和安全扫描，并由 Nginx 或对象存储统一托管。
- DAO 日志当前为 `debug`，生产环境建议调整为 `info` 或 `warn`。
- 通用统计接口支持动态表名和字段名，公开部署时应限制可访问范围。

## 许可证

本项目仅供学习、课程设计和二次开发参考使用。
