# 毕业生实习与就业管理系统项目文档

## 1. 项目定位

毕业生实习与就业管理系统用于支撑高校毕业实习、就业去向、校企合作和公告互动等业务。系统面向管理员、学生、老师、企业四类用户，提供从基础档案维护、实习跟踪、就业登记到数据统计分析的闭环管理能力。

系统默认后端服务地址：

```text
http://localhost:8080/biyeshengshixiyujiuye
```

前端开发服务默认地址：

```text
http://localhost:8081
```

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
| 构建工具 | Vite 5 | 前端开发服务器与生产构建 |
| UI 组件 | Element Plus | 表单、表格、弹窗、分页 |
| HTTP | Axios | API 请求和拦截 |
| 图标 | lucide-vue-next | 菜单与操作图标 |

## 4. 角色与权限

| 角色 | 登录表 | 主要能力 |
| --- | --- | --- |
| 管理员 | `users` | 管理学生、教师、企业、实习、就业、公告、评论、字典、配置，查看全局看板 |
| 学生 | `xuesheng` | 查看个人信息、实习记录、就业记录、公告，维护自己发表的公告评论 |
| 老师 | `laoshi` | 维护所属专业学生，查看学生实习与就业，发布公告，查看公告评论 |
| 企业 | `qiye` | 维护企业信息，管理本企业实习记录，新增就业记录，发布招聘/实习公告，维护评论 |

鉴权机制：

- 登录接口返回 Token。
- 前端在后续请求头中携带 `Token`。
- `AuthorizationInterceptor` 根据 Token 查询 `token` 表。
- 后端将 `userId`、`role`、`tableName`、`username` 写入 Session。
- 标注 `@IgnoreAuth` 的接口跳过登录校验。

## 5. 数据模型

核心业务表：

| 表名 | 说明 |
| --- | --- |
| `users` | 管理员账号 |
| `xuesheng` | 学生档案 |
| `laoshi` | 教师档案 |
| `qiye` | 企业档案 |
| `shixi` | 实习信息 |
| `jiuye` | 就业信息 |
| `gonggao` | 公告 |
| `gonggao_comment` | 公告评论 |
| `dictionary` | 数据字典 |
| `config` | 系统配置 |
| `token` | 登录令牌 |

主要唯一约束：

- 学生：账号、学号、手机号、身份证号唯一。
- 教师：账号、工号、手机号、身份证号唯一。
- 企业：账号、企业编号、联系方式、邮箱唯一。
- 公告：同一发布者下公告标题唯一。
- 就业：同一学生、企业、入职日期组合唯一。

## 6. 功能模块

### 6.1 管理员端

管理员端提供全局数据维护能力：

- 首页数据看板。
- 学生管理：新增、编辑、查询、详情、批量导入。
- 教师管理：新增、编辑、查询、详情、批量导入。
- 企业管理：新增、编辑、查询、详情、批量导入。
- 实习管理：维护学生、企业、实习类型、周期、岗位、结果和详情。
- 就业管理：维护学生、企业、入职岗位、入职日期和备注。
- 公告管理：发布和维护系统公告。
- 公告评论：查看和删除评论。
- 字典管理：维护院系、专业、班级、性别、行业、公告类型、实习类型等枚举。
- 系统配置：维护运行配置项。

### 6.2 学生端

学生端重点展示个人相关数据：

- 首页工作台。
- 个人信息。
- 修改密码。
- 我的实习：只读查看个人实习记录。
- 我的就业：只读查看个人就业记录。
- 公告信息：查看学校、教师和企业公告。
- 我的评论：新增、修改、删除自己发表的评论。

### 6.3 教师端

教师端面向专业或院系维度的管理：

- 首页工作台。
- 个人信息。
- 修改密码。
- 学生管理：维护当前教师所属专业学生，新增学生默认归属当前教师专业。
- 实习情况：只读查看所属专业学生实习情况。
- 就业情况：只读查看所属专业毕业生就业情况。
- 我的公告：发布和维护当前教师公告。
- 公告评论：查看别人对自己公告的评论。
- 我的评论：维护当前教师发表的评论。
- 其他公告：查看其他发布者公告。

