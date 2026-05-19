# 基于Spring Boot的毕业生实习与就业管理系统

---

## 🚀 项目简介

本系统是一个面向**高校、企业和学生**三端的实习与就业全生命周期管理平台，旨在解决传统实习管理中信息不对称、审批流程繁琐、数据统计困难等痛点。

系统支持**学生、教师、企业、管理员**四种角色登录，提供实习信息登记与跟踪、就业信息管理、多端公告发布、数据可视化统计等核心功能。通过自定义 Token 鉴权拦截器实现多角色权限隔离，结合百度 AI 人脸比对实现身份核验，同时集成 Apache POI 提供 Excel 批量导入能力，覆盖从实习申请到就业归档的完整业务闭环。

**适用场景**：高校毕业实习管理、校企合作对接、就业信息跟踪与统计分析。

---

## 🛠️ 技术选型

### 后端

| 技术 | 版本 | 说明 |
|------|------|------|
| **Spring Boot** | 2.2.2.RELEASE | 核心框架，提供自动配置、内嵌 Tomcat、快速开发能力 |
| **MyBatis-Plus** | 2.3 | ORM 框架，简化单表 CRUD，提供分页插件与逻辑删除支持（**注意：本项目使用 2.x 遗留 API，不支持 3.x LambdaQueryWrapper**） |
| **MySQL** | 5.7+ | 关系型数据库，存储业务数据与字典配置 |
| **Apache Shiro** | 1.3.2 | 引入但未直接使用，鉴权由自定义 `AuthorizationInterceptor` + Token 表实现 |
| **Apache POI** | 3.9 | Excel 导入/导出，支持学生信息批量导入 |
| **Baidu AI SDK** | 4.4.1 | 人脸比对功能，基于百度云 API 实现身份核验 |
| **Hutool** | 4.0.12 | Java 工具类库，简化日期、字符串等操作 |
| **FastJSON** | 1.2.8 | JSON 序列化/反序列化 |
| **Thymeleaf** | — | 静态资源渲染模板引擎（主要用于前后端同构部署时的页面路由） |

### 前端

| 技术 | 版本 | 说明 |
|------|------|------|
| **Vue** | 2.6.10 | 前端核心框架 |
| **Element UI** | 2.13.0 | UI 组件库，提供表单、表格、弹窗等丰富组件 |
| **ECharts** | 4.6.0 | 数据可视化图表库 |
| **Axios** | 0.19.2 | HTTP 请求库 |
| **vue-router** | 3.1.5 | 前端路由管理 |
| **vue-amap** | 0.5.10 | 高德地图集成，用于地理位置选择与展示 |

### 工具与中间件

| 技术 | 说明 |
|------|------|
| **Maven** | 项目构建与依赖管理 |
| **Spring Boot DevTools** | 开发热部署，代码修改后自动重启 |
| **Spring Boot Log** | 集成日志，DAO 层 SQL 调试输出 (`logging.level.com.dao=debug`) |

---

## 📦 核心功能模块

### 1. 多角色用户管理

- **四类角色**：管理员（`users`）、学生（`xuesheng`）、教师（`laoshi`）、企业（`qiye`），每类角色拥有独立的数据表与登录接口
- **自定义 Token 鉴权**：通过 `AuthorizationInterceptor` 拦截请求，校验 HTTP Header 中的 `Token` 字段，将 `userId`、`role`、`tableName`、`username` 写入 Session；使用 `@IgnoreAuth` 注解开放免登录接口
- **数据隔离**：各角色仅能访问自身数据（如学生只能查看/修改自己的实习与就业记录）

### 2. 实习信息管理（Shixi）

- 学生创建实习记录，关联企业与岗位信息，设定实习起止时间
- 教师可查看所带学生的实习情况，跟踪实习结果（优秀/一般/差评）
- 企业可维护本企业的实习岗位信息，发布实习公告

### 3. 就业信息管理（Jiuye）

