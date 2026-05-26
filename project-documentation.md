# 毕业生实习与就业管理系统项目文档

## 1. 项目定位

毕业生实习与就业管理系统用于支撑高校毕业实习、就业去向、校企合作招聘、公告通知、讨论交流和师生问题解答等业务。系统面向管理员、学生、老师、企业四类用户，提供从基础档案维护、实习跟踪、招聘应聘、就业登记到数据统计分析的闭环管理能力。

系统默认访问地址：

```text
后端：http://localhost:8080/biyeshengshixiyujiuye
前端：http://localhost:8081
```

前端开发环境通过 Vite 将 `/api` 代理到后端上下文路径。

## 2. 总体架构

```text
浏览器
  |
  | Vue 3 + Vite + Element Plus
  v
前端管理端
  |
  | Axios，Header: Token
  v
Spring Boot REST API
  |
  | Controller -> Service -> DAO -> Mapper XML
  v
MySQL 业务数据库
```

后端使用标准分层结构：

- `controller`：接收 HTTP 请求，处理参数、权限和响应。
- `service` / `service.impl`：承载业务服务接口和实现。
- `dao`：MyBatis-Plus Mapper 接口。
- `mapper`：XML SQL 映射文件。
- `entity`：数据库实体、业务模型、视图对象和返回对象。
- `interceptor`：Token 鉴权拦截器。
- `config`：Spring MVC、MyBatis-Plus、字段自动填充等配置。
- `utils`：分页、响应、SQL 过滤、文件、POI、百度 API 等工具类。

前端采用角色分区：

- `AdminLayout`：管理员后台。
- `StudentLayout`：学生端工作台。
- `TeacherLayout`：教师端工作台。
- `CompanyLayout`：企业端工作台。
- `views/*/crud/modules.js`：不同角色可见模块、字段、表格列和操作能力配置。
- `src/api/*`：按业务模块封装接口请求，统一经 `request.js` 携带 Token。

## 3. 技术选型

| 模块 | 技术 | 用途 |
| --- | --- | --- |
| 后端框架 | Spring Boot 2.2.2.RELEASE | Web 服务、应用启动、内嵌 Tomcat |
| ORM | MyBatis-Plus 2.3 | 单表 CRUD、分页插件、逻辑删除支持 |
| 数据库 | MySQL 5.7+ | 存储用户、业务、字典、Token 和配置数据 |
| 文件导入 | Apache POI 3.9 | Excel 批量导入 |
| 外部服务 | Baidu AI SDK 4.4.1 | 人脸比对能力 |
| 工具库 | Hutool、Commons IO、FastJSON | 通用工具、文件处理、JSON 序列化 |
| 前端框架 | Vue 3.4 | 单页应用 |
| 构建工具 | Vite 5 | 前端开发服务器、代理与生产构建 |
| UI 组件 | Element Plus | 表单、表格、弹窗、分页 |
| HTTP | Axios | API 请求和拦截 |
| 图标 | lucide-vue-next、@element-plus/icons-vue | 菜单与操作图标 |

## 4. 角色与权限

| 角色 | 登录表 | 主要能力 |
| --- | --- | --- |
| 管理员 | `users` | 管理学生、教师、企业、实习、就业、招聘岗位、应聘学生、公告、评论、讨论区、讨论回复、字典、配置，查看全局看板 |
| 学生 | `xuesheng` | 维护个人信息和简历，查看招聘岗位并应聘，查看个人实习/就业，浏览公告并评论，发布讨论帖，向本专业老师提问 |
| 老师 | `laoshi` | 维护所属专业学生，查看学生实习与就业，发布公告，查看/维护评论，参与讨论，回复本专业学生问题 |
| 企业 | `qiye` | 维护企业信息，发布招聘岗位，查看应聘学生和简历，录用后生成实习记录，维护本企业实习/就业、公告、评论和讨论 |

鉴权机制：

- 登录接口返回 Token。
- 前端在后续请求头中携带 `Token`。
- `AuthorizationInterceptor` 根据 Token 查询 `token` 表。
- 后端将 `userId`、`role`、`tableName`、`username` 写入 Session。
- 标注 `@IgnoreAuth` 的接口跳过登录校验。
- 业务接口在 Controller 层按角色补充数据范围，例如企业只能操作本企业招聘岗位和应聘数据，学生只能操作自己的应聘和问题记录。

## 5. 数据模型

核心业务表：

