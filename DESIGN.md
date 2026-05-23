# 前端设计依据：后端能力说明

本文档用于前端页面设计前理解后端已经具备的业务能力、数据支持和接口边界。它不规定前端必须生成哪些页面或采用什么视觉风格，只说明后端可以为前端提供哪些功能。

## 1. 系统定位

本项目后端是“毕业生实习与就业管理系统”的 Spring Boot 服务，面向管理员、学生、老师、企业四类角色提供统一 API。核心业务围绕学生基础信息、企业信息、老师信息、实习记录、就业记录、公告、公告评论、字典枚举、文件上传和统计看板展开。

后端服务默认运行在：

```text
http://localhost:8080/biyeshengshixiyujiuye
```

所有业务接口都基于该 context path 访问。

## 2. 通用接口约定

### 2.1 响应格式

后端统一使用 `R` 对象返回数据：

```json
{
  "code": 0,
  "data": {},
  "msg": "可选提示"
}
```

主要约定：

- `code = 0` 表示成功。
- `code = 401` 表示未登录或 Token 无效。
- `code = 403` 表示当前用户无权限执行该操作。
- `code = 500` 表示通用异常。
- 部分业务校验失败会返回 `code = 511`，例如数据不存在、必填项为空、重复提交等。

### 2.2 鉴权方式

后端使用自定义 Token 鉴权，不是 JWT。

登录成功后，接口会返回 `token`。后续需要鉴权的请求需要在 HTTP Header 中携带：

```text
Token: 登录接口返回的 token
```

后端拦截器会根据 Token 查询 `token` 表，并把以下信息写入 Session：

- `userId`
- `role`
- `tableName`
- `username`

这些信息会影响部分接口的数据范围和自动填充逻辑，例如公告发布者、评论人、当前登录用户信息等。

### 2.3 跨域支持

后端拦截器已设置跨域响应头，允许前端跨域调用，并允许携带 `Token`、`Content-Type`、`authorization` 等请求头。开发环境中前端可以直接通过 API 前缀访问后端。

### 2.4 分页数据

主要业务模块的 `/page` 接口返回分页对象，通常放在 `data` 字段内。分页对象一般包含：

- `list`：当前页数据
- `total`：总条数
- `pageSize`：每页数量
- `currPage`：当前页
- `totalPage`：总页数

常用查询参数包括：

- `page`
- `limit`
- `sort`
- `order`
- 各业务字段的模糊查询条件

## 3. 角色与账号能力

### 3.1 管理员

管理员数据存放在 `users` 表，默认账号为：

```text
admin / admin
```

后端提供的管理员能力：

- 管理员登录、注册、退出、重置密码。
- 查询当前管理员 Session 信息。
- 管理后台账号数据。
- 访问通用数据管理接口。
- 管理字典、配置、学生、老师、企业、实习、就业、公告、评论等数据。
- 管理员在评论模块中可以管理所有评论。

主要接口前缀：

```text
/users
```

### 3.2 学生

学生数据存放在 `xuesheng` 表。学生账号字段为 `username`，同时保存学号、姓名、手机号、身份证号、头像、性别、院系、班级、入学年份、邮箱等信息。

后端提供的学生能力：

- 学生登录、注册、退出、重置密码。
- 查询当前学生 Session 信息。
- 学生信息分页查询、详情查询、新增、修改、删除、批量导入。
- 为实习、就业、公告评论等业务提供学生关联数据。
- 支持按姓名、学号、手机号、身份证号、院系、班级、入学年份等条件查询。

主要接口前缀：

```text
/xuesheng
```

### 3.3 老师

老师数据存放在 `laoshi` 表。老师账号字段为 `username`，同时保存工号、姓名、手机号、身份证号、头像、性别、邮箱等信息。

后端提供的老师能力：

- 老师登录、注册、退出、重置密码。
- 查询当前老师 Session 信息。
- 老师信息分页查询、详情查询、新增、修改、删除、批量导入。
- 老师可以作为公告发布者和评论人。

主要接口前缀：

```text
/laoshi
```

### 3.4 企业

企业数据存放在 `qiye` 表。企业账号字段为 `username`，同时保存企业编号、企业名称、地址、图片、联系方式、邮箱、行业、企业详情等信息。

后端提供的企业能力：

- 企业登录、注册、退出、重置密码。
- 查询当前企业 Session 信息。
- 企业信息分页查询、详情查询、新增、修改、删除、批量导入。
- 企业可以被实习记录和就业记录关联。
- 企业可以作为公告发布者和评论人。
- 企业行业由字典 `qiye_types` 提供。