- 记录学生就业信息，包括入职企业、岗位名称、入职时间、合同附件等
- 支持文件上传与下载，就业记录的增删改查均基于角色权限过滤

### 4. 公告管理

- **教师公告**（`gonggao_laoshi`）：教师向学生发布通知与指导信息
- **企业公告**（`gonggao_qiye`）：企业发布招聘公告与实习通知
- 公告类型通过字典系统动态管理，支持灵活分类

### 5. 数据字典系统

- `DictionaryEntity` + `DictionaryServletContextListener` 在应用启动时将所有字典数据加载到 `ServletContext`，实现全局枚举值的快速映射
- 支持字段类型：性别、院系、班级、公告类型、企业行业、实习类型、实习结果等
- 控制层提供完整的 CRUD 与批量导入接口

### 6. 统计与可视化

- `CommonController` 提供通用统计接口：分组统计（`/group`）、数值求和（`/cal`）、柱状图数据（`/barSum`, `/barCount`）、日期维度统计等
- 前端通过 ECharts 渲染可视化图表，支持实习数据、就业数据的多维分析

### 7. 文件与图片管理

- `FileController` 处理文件上传，存储至 `classpath:static/upload/`，以时间戳命名防冲突
- 支持头像、企业图片、就业附件等多种文件类型，上传大小限制可配置（默认 1000MB）

### 8. 人脸比对

- 集成百度 AI 人脸识别 SDK，通过 `CommonController.matchFace` 接口实现双人脸比对
- API Key 与 Secret Key 存储在 `config` 数据库表中，运行时按需读取
- 配合高德地图 API（`/location`）提供地理位置服务

### 9. Excel 批量导入

- 各主要实体（学生、就业等）均支持通过 Apache POI 从 `.xls` 文件批量导入数据
- 接口路径：`/{entity}/batchInsert`

---

## 📂 项目目录结构