| 表名 | 说明 |
| --- | --- |
| `users` | 管理员账号 |
| `xuesheng` | 学生档案，含头像、院系专业班级、入学年份和 `xuesheng_jianli_file` 简历字段 |
| `laoshi` | 教师档案 |
| `qiye` | 企业档案 |
| `shixi` | 实习信息 |
| `jiuye` | 就业信息 |
| `zhaopin_gangwei` | 招聘岗位，记录企业、职位、薪资、地址、要求、招聘人数和已招人数 |
| `yingpin` | 应聘学生，记录学生投递岗位、企业和处理状态 |
| `gonggao` | 公告 |
| `gonggao_comment` | 公告评论 |
| `taolun` | 讨论区帖子 |
| `taolun_huifu` | 讨论区回复 |
| `wenti_jieda` | 学生问题和老师回复 |
| `dictionary` | 数据字典 |
| `config` | 系统配置 |
| `token` | 登录令牌 |

数据库脚本：

| 脚本 | 用途 |
| --- | --- |
| `db.sql` | 基础库表、基础字典、示例账号、实习就业、公告评论、招聘应聘表结构和简历字段 |
| `add_discussion_question.sql` | 讨论区、讨论回复、问题解答增量表 |
| `docs/20260525_resume_recruitment.sql` | 旧库升级用的简历字段、招聘岗位、应聘学生增量脚本 |

主要唯一约束：

- 学生：账号、学号、手机号、身份证号唯一。
- 教师：账号、工号、手机号、身份证号唯一。
- 企业：账号、企业编号、联系方式、邮箱唯一。
- 公告：同一发布者下公告标题唯一。
- 就业：同一学生、企业、入职日期组合唯一。
- 应聘：同一学生不能重复应聘同一招聘岗位。

## 6. 核心业务流程

### 6.1 招聘与应聘

1. 企业在招聘岗位模块发布岗位，填写职位名称、类型、薪资范围、工作地址、招聘数量和工作要求。
2. 学生在招聘信息模块查看岗位并点击应聘。
3. 后端校验岗位是否招满、学生是否已毕业、学生是否处于进行中的实习、是否重复应聘同一岗位。
4. 企业在应聘学生模块查看学生信息和简历。
5. 企业录用学生时填写实习开始日期和预计结束日期。
6. 后端自动生成一条实习记录，将岗位已招人数加一，并清理该学生剩余应聘记录。

### 6.2 讨论区

学生、老师、企业和管理员均可发布讨论帖。回复内容记录回复人身份、姓名和时间。普通用户只能修改或删除自己发布的帖子/回复，管理员可管理全部内容。

### 6.3 问题解答

学生只能向本专业老师提问。未回复问题允许学生修改；老师回复后问题状态变为“已回复”，学生只能查看。老师只能回复分配给自己且属于本专业学生的问题。

## 7. 功能模块

### 7.1 管理员端

管理员端提供全局数据维护能力：

- 首页数据看板。
- 学生管理：新增、编辑、查询、详情、简历维护、批量导入。
- 教师管理：新增、编辑、查询、详情、批量导入。
- 企业管理：新增、编辑、查询、详情、批量导入。
- 实习管理：维护学生、企业、实习类型、周期、岗位、结果和详情。
- 就业管理：维护学生、企业、入职岗位、入职日期和备注。
- 招聘岗位：维护企业岗位、薪资范围、招聘数量和招满状态。
- 应聘学生：查看学生投递岗位、学生基础信息和简历。
- 公告管理：发布和维护系统公告。
- 公告评论：查看和删除评论。
- 讨论区：管理交流帖子，查看和回复讨论。
- 讨论回复：查看并删除不合规回复。
- 字典管理：维护院系、专业、班级、性别、行业、公告类型、实习类型等枚举。
- 系统配置：维护运行配置项。

### 7.2 学生端

学生端重点展示个人相关数据：

- 首页工作台。
- 个人信息和简历维护。
- 修改密码。
- 招聘信息：查看企业招聘岗位并提交应聘。
- 我的应聘：查看已投递岗位和处理状态。
- 我的实习：只读查看个人实习记录。
- 我的就业：只读查看个人就业记录。
- 公告信息：查看学校、教师和企业公告并评论。
- 讨论区：发布实习、就业、招聘相关交流帖并回复。
- 问题记录：向本专业老师提交问题，查看回复结果。
- 我的评论：新增、修改、删除自己发表的公告评论。

### 7.3 教师端

教师端面向专业或院系维度的管理：