### 6.4 企业端

企业端面向校企合作和就业数据录入：

- 首页工作台。
- 企业信息维护。
- 实习管理：维护本企业实习学生、岗位、周期和结果。
- 就业管理：新增本企业就业记录，查看就业学生信息。
- 招聘公告：发布和维护本企业公告。
- 公告评论：维护当前企业账号发表的评论。

## 7. 接口概览

统一前缀：

```text
/biyeshengshixiyujiuye
```

### 7.1 账号接口

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

### 7.2 业务 CRUD

常见接口模式：

```text
/{module}/page
/{module}/info/{id}
/{module}/save
/{module}/update
/{module}/delete
/{module}/batchInsert
```

适用模块：

```text
xuesheng
laoshi
qiye
shixi
jiuye
dictionary
```

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

### 7.3 Dashboard 接口

```text
GET /dashboard/base
GET /dashboard/shixiType
GET /dashboard/employmentRate
GET /dashboard/shixiResult
GET /dashboard/monthTrend
GET /dashboard/companyTop
GET /dashboard/summary
```

### 7.4 通用统计接口

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

## 8. 启动与构建

### 8.1 数据库

```bash
mysql -u root -p < db.sql
```

### 8.2 后端开发启动

```bash
cd biyeshengshixiyujiuye
mvn spring-boot:run
```

### 8.3 前端开发启动

```bash
cd biyeshengshixiyujiuye/src/main/resources/admin/admin
npm install
npm run dev
```

### 8.4 生产构建

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

## 9. 默认数据

`db.sql` 已包含基础字典、学生、教师、企业、实习、就业、公告和评论示例数据。

常用默认账号：

| 角色 | 账号 | 密码 |
| --- | --- | --- |
| 管理员 | admin | admin |
| 学生 | 20210001 | 123456 |
| 老师 | T2020001 | 123456 |
| 企业 | QY001 | 123456 |

## 10. 运维与部署建议

- 使用 Spring Profile 区分开发、测试和生产环境配置。
- 生产数据库账号使用最小权限，避免直接使用 root。
- 密码当前为明文示例数据，正式环境应改为安全散列存储。
- Token 表已有过期时间字段，建议补充强制过期、刷新和踢出策略。
- CORS 当前适合开发环境，生产应限制允许来源。
- 文件上传建议增加类型白名单、大小限制和病毒扫描。
- 上传资源建议由 Nginx、对象存储或独立静态资源服务托管。
- DAO SQL 日志生产环境建议关闭 debug。
- 字典数据启动时缓存到 ServletContext，修改字典后如前端展示异常，可重启后端刷新缓存。

## 11. 二次开发说明

新增业务模块时建议按以下步骤扩展：

1. 新增数据库表和种子数据。
2. 新增 Entity、Model、VO、View。
3. 新增 Dao 接口和 Mapper XML。
4. 新增 Service 和 ServiceImpl。
5. 新增 Controller，保持 `/page`、`/info/{id}`、`/save`、`/update`、`/delete` 的接口风格。
6. 在前端 `src/api/` 中新增 API 封装。
7. 在对应角色的 `views/*/crud/modules.js` 中注册字段、表格列、搜索项和操作权限。
8. 在 `router/index.js` 和角色导航数据中注册路由与菜单。

## 12. 已知限制

- MyBatis-Plus 版本为 2.x，不能直接使用 3.x 的 `LambdaQueryWrapper` 写法。
- 示例项目未引入 Swagger/OpenAPI，接口文档以代码和本文件为准。
- 文件上传路径和类型校验仍需生产化加固。
- 通用统计接口允许动态表名和字段名，公开部署时需要额外限制调用范围。
- 当前仓库保留部分设计过程文档和 Playwright 验证产物，交付发布时可按需清理。