主要接口前缀：

```text
/qiye
```

## 4. 业务模块能力

### 4.1 学生信息

后端支持维护学生基础档案。

核心字段：

- 账号、密码
- 学号
- 姓名
- 手机号
- 身份证号
- 头像
- 性别
- 院系
- 班级
- 入学年份
- 邮箱
- 创建时间

可提供的支持：

- 学生列表分页。
- 学生详情。
- 学生新增、修改、删除。
- 学生注册。
- Excel 批量导入。
- 学生维度的实习、就业关联查询。
- 基于字典返回性别、院系、班级的中文名称。

### 4.2 老师信息

后端支持维护老师基础档案。

核心字段：

- 账号、密码
- 工号
- 姓名
- 手机号
- 身份证号
- 头像
- 性别
- 邮箱
- 创建时间

可提供的支持：

- 老师列表分页。
- 老师详情。
- 老师新增、修改、删除。
- 老师注册。
- Excel 批量导入。
- 作为公告发布者、公告评论人参与公告互动。

### 4.3 企业信息

后端支持维护企业基础档案。

核心字段：

- 账号、密码
- 企业编号
- 企业名称
- 企业地址
- 企业图片
- 企业联系方式
- 企业邮箱
- 所在行业
- 企业详情
- 创建时间

可提供的支持：

- 企业列表分页。
- 企业详情。
- 企业新增、修改、删除。
- 企业注册。
- Excel 批量导入。
- 行业字典映射。
- 作为实习单位、就业单位参与业务关联。
- 作为公告发布者、公告评论人参与公告互动。

### 4.4 实习信息

实习数据存放在 `shixi` 表，关联学生和企业。

核心字段：

- 学生 ID
- 企业 ID
- 实习名称
- 实习类型
- 实习开始日期
- 实习结束日期
- 实习结果
- 实习岗位
- 实习详情
- 创建时间

可提供的支持：

- 实习列表分页。
- 实习详情。
- 实习新增、修改、删除。
- Excel 批量导入。
- 关联返回学生信息，例如学生姓名、学号、手机号等。
- 关联返回企业信息，例如企业名称、企业编号、企业地址等。
- 实习类型字典映射。
- 实习结果字典映射。
- 支持按学生、企业、实习名称、实习类型、实习结果等维度查询。
- 支持作为统计看板的数据来源。

字典来源：

- `shixi_types`：实习类型。
- `shixi_jieguo_types`：实习结果。

### 4.5 就业信息

就业数据存放在 `jiuye` 表，关联学生和企业。

核心字段：

- 学生 ID
- 企业 ID
- 入职日期
- 入职岗位
- 相关文件
- 就业备注
- 创建时间

可提供的支持：

- 就业列表分页。
- 就业详情。
- 就业新增、修改、删除。
- Excel 批量导入。
- 关联返回学生信息，例如学生姓名、学号、手机号等。
- 关联返回企业信息，例如企业名称、企业编号、企业地址等。
- 支持就业附件文件地址保存。
- 支持作为就业率、企业就业 Top、月度趋势等统计的数据来源。

### 4.6 公告

公告数据存放在 `gonggao` 表。公告采用统一模型，发布者可以是管理员、老师或企业。

核心字段：

- 发布者 ID
- 发布者表名
- 发布者身份
- 公告标题
- 公告类型
- 公告发布日期
- 公告内容
- 创建时间

可提供的支持：

- 公告列表分页。
- 公告详情。
- 公告新增、修改、删除。
- 按发布者身份区分公告来源。
- 关联返回发布者名称。
- 公告类型字典映射。
- 支持教学通知、就业提醒、招聘信息、实习推荐、系统公告等分类。

字典来源：

- `gonggao_types`：公告类型。

### 4.7 公告评论

公告评论数据存放在 `gonggao_comment` 表，关联公告和评论人。

核心字段：

- 公告 ID
- 评论人 ID
- 评论人表名
- 评论人身份
- 评论人名称
- 评论内容
- 创建时间
- 更新时间

可提供的支持：

- 评论列表分页。
- 评论详情。
- 评论新增、修改、删除。
- 新增评论时，后端会根据当前登录 Session 自动填充评论人 ID、角色、表名和名称。
- 修改和删除评论时，非管理员只能管理自己的评论。
- 管理员可以管理所有评论。
- 支持 `myOnly=true` 查询当前登录用户自己的评论。