- 首页工作台。
- 个人信息。
- 修改密码。
- 学生管理：维护当前教师所属专业学生，新增学生默认归属当前教师专业。
- 实习情况：只读查看所属专业学生实习情况。
- 就业情况：只读查看所属专业毕业生就业情况。
- 我的公告：发布和维护当前教师公告。
- 其他公告：查看其他发布者公告。
- 我的评论：维护当前教师发表的评论。
- 讨论区：参与帖子发布与回复。
- 问题解答：查看本专业学生问题并回复。

### 7.4 企业端

企业端面向校企合作和就业数据录入：

- 首页工作台。
- 企业信息维护。
- 招聘岗位：发布并维护本企业招聘岗位。
- 应聘学生：查看投递本企业岗位的学生信息、简历，并执行录用。
- 实习管理：维护本企业实习学生、岗位、周期和结果。
- 就业管理：新增本企业就业记录，查看就业学生信息。
- 招聘公告：发布和维护本企业公告。
- 其他公告：查看其他发布者公告。
- 讨论区：发布招聘、实习、企业指导相关交流帖并回复。
- 公告评论：维护当前企业账号发表的评论。

## 8. 接口概览

统一后端前缀：

```text
/biyeshengshixiyujiuye
```

前端开发代理前缀：

```text
/api
```

### 8.1 账号接口

```text
POST /users/login
POST /users/register
GET  /users/logout
GET  /users/resetPass
GET  /users/session

GET|POST /xuesheng/login
POST     /xuesheng/register
GET      /xuesheng/resetPassword
GET      /xuesheng/resetPass
GET      /xuesheng/session
GET      /xuesheng/logout

GET|POST /laoshi/login
POST     /laoshi/register
GET      /laoshi/resetPassword
GET      /laoshi/resetPass
GET      /laoshi/session
GET      /laoshi/logout

GET|POST /qiye/login
POST     /qiye/register
GET      /qiye/resetPassword
GET      /qiye/resetPass
GET      /qiye/session
GET      /qiye/logout
```

### 8.2 通用 CRUD

常见接口模式：

```text
/{module}/page
/{module}/info/{id}
/{module}/save
/{module}/update
/{module}/delete
/{module}/batchInsert
```

主要模块：

```text
xuesheng
laoshi
qiye
shixi
jiuye
zhaopinGangwei
yingpin
dictionary
config
```

说明：不是所有模块都开放批量导入，是否启用以对应 Controller 和前端模块配置为准。

### 8.3 招聘应聘接口

```text
GET  /zhaopinGangwei/page
GET  /zhaopinGangwei/info/{id}
POST /zhaopinGangwei/save
POST /zhaopinGangwei/update
POST /zhaopinGangwei/delete

GET  /yingpin/page
GET  /yingpin/info/{id}
POST /yingpin/save
POST /yingpin/update
POST /yingpin/apply/{zhaopinId}
POST /yingpin/accept/{id}
POST /yingpin/delete
```

`/yingpin/accept/{id}` 仅企业可用，录用成功后自动生成实习记录并更新招聘岗位已招人数。

### 8.4 公告、评论、讨论和问答

公告与评论：

```text
/gonggao/page
/gonggao/info/{id}
/gonggao/save
/gonggao/update
/gonggao/delete

/gonggaoComment/page
/gonggaoComment/list
/gonggaoComment/info/{id}
/gonggaoComment/save
/gonggaoComment/update
/gonggaoComment/delete
```

讨论区：

```text
/taolun/page
/taolun/info/{id}
/taolun/save
/taolun/update
/taolun/delete

/taolunHuifu/page
/taolunHuifu/list
/taolunHuifu/info/{id}
/taolunHuifu/save
/taolunHuifu/update
/taolunHuifu/delete
```

问题解答：

```text
/wentiJieda/page
/wentiJieda/info/{id}
/wentiJieda/save
/wentiJieda/update
/wentiJieda/delete
```

### 8.5 配置、文件和 Dashboard

配置与文件：

```text
/config/page
/config/list
/config/info/{id}
/config/detail/{id}
/config/info?name=xxx
/config/save
/config/update
/config/delete

/file/upload
/file/download?fileName=xxx
```

Dashboard 接口：

```text
GET /dashboard/base
GET /dashboard/shixiType
GET /dashboard/employmentRate
GET /dashboard/shixiResult
GET /dashboard/monthTrend
GET /dashboard/companyTop
GET /dashboard/summary
```

通用统计接口：