```
biyeshengshixiyujiuye/
├── db.sql                                    # 数据库初始化脚本（建表+种子数据）
├── pom.xml                                   # Maven 依赖配置
├── src/
│   ├── main/
│   │   ├── java/com/
│   │   │   ├── annotation/                   # 自定义注解
│   │   │   │   ├── IgnoreAuth.java           #   免鉴权注解（跳过Token校验）
│   │   │   │   ├── LoginUser.java            #   登录用户参数注入
│   │   │   │   └── APPLoginUser.java         #   App端登录用户注入
│   │   │   ├── config/                       # 配置类
│   │   │   │   ├── InterceptorConfig.java     #   拦截器注册 + 静态资源映射
│   │   │   │   ├── MybatisPlusConfig.java     #   MyBatis-Plus 分页插件配置
│   │   │   │   └── MyMetaObjectHandler.java   #   字段自动填充（createTime）
│   │   │   ├── controller/                   # 控制层（REST API）
│   │   │   │   ├── CommonController.java      #   通用接口（统计/图表/人脸/定位）
│   │   │   │   ├── ConfigController.java      #   系统配置管理
│   │   │   │   ├── DictionaryController.java  #   数据字典管理
│   │   │   │   ├── FileController.java         #   文件上传/下载
│   │   │   │   ├── JiuyeController.java       #   就业信息管理
│   │   │   │   ├── UsersController.java        #   管理员登录/CRUD
│   │   │   │   └── XueshengController.java     #   学生登录/注册/CRUD
│   │   │   ├── dao/                           # 数据访问层（MyBatis-Plus Mapper）
│   │   │   ├── entity/                        # 实体类
│   │   │   │   ├── XueshengEntity.java        #   学生实体
│   │   │   │   ├── LaoshiEntity.java           #   教师实体
│   │   │   │   ├── QiyeEntity.java            #   企业实体
│   │   │   │   ├── ShixiEntity.java            #   实习记录实体
│   │   │   │   ├── JiuyeEntity.java            #   就业记录实体
│   │   │   │   ├── GonggaoLaoshiEntity.java    #   教师公告实体
│   │   │   │   ├── GonggaoQiyeEntity.java      #   企业公告实体
│   │   │   │   ├── DictionaryEntity.java       #   数据字典实体
│   │   │   │   ├── TokenEntity.java            #   鉴权令牌实体
│   │   │   │   ├── UsersEntity.java            #   管理员实体
│   │   │   │   ├── ConfigEntity.java           #   系统配置实体
│   │   │   │   ├── EIException.java            #   自定义业务异常
│   │   │   │   ├── model/                      #   业务模型（接收前端参数）
│   │   │   │   ├── vo/                         #   视图对象（返回前端数据）
│   │   │   │   └── view/                       #   数据库视图对象
│   │   │   ├── interceptor/                    # 拦截器
│   │   │   │   └── AuthorizationInterceptor.java  # Token鉴权拦截器
│   │   │   ├── ServletContextListener/         # 监听器
│   │   │   │   └── DictionaryServletContextListener.java  # 启动时加载字典
│   │   │   ├── service/                        # 服务接口
│   │   │   │   └── impl/                       #   服务实现类
│   │   │   ├── thread/                         # 异步线程
│   │   │   │   └── MyThreadMethod.java         #   后台定时任务（预留）
│   │   │   ├── utils/                          # 工具类
│   │   │   │   ├── BaiduUtil.java              #   百度API认证
│   │   │   │   ├── PoiUtil.java                #   Excel导入工具
│   │   │   │   ├── R.java                      #   统一响应封装
│   │   │   │   ├── PageUtils.java              #   分页封装
│   │   │   │   ├── MPUtil.java                 #   MyBatis-Plus查询工具
│   │   │   │   └── ...                         #   其他工具类
│   │   │   └── biyeshengshixiyujiuyeApplication.java  # Spring Boot 启动类
│   │   └── resources/
│   │       ├── application.yml                 # 主配置文件
│   │       ├── mapper/                         # MyBatis XML映射文件
│   │       │   ├── XueshengDao.xml
│   │       │   ├── JiuyeDao.xml
│   │       │   └── ...
│   │       ├── static/                          # 静态资源（上传文件目录）
│   │       └── admin/admin/                     # 前端Vue2项目（内嵌）
│   │           ├── package.json                 # 前端依赖配置
│   │           ├── vue.config.js                # Vue CLI配置（代理/API前缀）
│   │           └── src/                          # 前端源码
│   │               ├── App.vue                  # 根组件
│   │               ├── main.js                  # 入口文件
│   │               ├── router/                   # 路由配置
│   │               ├── views/                    # 页面组件
│   │               └── utils/                    # 前端工具
│   └── test/                                    # 测试目录（当前为空）
├── db.sql                                       # 数据库初始化脚本
└── README.md                                    # 项目说明文档
```

---

## 🏃‍♂️ 快速启动

### 环境准备

| 依赖 | 最低版本 | 推荐版本 | 说明 |
|------|---------|---------|------|
| **JDK** | 1.8 | 1.8 | 项目基于 Java 8 编译，不兼容更高版本语法 |
| **Maven** | 3.3+ | 3.6+ | 后端构建工具 |
| **MySQL** | 5.7 | 5.7+ | 数据库，需设置字符集为 `utf8mb4` |
| **Node.js** | 10.x | 12.x+ | 前端构建环境 |
| **cnpm** | — | 最新 | 淘宝 NPM 镜像，加速依赖安装 |

### 1. 数据库初始化

```bash
# 登录 MySQL
mysql -u root -p

# 执行初始化脚本（包含建库、建表、种子数据）
source /path/to/db.sql;
```

脚本将自动创建数据库 `biyeshengshixiyujiuye` 并导入所有表结构与初始数据。

> **默认账号**：管理员 `admin` / `admin`，其余角色密码均为 `123456`

### 2. 修改后端配置

编辑 `biyeshengshixiyujiuye/src/main/resources/application.yml`：

