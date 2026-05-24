# 基于 Spring Boot 的毕业生实习与就业管理系统

## 项目简介

本项目是面向高校毕业实习与就业管理场景的 Web 系统，覆盖学生、教师、企业和管理员四类角色。系统围绕学生档案、教师档案、企业信息、实习记录、就业记录、公告发布、公告评论、字典维护、文件上传和数据看板提供完整管理能力。

后端采用 Spring Boot + MyBatis-Plus + MySQL，前端采用 Vue 3 + Vite + Element Plus。系统通过自定义 Token 拦截器完成多角色鉴权，前端按角色提供独立工作台和业务菜单。

完整项目文档见 [docs/project-documentation.md](docs/project-documentation.md)。

## 技术栈

| 层级 | 技术 | 说明 |
| --- | --- | --- |
| 后端 | Spring Boot 2.2.2.RELEASE | Web 服务、内嵌 Tomcat |
| 后端 | MyBatis-Plus 2.3 | ORM、分页、基础 CRUD |
| 后端 | MySQL 5.7+ | 业务数据存储 |
| 后端 | Apache POI 3.9 | Excel 批量导入 |
| 后端 | Baidu AI SDK 4.4.1 | 人脸比对接口支持 |
| 前端 | Vue 3.4 + Vite 5 | 管理端单页应用 |
| 前端 | Element Plus | 表单、表格、弹窗等 UI 组件 |
| 前端 | Axios | API 请求封装 |
| 前端 | lucide-vue-next | 菜单和操作图标 |

## 核心功能

- 多角色登录：管理员、学生、老师、企业。
- 基础档案管理：学生、教师、企业信息维护，支持字典映射和批量导入。
- 实习管理：维护学生实习企业、实习岗位、实习周期、实习类型和实习结果。
- 就业管理：维护毕业生入职企业、岗位、入职日期和就业备注。
- 公告与评论：管理员、老师、企业可发布公告；学生、老师、企业可参与评论。
- 字典管理：维护性别、院系、专业、班级、企业行业、公告类型、实习类型、实习结果等枚举。
- 文件上传下载：支持头像、企业图片、就业附件等文件资源。
- 数据看板：提供学生、实习、就业、企业和月度趋势等统计接口。
- 角色工作台：不同角色进入独立前端布局和菜单，限制可见模块与操作范围。

## 项目结构

```text
.
├── README.md
├── db.sql
├── Makefile
├── docs/
│   ├── project-documentation.md
│   ├── design.md
│   └── ...
└── biyeshengshixiyujiuye/
    ├── pom.xml
    └── src/main/
        ├── java/com/
        │   ├── controller/      # REST 接口
        │   ├── service/         # 服务接口与实现
        │   ├── dao/             # MyBatis Mapper
        │   ├── entity/          # 实体、VO、View、Model
        │   ├── interceptor/     # Token 鉴权拦截器
        │   ├── config/          # Spring 和 MyBatis 配置
        │   └── utils/           # 通用工具类
        └── resources/
            ├── application.yml
            ├── mapper/          # XML SQL 映射
            ├── static/upload/   # 示例上传资源
            └── admin/admin/     # Vue 3 + Vite 前端
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

```bash
mysql -u root -p < db.sql
```

脚本会创建并使用数据库 `biyeshengshixiyujiuye`，同时写入基础字典和示例业务数据。

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

更多示例账号可在 `db.sql` 中查看。

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
```

## 接口约定

- 统一上下文路径：`/biyeshengshixiyujiuye`
- 登录后请求头携带：`Token: <登录返回 token>`
- 通用响应结构：`code`、`msg`、`data`
- 主要业务接口前缀：`/users`、`/xuesheng`、`/laoshi`、`/qiye`、`/shixi`、`/jiuye`、`/gonggao`、`/gonggaoComment`、`/dictionary`、`/config`、`/dashboard`

## 文档索引

- [完整项目文档](docs/project-documentation.md)：系统定位、架构、角色权限、接口、部署和维护说明。
- [前端设计说明](docs/design.md)：前端重设计相关记录。
- [列表重设计说明](docs/list-redesign.md)：列表和业务表格设计记录。

## 部署建议

- 生产环境建议使用独立的 `application-prod.yml` 管理数据库、端口、上下文路径和外部服务密钥。
- 当前示例数据中密码为明文，正式部署前应改为 BCrypt 或其他安全散列方案。
- 当前 CORS 策略较宽松，生产环境应限制为可信前端域名。
- 上传目录和文件类型建议补充白名单校验，并由 Nginx 或对象存储统一托管。
- DAO 日志当前为 `debug`，生产环境建议调整为 `info` 或 `warn`。

## 许可证

本项目仅供学习、课程设计和二次开发参考使用。