```text
/group/{tableName}
/cal/{tableName}/{columnName}
/group/{tableName}/{columnName}
/value/{tableName}/{xColumnName}/{yColumnName}
/newSelectGroupSum
/newSelectGroupCount
/newSelectDateGroupSum
/newSelectDateGroupCount
/barSum
/barCount
/remind/{tableName}/{columnName}/{type}
```

这些接口参数较动态，应只在受信任后台场景中使用。

## 9. 启动与构建

### 9.1 数据库初始化

新建数据库时按顺序导入：

```bash
mysql -u root -p < db.sql
mysql -u root -p < add_discussion_question.sql
```

旧库升级时，先备份数据库，再按需执行：

```bash
mysql -u root -p biyeshengshixiyujiuye < docs/20260525_resume_recruitment.sql
mysql -u root -p biyeshengshixiyujiuye < add_discussion_question.sql
```

### 9.2 后端开发启动

```bash
cd biyeshengshixiyujiuye
mvn spring-boot:run
```

### 9.3 前端开发启动

```bash
cd biyeshengshixiyujiuye/src/main/resources/admin/admin
npm install
npm run dev
```

### 9.4 Makefile 启动

在 Git Bash 中可使用：

```bash
make install
make dev
make start
make stop
make status
```

### 9.5 生产构建

```bash
cd biyeshengshixiyujiuye
mvn clean package -DskipTests
```

```bash
cd biyeshengshixiyujiuye/src/main/resources/admin/admin
npm run build
```

构建产物：

- 后端 JAR：`biyeshengshixiyujiuye/target/biyeshengshixiyujiuye-0.0.1-SNAPSHOT.jar`
- 前端静态资源：`biyeshengshixiyujiuye/src/main/resources/admin/admin/dist/`

## 10. 默认数据

常用默认账号：

| 角色 | 账号 | 密码 |
| --- | --- | --- |
| 管理员 | admin | admin |
| 学生 | 20210001 | 123456 |
| 老师 | T2020001 | 123456 |
| 企业 | QY001 | 123456 |

`db.sql` 已包含基础字典、学生、教师、企业、实习、就业、公告和评论示例数据，并包含招聘岗位、应聘学生和学生简历相关表结构。讨论区、讨论回复和问题解答表由 `add_discussion_question.sql` 补充。

## 11. 运维与部署建议

- 使用 Spring Profile 区分开发、测试和生产环境配置。
- 生产数据库账号使用最小权限，避免直接使用 root。
- 密码当前为明文示例数据，正式环境应改为安全散列存储。
- Token 表已有过期时间字段，建议补充强制过期、刷新和踢出策略。
- CORS 和 Vite 代理当前适合开发环境，生产应限制允许来源。
- 文件上传建议增加类型白名单、大小限制和病毒扫描，学生简历等敏感文件应限制访问权限。
- 上传资源建议由 Nginx、对象存储或独立静态资源服务托管。
- DAO SQL 日志生产环境建议关闭 debug。
- 字典数据启动时缓存到 ServletContext，修改字典后如前端展示异常，可重启后端刷新缓存。
- 通用统计接口允许动态表名和字段名，公开部署时需要额外限制调用范围。

## 12. 二次开发说明

新增业务模块时建议按以下步骤扩展：

1. 新增数据库表和种子数据。
2. 新增 Entity、Model、VO、View。
3. 新增 Dao 接口和 Mapper XML。
4. 新增 Service 和 ServiceImpl。
5. 新增 Controller，保持 `/page`、`/info/{id}`、`/save`、`/update`、`/delete` 的接口风格。
6. 在前端 `src/api/` 中新增 API 封装。
7. 在对应角色的 `views/*/crud/modules.js` 中注册字段、表格列、搜索项和操作权限。
8. 在 `router/index.js` 和角色导航数据中注册路由与菜单。
9. 如涉及角色数据范围，应在 Controller 层根据 Session 中的 `role`、`userId`、`tableName` 补充权限校验。

## 13. 已知限制

- MyBatis-Plus 版本为 2.x，不能直接使用 3.x 的 `LambdaQueryWrapper` 写法。
- 示例项目未引入 Swagger/OpenAPI，接口文档以代码和本文件为准。
- 文件上传路径和类型校验仍需生产化加固。
- 学生毕业判断按入学年份加 4 年并以 6 月 1 日作为毕业节点，实际业务可按学校规则调整。
- 招聘录用会清理该学生剩余应聘记录，若需要保留投递历史，应改为状态流转或归档表。
- 通用统计接口允许动态表名和字段名，公开部署时需要额外限制调用范围。
- 当前仓库保留部分设计过程文档和 Playwright 验证产物，交付发布时可按需清理。