### 4.8 数据字典

字典数据存放在 `dictionary` 表。应用启动时会把字典加载到 ServletContext 中，供业务数据做中文名称映射。

后端已有字典类型：

- `sex_types`：性别类型。
- `yuanxi_types`：院系。
- `banji_types`：班级。
- `gonggao_types`：公告类型。
- `qiye_types`：企业行业。
- `shixi_types`：实习信息类型。
- `shixi_jieguo_types`：实习结果。

可提供的支持：

- 字典分页查询。
- 字典详情。
- 字典新增、修改、删除。
- 查询某类字典最大编码。
- Excel 批量导入。
- 为学生、老师、企业、公告、实习等模块提供枚举值和中文展示名。

注意：当前字典缓存是在应用启动时加载，字典数据更新后，部分运行时缓存可能需要后端重启才完全同步。

### 4.9 系统配置

配置数据存放在 `config` 表。

核心字段：

- 配置名
- 配置值

可提供的支持：

- 配置分页查询。
- 配置列表查询。
- 配置详情。
- 按配置名查询配置。
- 配置新增、修改、删除。
- 为百度地图、百度 AI 人脸比对等能力提供运行时配置读取。

### 4.10 文件上传与下载

文件接口由 `FileController` 提供。

主要接口：

```text
POST /file/upload
GET  /file/download?fileName=xxx
```

可提供的支持：

- 上传头像、企业图片、就业附件、普通文件等。
- 文件保存到 `static/upload/`。
- 文件名会加时间戳，降低重名覆盖风险。
- 上传成功后返回可保存到业务表的文件路径。
- 支持文件下载。
- 后端配置的单文件和请求大小上限为 `1000MB`。

### 4.11 地理位置与人脸比对

通用接口中包含外部能力封装：

```text
/location
/matchFace
```

可提供的支持：

- `/location`：根据经纬度调用百度地图相关能力获取位置数据。
- `/matchFace`：调用百度 AI 人脸比对能力，对两张人脸图片做相似度比对。
- 相关 API Key、Secret Key 从配置表读取。

这些能力依赖外部服务配置是否完整。

## 5. 统计与看板能力

### 5.1 专用 Dashboard 接口

后端已经提供 `/dashboard` 下的专用统计接口。

```text
GET /dashboard/base
GET /dashboard/shixiType
GET /dashboard/employmentRate
GET /dashboard/shixiResult
GET /dashboard/monthTrend
GET /dashboard/companyTop
```

可提供的数据：

- 学生总数。
- 已毕业人数。
- 未毕业人数。
- 实习学生数。
- 就业学生数。
- 企业总数。
- 老师总数。
- 当月新增实习数。
- 已毕业就业率。
- 未毕业实习率。
- 实习类型分布。
- 实习结果分布。
- 当前年份按月实习趋势。
- 就业企业 Top10。

毕业判定逻辑：

```text
入学年份 + 4 年，且当年 6 月 1 日 <= 当前日期，则视为已毕业
```

### 5.2 通用统计接口

`CommonController` 还提供了多种通用统计能力：

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

可提供的支持：

- 对指定表做分组统计。
- 对指定数值字段做合计、最大值、最小值、平均值。
- 对指定字段做计数统计。
- 按日期维度做统计。
- 生成柱状图所需的数据结构。
- 根据字段和日期范围计算提醒数量。

这些接口参数较动态，适合做可配置图表、临时统计和后台运营分析。

## 6. 查询、关联与展示数据支持

后端 Mapper 已经为部分模块提供 View 查询，不只返回外键 ID，也会返回关联展示字段。

### 6.1 实习列表可获得的关联信息

实习列表可关联返回：

- 企业名称
- 企业编号
- 企业地址
- 企业图片
- 企业联系方式
- 企业邮箱
- 企业行业
- 企业详情
- 学生姓名
- 学生学号
- 学生手机号
- 学生身份证号
- 学生头像
- 学生性别
- 学生院系
- 学生班级
- 学生入学年份
- 学生邮箱

### 6.2 就业列表可获得的关联信息

就业列表可关联返回：

- 企业名称
- 企业编号
- 企业地址
- 企业图片
- 企业联系方式
- 企业邮箱
- 企业行业
- 企业详情
- 学生姓名
- 学生学号
- 学生手机号
- 学生身份证号
- 学生头像
- 学生性别
- 学生院系
- 学生班级
- 学生入学年份
- 学生邮箱