```yaml
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/biyeshengshixiyujiuye?useUnicode=true&characterEncoding=utf-8&serverTimezone=GMT%2B8
    username: root          # 修改为你的数据库用户名
    password: 123456        # 修改为你的数据库密码
```

### 3. 启动后端

```bash
cd biyeshengshixiyujiuye

# 编译打包（可选，首次运行建议先编译）
mvn clean package -DskipTests

# 启动 Spring Boot（开发模式）
mvn spring-boot:run
```

后端服务启动于 **http://localhost:8080/biyeshengshixiyujiuye**

### 4. 启动前端（开发模式）

```bash
cd biyeshengshixiyujiuye/src/main/resources/admin/admin

# 安装依赖（使用 cnpm 加速）
cnpm install

# 启动开发服务器（端口 8081，自动代理后端 API）
cnpm run serve
```

前端开发服务器启动于 **http://localhost:8081**，自动将 `/biyeshengshixiyujiuye` 前缀的 API 请求代理至 `localhost:8080`。

### 5. 生产构建

```bash
# 前端构建
cd biyeshengshixiyujiuye/src/main/resources/admin/admin
cnpm run build
# 构建产物输出至 dist/，可部署至 Nginx 或放入 Spring Boot static 目录
```

```bash
# 后端打包
cd biyeshengshixiyujiuye
mvn clean package -DskipTests
# 产物：target/biyeshengshixiyujiuye-0.0.1-SNAPSHOT.jar
java -jar target/biyeshengshixiyujiuye-0.0.1-SNAPSHOT.jar
```

---

## 🔒 部署与优化建议

### 生产环境配置

- **配置分离**：建议使用 Spring Profile（`application-prod.yml`）分离生产配置，避免将数据库密码等敏感信息硬编码在代码仓库中
- **端口与上下文**：生产环境建议修改默认端口（`8080`）和上下文路径（`/biyeshengshixiyujiuye`），降低被扫描风险
- **文件上传限制**：当前 `max-file-size` 设为 `1000MB`，生产环境建议根据实际需求缩小限制，防止恶意大文件攻击

### 安全加固

- **密码存储**：当前密码以明文存储，生产环境应使用 **BCrypt** 或 **MD5+Salt** 加密
- **Token 过期**：`TokenEntity` 已有 `expiratedtime` 字段但未做严格强制刷新，建议增加 Token 自动续期与强制过期策略
- **CORS 配置**：`AuthorizationInterceptor` 中设置了全开放 CORS 头 (`Access-Control-Allow-Origin: *`)，生产环境应限制为可信域名
- **SQL 注入**：`SQLFilter` 工具类已做基础过滤，但仍建议对所有动态查询参数做入参校验
- **文件上传**：文件上传路径白名单机制需补充，防止路径穿越攻击

### 性能优化

- **数据库连接池**：默认使用 HikariCP，建议根据并发量调整 `maximum-pool-size` 和 `minimum-idle`
- **字典缓存**：当前 `DictionaryServletContextListener` 在启动时将字典加载到内存，避免了每次查询数据库，但更新字典后需重启应用才生效，建议引入 Redis 做分布式缓存
- **日志级别**：DAO 层当前设置为 `debug` 级别（输出完整 SQL），生产环境应切换为 `warn` 或 `info`
- **静态资源**：生产环境建议使用 **Nginx** 托管前端静态资源与上传文件，Spring Boot 仅提供 API 服务

### 架构演进方向

- **认证升级**：将自定义 Token 拦截器升级为 **Spring Security + JWT** 标准方案，支持 OAuth2 集成
- **ORM 升级**：MyBatis-Plus 2.x 已停止维护，建议升级至 **3.x** 版本，使用 `LambdaQueryWrapper` 替换 `EntityWrapper`
- **接口规范**：引入 **Swagger/OpenAPI** 生成接口文档，统一 `R` 响应格式，增加全局异常处理
- **消息通知**：集成邮件/短信通知模块，替代当前空实现的 `MyThreadMethod` 后台线程

---

## 📝 许可证

本项目仅供学习与参考使用。