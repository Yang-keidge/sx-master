# 公告卡片与评论交互想法

## 界面想法

公告列表以一张张卡片展示。每张卡片展示公告标题、公告类型、发布者、发布日期、评论数量和简短内容摘要。

用户点击公告卡片后，不跳转页面，而是打开公告详情弹窗。弹窗上半部分展示公告标题、类型、发布者、发布日期和公告正文；评论区放在公告内容下面。

评论区展示当前公告的评论列表，支持登录用户在弹窗内发表评论。评论项展示评论人名称、身份、评论时间和评论内容。评论本人或管理员可以修改、删除评论。

## 后端适配情况

当前后端可以支撑这个交互：

- 公告卡片列表使用 `/gonggao/page`。
- 公告卡片可读取 `commentCount` 展示评论数量。
- 点击卡片后，弹窗公告详情使用 `/gonggao/info/{id}`。
- 弹窗底部评论列表使用 `/gonggaoComment/list` 或 `/gonggaoComment/page`，传入 `gonggaoId`。
- 发表评论使用 `/gonggaoComment/save`，请求体包含 `gonggaoId` 和 `gonggaoCommentContent`。
- 修改评论使用 `/gonggaoComment/update`，仅本人或管理员可操作。
- 删除评论使用 `/gonggaoComment/delete`，仅本人或管理员可操作。

## 推荐前端请求流程

1. 进入公告页面，请求 `/gonggao/page?page=1&limit=10` 渲染卡片列表。
2. 用户点击某张公告卡片，记录该公告 `id`。
3. 打开详情弹窗，请求 `/gonggao/info/{id}` 渲染公告正文。
4. 同时请求 `/gonggaoComment/list?gonggaoId={id}&page=1&limit=20` 渲染公告内容下方的评论区。
5. 用户提交评论后调用 `/gonggaoComment/save`，成功后重新请求评论列表，并刷新公告卡片的 `commentCount`。

## 需要注意

评论目前不是直接嵌入 `/gonggao/info/{id}` 返回，而是通过评论接口单独查询。这样弹窗可以先显示公告内容，再加载评论，交互更轻。

当前评论列表默认按 `create_time desc` 返回，也就是新评论在前。如果前端希望评论区按时间从旧到新展示，需要后端补充升序排序能力，或前端拿到本页数据后自行反转展示。