### 6.3 公告列表可获得的关联信息

公告列表可根据发布者表名返回发布者名称。当前公告发布者支持：

- `users`：管理员。
- `laoshi`：老师。
- `qiye`：企业。

### 6.4 评论列表可获得的关联信息

评论列表可根据评论人表名返回评论人名称。当前评论人支持：

- `xuesheng`：学生。
- `laoshi`：老师。
- `qiye`：企业。
- `users`：管理员。

## 7. 主要接口清单

### 7.1 账号与角色

```text
POST /users/login
POST /users/register
GET  /users/logout
GET  /users/resetPass
GET  /users/session

GET/POST /xuesheng/login
POST     /xuesheng/register
GET      /xuesheng/logout
GET      /xuesheng/resetPassword
GET      /xuesheng/resetPass
GET      /xuesheng/session

GET/POST /laoshi/login
POST     /laoshi/register
GET      /laoshi/logout
GET      /laoshi/resetPassword
GET      /laoshi/resetPass
GET      /laoshi/session

GET/POST /qiye/login
POST     /qiye/register
GET      /qiye/logout
GET      /qiye/resetPassword
GET      /qiye/resetPass
GET      /qiye/session
```

### 7.2 业务 CRUD

以下模块一般都支持分页、详情、新增、修改、删除：

```text
/xuesheng/page
/xuesheng/info/{id}
/xuesheng/save
/xuesheng/update
/xuesheng/delete
/xuesheng/batchInsert

/laoshi/page
/laoshi/info/{id}
/laoshi/save
/laoshi/update
/laoshi/delete
/laoshi/batchInsert

/qiye/page
/qiye/info/{id}
/qiye/save
/qiye/update
/qiye/delete
/qiye/batchInsert

/shixi/page
/shixi/info/{id}
/shixi/save
/shixi/update
/shixi/delete
/shixi/batchInsert

/jiuye/page
/jiuye/info/{id}
/jiuye/save
/jiuye/update
/jiuye/delete
/jiuye/batchInsert

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

/dictionary/page
/dictionary/info/{id}
/dictionary/save
/dictionary/update
/dictionary/delete
/dictionary/maxCodeIndex
/dictionary/batchInsert

/config/page
/config/list
/config/info/{id}
/config/detail/{id}
/config/info?name=xxx
/config/save
/config/update
/config/delete
```

## 8. 字段唯一性与数据约束

数据库层已经定义部分唯一约束，前端提交重复数据时后端可能抛出保存失败。

主要唯一约束：

- 学生：`username`、`xuesheng_xuehao`、`xuesheng_phone`、`xuesheng_id_number`。
- 老师：`username`、`laoshi_gonghao`、`laoshi_phone`、`laoshi_id_number`。
- 企业：`username`、`qiye_bianhao`、`qiye_phone`、`qiye_email`。
- 公告：同一发布者下公告标题唯一。
- 就业：同一学生、同一企业、同一入职日期唯一。

## 9. 后端当前限制

前端设计时需要知道以下后端边界：

- 密码当前是明文存储，后端没有密码强度校验。
- Token 表有过期时间字段，但拦截器当前主要根据 Token 是否存在判断登录状态。
- 字典缓存启动时加载，运行中更新字典后可能存在缓存同步问题。
- 文件上传路径较宽松，后端没有严格的文件类型白名单。
- 部分通用统计接口使用动态表名和字段名，适合后台受控调用，不适合作为公开匿名接口随意暴露。
- 删除类接口后端已存在，但实际产品操作中应结合业务确认流程使用。

## 10. 前端设计阶段可依赖的后端支撑

后端已经可以支撑以下前端业务需求：

- 多角色登录与基于 Token 的访问。
- 当前登录用户信息获取。
- 学生、老师、企业三类主体档案管理。
- 实习记录与学生、企业的关联展示。
- 就业记录与学生、企业的关联展示。
- 公告发布、分类、查询与详情展示。
- 公告评论、评论人自动识别、评论权限控制。
- 统一字典枚举，支撑下拉选项和中文标签展示。
- 文件上传、下载和附件路径保存。
- 实习、就业、企业、学生相关统计图表。
- Dashboard 首页所需的核心指标、分布图、趋势图和 Top 榜。

因此，前端在设计信息架构、交互流程和数据展示时，可以把后端视为一个已经具备基础业务闭环的 API 服务：它能提供真实业务数据、分页查询、关联展示字段、枚举字典、文件能力、身份信息和统计聚合数据。
