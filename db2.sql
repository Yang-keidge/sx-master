/*
补充演示数据脚本
使用方式：先导入 db.sql，再导入本文件。
说明：
1. 本文件只新增数据，不删除、不覆盖 db.sql 中的原始数据。
2. 采用 INSERT IGNORE，重复导入时会跳过已存在主键或唯一键的数据。
3. 未改动学生端答辩账号 20210001（李明轩）的个人、实习、就业记录。
*/

/*!40101 SET NAMES utf8 */;

USE `biyeshengshixiyujiuye`;

START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS `seed_numbers`;
CREATE TEMPORARY TABLE `seed_numbers` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

INSERT INTO `seed_numbers`(`id`)
SELECT 13 + ones.n + tens.n * 10 AS id
FROM (
  SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
  UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
) ones
CROSS JOIN (
  SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
  UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
) tens
WHERE 13 + ones.n + tens.n * 10 <= 120;

/* 学生补充数据：新增 108 名学生，和 db.sql 原有 12 名合计 120 名左右。 */
INSERT IGNORE INTO `xuesheng`
(`id`,`username`,`password`,`xuesheng_xuehao`,`xuesheng_name`,`xuesheng_phone`,`xuesheng_id_number`,`xuesheng_photo`,`sex_types`,`yuanxi_types`,`zhuanye_types`,`banji_types`,`ruxue_year`,`xuesheng_email`,`create_time`)
SELECT
  s.id,
  s.student_no,
  '123456',
  s.student_no,
  CONCAT(
    ELT(1 + MOD(s.id, 24), '王','李','张','刘','陈','杨','赵','黄','周','吴','徐','孙','胡','朱','高','林','何','郭','马','罗','梁','宋','郑','谢'),
    ELT(1 + MOD(s.id * 3, 24), '梓','浩','思','雨','子','佳','宇','欣','俊','嘉','晨','若','诗','明','博','一','泽','文','昊','雅','睿','可','锦','语'),
    ELT(1 + MOD(s.id * 7, 24), '轩','然','涵','怡','航','豪','琪','宁','瑶','辰','洋','悦','峰','凡','菲','坤','彤','洁','鑫','瑞','瑜','杰','颖','森')
  ) AS xuesheng_name,
  CONCAT('138372', LPAD(s.id, 5, '0')) AS xuesheng_phone,
  CONCAT('410102',
    CASE
      WHEN s.id <= 60 THEN '2003'
      WHEN s.id <= 96 THEN '2004'
      ELSE '2005'
    END,
    LPAD(s.id, 8, '0')
  ) AS xuesheng_id_number,
  CONCAT('http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng', 1 + MOD(s.id, 12), '.jpg') AS xuesheng_photo,
  1 + MOD(s.id, 2) AS sex_types,
  CASE
    WHEN s.id BETWEEN 13 AND 72 THEN 1
    WHEN s.id BETWEEN 73 AND 84 THEN 2
    WHEN s.id BETWEEN 85 AND 96 THEN 4
    WHEN s.id BETWEEN 97 AND 108 THEN 3
    ELSE 1
  END AS yuanxi_types,
  CASE
    WHEN s.id BETWEEN 13 AND 52 THEN 1
    WHEN s.id BETWEEN 53 AND 72 THEN 2
    WHEN s.id BETWEEN 73 AND 84 THEN 3
    WHEN s.id BETWEEN 85 AND 96 THEN 7
    WHEN s.id BETWEEN 97 AND 108 THEN 8
    ELSE 2
  END AS zhuanye_types,
  CASE
    WHEN s.id BETWEEN 13 AND 52 THEN 1
    WHEN s.id BETWEEN 53 AND 72 THEN 2
    WHEN s.id BETWEEN 73 AND 84 THEN 8
    WHEN s.id BETWEEN 85 AND 96 THEN 9
    WHEN s.id BETWEEN 97 AND 108 THEN 10
    ELSE 11
  END AS banji_types,
  CASE
    WHEN s.id <= 60 THEN 2021
    WHEN s.id <= 96 THEN 2022
    ELSE 2023
  END AS ruxue_year,
  CONCAT(s.student_no, '@stu.hnxy.edu.cn') AS xuesheng_email,
  DATE_ADD('2025-06-01 08:30:00', INTERVAL MOD(s.id, 12) MONTH) AS create_time
FROM (
  SELECT
    n.id,
    CONCAT(
      CASE
        WHEN n.id <= 60 THEN '2021'
        WHEN n.id <= 96 THEN '2022'
        ELSE '2023'
      END,
      LPAD(n.id, 4, '0')
    ) AS student_no
  FROM `seed_numbers` n
) s;

/* QY001 郑州云启软件有限公司：新增 19 名实习学生，连同 db.sql 原有 1 名约 20 名。 */
INSERT IGNORE INTO `shixi`
(`id`,`xuesheng_id`,`qiye_id`,`shixi_name`,`shixi_types`,`shixi_kaishi_time`,`shixi_jieshu_time`,`shixi_jieguo_types`,`shixi_gangwei_name`,`shixi_content`,`create_time`)
SELECT
  1000 + r.xuesheng_id AS id,
  r.xuesheng_id,
  1 AS qiye_id,
  CONCAT('郑州云启软件项目实习-', DATE_FORMAT(r.start_date, '%Y%m')) AS shixi_name,
  3 AS shixi_types,
  r.start_date AS shixi_kaishi_time,
  DATE_ADD(r.start_date, INTERVAL 5 MONTH) AS shixi_jieshu_time,
  1 + MOD(r.xuesheng_id, 3) AS shixi_jieguo_types,
  ELT(1 + MOD(r.xuesheng_id, 4), 'Java开发实习生','前端开发实习生','测试开发实习生','数据运维实习生') AS shixi_gangwei_name,
  '参加郑州云启软件有限公司校企合作项目，完成业务模块开发、接口联调、测试和项目文档整理。' AS shixi_content,
  CONCAT(r.start_date, ' 09:00:00') AS create_time
FROM (
  SELECT
    n.id AS xuesheng_id,
    DATE_ADD('2025-06-05', INTERVAL
      CASE
        WHEN n.id - 13 = 0 THEN 0
        WHEN n.id - 13 BETWEEN 1 AND 3 THEN 1
        WHEN n.id - 13 = 4 THEN 2
        WHEN n.id - 13 BETWEEN 5 AND 7 THEN 3
        WHEN n.id - 13 = 8 THEN 4
        WHEN n.id - 13 BETWEEN 9 AND 10 THEN 5
        WHEN n.id - 13 = 11 THEN 6
        WHEN n.id - 13 BETWEEN 12 AND 13 THEN 7
        WHEN n.id - 13 = 14 THEN 8
        WHEN n.id - 13 BETWEEN 15 AND 16 THEN 9
        WHEN n.id - 13 = 17 THEN 10
        ELSE 11
      END MONTH
    ) AS start_date
  FROM `seed_numbers` n
  WHERE n.id BETWEEN 13 AND 31
) r;

/* 刘建华老师（T2020001，网络工程）名下学生：补充近 12 个月实习趋势波动。 */
INSERT IGNORE INTO `shixi`
(`id`,`xuesheng_id`,`qiye_id`,`shixi_name`,`shixi_types`,`shixi_kaishi_time`,`shixi_jieshu_time`,`shixi_jieguo_types`,`shixi_gangwei_name`,`shixi_content`,`create_time`)
SELECT
  2000 + r.xuesheng_id AS id,
  r.xuesheng_id,
  2 + MOD(r.xuesheng_id, 5) AS qiye_id,
  CONCAT('网络工程综合实习-', DATE_FORMAT(r.start_date, '%Y%m')) AS shixi_name,
  1 + MOD(r.xuesheng_id, 4) AS shixi_types,
  r.start_date AS shixi_kaishi_time,
  DATE_ADD(r.start_date, INTERVAL 4 MONTH) AS shixi_jieshu_time,
  1 + MOD(r.xuesheng_id, 3) AS shixi_jieguo_types,
  ELT(1 + MOD(r.xuesheng_id, 4), '网络运维实习生','后端开发实习生','实施工程师实习生','信息安全实习生') AS shixi_gangwei_name,
  '按学院专业实习计划进入企业岗位实践，参与系统部署、网络维护、需求整理和阶段汇报。' AS shixi_content,
  CONCAT(r.start_date, ' 09:00:00') AS create_time
FROM (
  SELECT
    n.id AS xuesheng_id,
    DATE_ADD('2025-06-08', INTERVAL
      CASE
        WHEN n.id - 32 = 0 THEN 0
        WHEN n.id - 32 BETWEEN 1 AND 2 THEN 1
        WHEN n.id - 32 BETWEEN 3 AND 5 THEN 3
        WHEN n.id - 32 = 6 THEN 4
        WHEN n.id - 32 BETWEEN 7 AND 9 THEN 5
        WHEN n.id - 32 BETWEEN 10 AND 11 THEN 6
        WHEN n.id - 32 BETWEEN 12 AND 13 THEN 7
        WHEN n.id - 32 = 14 THEN 8
        WHEN n.id - 32 BETWEEN 15 AND 17 THEN 9
        WHEN n.id - 32 = 18 THEN 10
        ELSE 11
      END MONTH
    ) AS start_date
  FROM `seed_numbers` n
  WHERE n.id BETWEEN 32 AND 52
) r;

/* 其他专业学生实习数据：丰富管理员端类型、结果、最新记录和年度趋势。 */
INSERT IGNORE INTO `shixi`
(`id`,`xuesheng_id`,`qiye_id`,`shixi_name`,`shixi_types`,`shixi_kaishi_time`,`shixi_jieshu_time`,`shixi_jieguo_types`,`shixi_gangwei_name`,`shixi_content`,`create_time`)
SELECT
  3000 + r.xuesheng_id AS id,
  r.xuesheng_id,
  2 + MOD(r.xuesheng_id, 5) AS qiye_id,
  CASE
    WHEN r.xuesheng_id BETWEEN 53 AND 72 THEN CONCAT('软件工程企业实习-', DATE_FORMAT(r.start_date, '%Y%m'))
    WHEN r.xuesheng_id BETWEEN 73 AND 84 THEN CONCAT('应用化学检测实习-', DATE_FORMAT(r.start_date, '%Y%m'))
    WHEN r.xuesheng_id BETWEEN 85 AND 96 THEN CONCAT('机械电子工程岗位实习-', DATE_FORMAT(r.start_date, '%Y%m'))
    WHEN r.xuesheng_id BETWEEN 97 AND 108 THEN CONCAT('会计财务综合实习-', DATE_FORMAT(r.start_date, '%Y%m'))
    ELSE CONCAT('软件工程项目实习-', DATE_FORMAT(r.start_date, '%Y%m'))
  END AS shixi_name,
  1 + MOD(r.xuesheng_id, 4) AS shixi_types,
  r.start_date AS shixi_kaishi_time,
  DATE_ADD(r.start_date, INTERVAL 4 MONTH) AS shixi_jieshu_time,
  1 + MOD(r.xuesheng_id, 3) AS shixi_jieguo_types,
  CASE
    WHEN r.xuesheng_id BETWEEN 53 AND 72 THEN ELT(1 + MOD(r.xuesheng_id, 4), 'Java开发实习生','软件测试实习生','前端开发实习生','产品助理实习生')
    WHEN r.xuesheng_id BETWEEN 73 AND 84 THEN ELT(1 + MOD(r.xuesheng_id, 3), '质检实习生','实验分析实习生','工艺助理实习生')
    WHEN r.xuesheng_id BETWEEN 85 AND 96 THEN ELT(1 + MOD(r.xuesheng_id, 3), '设备调试实习生','机械设计实习生','自动化运维实习生')
    WHEN r.xuesheng_id BETWEEN 97 AND 108 THEN ELT(1 + MOD(r.xuesheng_id, 3), '财务助理实习生','审计助理实习生','会计实习生')
    ELSE ELT(1 + MOD(r.xuesheng_id, 4), 'Java开发实习生','软件测试实习生','前端开发实习生','产品助理实习生')
  END AS shixi_gangwei_name,
  '结合专业方向参与企业岗位实践，完成导师安排的日报、周报、阶段总结和实习鉴定材料。' AS shixi_content,
  CONCAT(r.start_date, ' 09:00:00') AS create_time
FROM (
  SELECT
    n.id AS xuesheng_id,
    DATE_ADD('2025-06-10', INTERVAL
      CASE
        WHEN n.id - 53 BETWEEN 0 AND 5 THEN 0
        WHEN n.id - 53 BETWEEN 6 AND 8 THEN 1
        WHEN n.id - 53 BETWEEN 9 AND 15 THEN 2
        WHEN n.id - 53 BETWEEN 16 AND 19 THEN 3
        WHEN n.id - 53 BETWEEN 20 AND 27 THEN 4
        WHEN n.id - 53 BETWEEN 28 AND 32 THEN 5
        WHEN n.id - 53 BETWEEN 33 AND 38 THEN 6
        WHEN n.id - 53 BETWEEN 39 AND 48 THEN 7
        WHEN n.id - 53 BETWEEN 49 AND 52 THEN 8
        WHEN n.id - 53 BETWEEN 53 AND 61 THEN 9
        WHEN n.id - 53 BETWEEN 62 AND 64 THEN 10
        ELSE 11
      END MONTH
    ) AS start_date
  FROM `seed_numbers` n
  WHERE n.id BETWEEN 53 AND 120
) r;

/* 就业数据：补充 2021 级已毕业学生就业信息，丰富管理员就业率和企业 TOP。 */
INSERT IGNORE INTO `jiuye`
(`id`,`xuesheng_id`,`qiye_id`,`jiuye_kaishi_time`,`jiuye_gangwei_name`,`jiuye_file`,`jiuye_content`,`create_time`)
SELECT
  2000 + n.id AS id,
  n.id AS xuesheng_id,
  1 + MOD(n.id, 6) AS qiye_id,
  DATE_ADD('2026-07-01', INTERVAL MOD(n.id, 45) DAY) AS jiuye_kaishi_time,
  CASE
    WHEN 1 + MOD(n.id, 6) IN (1,4,6) THEN ELT(1 + MOD(n.id, 4), 'Java开发工程师','前端开发工程师','软件测试工程师','实施工程师')
    WHEN 1 + MOD(n.id, 6) = 2 THEN ELT(1 + MOD(n.id, 3), '化工分析员','质量检测员','工艺助理')
    WHEN 1 + MOD(n.id, 6) = 3 THEN ELT(1 + MOD(n.id, 3), '设备工程师','机械设计助理','自动化运维工程师')
    ELSE ELT(1 + MOD(n.id, 3), '财务助理','审计助理','会计专员')
  END AS jiuye_gangwei_name,
  'http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar' AS jiuye_file,
  '通过校园招聘或实习转正进入企业，岗位与学生专业方向基本匹配。' AS jiuye_content,
  DATE_ADD('2026-04-10 10:00:00', INTERVAL MOD(n.id - 13, 38) DAY) AS create_time
FROM `seed_numbers` n
WHERE n.id BETWEEN 13 AND 50;

/* 公告数据：覆盖管理员、QY001 企业端、刘建华老师端和其他发布者。 */
INSERT IGNORE INTO `gonggao`
(`id`,`fabuzhe_id`,`fabuzhe_table`,`fabuzhe_role`,`gonggao_name`,`gonggao_types`,`insert_time`,`gonggao_content`,`create_time`)
VALUES
(1001,6,'users','管理员','2026届毕业生实习材料归档安排',5,'2026-01-08','请各学院在1月20日前完成实习协议、岗位证明、实习鉴定表的系统归档，逾期数据将进入异常名单。','2026-01-08 09:00:00'),
(1002,6,'users','管理员','春季校园招聘会企业报名通知',3,'2026-02-18','学校春季校园招聘会拟于3月中旬举行，企业可通过系统提交岗位、专业要求和宣讲时段。','2026-02-18 09:30:00'),
(1003,6,'users','管理员','毕业去向统计口径说明',2,'2026-03-05','就业去向统计以劳动合同、三方协议、升学录取和自主创业材料为准，请师生按系统提示上传佐证。','2026-03-05 10:00:00'),
(1004,6,'users','管理员','实习过程月报填写提醒',4,'2026-03-28','已进入实习岗位的学生须在每月月底前提交实习月报，指导老师需在次月5日前完成评阅。','2026-03-28 10:30:00'),
(1005,6,'users','管理员','校企合作岗位质量回访安排',5,'2026-04-12','就业指导中心将对重点合作企业开展岗位质量回访，重点了解实习指导、薪资待遇和留用情况。','2026-04-12 09:10:00'),
(1006,6,'users','管理员','五一假期实习安全提示',1,'2026-04-25','假期留岗学生应遵守企业考勤和安全管理制度，外出须履行请假备案，保持通讯畅通。','2026-04-25 15:00:00'),
(1007,6,'users','管理员','2026届就业数据阶段核验通知',2,'2026-05-08','请各位老师于5月18日前完成学生就业数据阶段核验，重点核查单位名称、岗位、入职日期和附件材料。','2026-05-08 09:00:00'),
(1008,6,'users','管理员','优秀实习案例征集通知',4,'2026-05-20','学校将征集一批优秀实习案例用于就业质量展示，请企业和指导老师推荐表现突出的学生。','2026-05-20 11:00:00'),
(1101,1,'laoshi','老师','网络工程专业实习周报提交提醒',1,'2026-01-12','网络工程专业学生请按企业项目进度提交周报，内容包括本周任务、问题记录和下周计划。','2026-01-12 08:40:00'),
(1102,1,'laoshi','老师','网络工程毕业实习中期检查安排',4,'2026-02-26','刘建华老师将于3月上旬开展毕业实习中期检查，请各小组准备项目截图、接口文档和导师评价。','2026-02-26 14:00:00'),
(1103,1,'laoshi','老师','软件开发岗位简历修改集中辅导',2,'2026-03-16','本周四下午安排网络工程学生简历集中辅导，重点修改项目经历、技术栈描述和求职意向。','2026-03-16 09:20:00'),
(1104,1,'laoshi','老师','云启软件项目实习答辩分组通知',4,'2026-04-02','参加郑州云启软件有限公司项目实习的学生按小组进行阶段答辩，请提前提交演示环境地址。','2026-04-02 16:00:00'),
(1105,1,'laoshi','老师','网络工程学生就业材料补充说明',2,'2026-04-20','已签约学生请补充劳动合同扫描件，待签约学生需说明当前面试进展和目标岗位。','2026-04-20 10:00:00'),
(1106,1,'laoshi','老师','网络工程实习总结材料提交通知',1,'2026-05-15','请在5月25日前提交实习总结、企业导师评价和实习照片，材料将用于学院实习质量评估。','2026-05-15 09:30:00'),
(1201,1,'qiye','企业','郑州云启软件Java开发实习岗位说明',4,'2026-01-20','郑州云启软件有限公司开放Java开发实习岗位，面向网络工程、软件工程专业学生，提供项目导师带教。','2026-01-20 10:00:00'),
(1202,1,'qiye','企业','云启软件春季实习生转正考核安排',2,'2026-03-08','已在岗实习生将按项目贡献、代码质量、沟通协作和出勤情况进行转正考核。','2026-03-08 11:00:00'),
(1203,1,'qiye','企业','前端开发实习生补招通知',3,'2026-03-22','公司前端研发组补招Vue方向实习生，要求了解组件开发、接口联调和基础页面性能优化。','2026-03-22 09:30:00'),
(1204,1,'qiye','企业','云启软件项目演示环境维护提醒',1,'2026-04-11','实习同学请保持项目演示环境可访问，提交代码前完成自测并同步更新接口说明。','2026-04-11 15:30:00'),
(1205,1,'qiye','企业','测试开发实习岗位面试安排',3,'2026-05-06','测试开发方向实习岗位本周开展线上面试，请投递学生提前准备测试用例设计和缺陷分析案例。','2026-05-06 10:20:00'),
(1206,1,'qiye','企业','云启软件优秀实习生推荐名单公示',4,'2026-05-21','根据项目导师评价和阶段考核结果，公司拟推荐一批优秀实习生参与学校优秀案例评选。','2026-05-21 09:40:00'),
(1301,4,'qiye','企业','河南数科后端开发实习岗位扩招',4,'2026-03-12','河南数科信息技术有限公司后端开发实习岗位扩招，欢迎软件工程和网络工程学生报名。','2026-03-12 10:00:00'),
(1302,2,'qiye','企业','化工检测实习安全培训通知',1,'2026-03-18','进入实验室岗位前需完成安全培训和设备使用考核，未通过者不得独立开展检测工作。','2026-03-18 14:00:00'),
(1303,3,'qiye','企业','智能制造设备调试实习岗位开放',3,'2026-04-06','洛阳智造装备有限公司开放设备调试、自动化运维方向实习岗位，欢迎机械类学生投递。','2026-04-06 09:30:00'),
(1304,2,'laoshi','老师','财务管理专业就业材料核验提醒',2,'2026-04-15','请财务管理专业毕业生及时上传签约材料，辅导员将逐项核验单位信息和岗位信息。','2026-04-15 10:10:00');

/* 公告评论：补充老师端和企业端的互动内容，避开李明轩账号。 */
INSERT IGNORE INTO `gonggao_comment`
(`id`,`gonggao_id`,`pinglunren_id`,`pinglunren_table`,`pinglunren_role`,`pinglunren_name`,`gonggao_comment_content`,`create_time`,`update_time`)
VALUES
(1001,1102,13,'xuesheng','学生','李语宁','老师，中期检查是否需要提交企业导师签字版材料？','2026-02-26 16:20:00','2026-02-26 16:20:00'),
(1002,1102,17,'xuesheng','学生','杨雅怡','项目演示可以使用测试环境地址吗？','2026-02-27 09:10:00','2026-02-27 09:10:00'),
(1003,1103,22,'xuesheng','学生','宋晨杰','简历辅导当天能否带纸质版让老师批注？','2026-03-16 11:30:00','2026-03-16 11:30:00'),
(1004,1104,25,'xuesheng','学生','刘一瑜','答辩分组名单会提前在系统里公布吗？','2026-04-02 17:05:00','2026-04-02 17:05:00'),
(1005,1105,28,'xuesheng','学生','周锦森','劳动合同附件大小超过限制应该怎么处理？','2026-04-20 13:30:00','2026-04-20 13:30:00'),
(1006,1106,31,'xuesheng','学生','高博洁','实习照片是否需要包含企业导师合影？','2026-05-15 15:10:00','2026-05-15 15:10:00'),
(1007,1201,14,'xuesheng','学生','张睿彤','请问Java开发岗位主要使用哪些项目框架？','2026-01-20 14:40:00','2026-01-20 14:40:00'),
(1008,1201,1,'qiye','企业','郑州云启软件有限公司','主要使用Spring Boot、MyBatis和Vue，入岗后会安排项目规范培训。','2026-01-20 15:00:00','2026-01-20 15:00:00'),
(1009,1202,19,'xuesheng','学生','罗佳悦','转正考核是否会参考平时周报完成情况？','2026-03-08 16:00:00','2026-03-08 16:00:00'),
(1010,1203,24,'xuesheng','学生','王梓轩','前端岗位是否接受网络工程专业学生投递？','2026-03-22 10:10:00','2026-03-22 10:10:00'),
(1011,1205,30,'xuesheng','学生','黄明菲','线上面试是否需要提前提交测试用例文档？','2026-05-06 13:50:00','2026-05-06 13:50:00'),
(1012,1206,29,'xuesheng','学生','赵诗航','优秀实习生推荐是否会同步到学校系统？','2026-05-21 11:05:00','2026-05-21 11:05:00'),
(1013,1007,2,'laoshi','老师','张晓梅','经管学院会在5月16日前完成第一轮核验。','2026-05-08 10:20:00','2026-05-08 10:20:00'),
(1014,1007,3,'laoshi','老师','陈志远','化工类学生附件材料已提醒补齐。','2026-05-08 11:10:00','2026-05-08 11:10:00'),
(1015,1008,1,'laoshi','老师','刘建华','网络工程专业已有多个校企合作项目案例，可按要求推荐。','2026-05-20 14:00:00','2026-05-20 14:00:00'),
(1016,1301,57,'xuesheng','学生','黄一怡','后端开发岗位是否需要线下面试？','2026-03-12 15:25:00','2026-03-12 15:25:00'),
(1017,1302,78,'xuesheng','学生','胡明颖','安全培训通过后是否会发放证明？','2026-03-18 16:10:00','2026-03-18 16:10:00'),
(1018,1303,90,'xuesheng','学生','高泽涵','设备调试岗位实习地点是在洛阳总部吗？','2026-04-06 13:35:00','2026-04-06 13:35:00');

DROP TEMPORARY TABLE IF EXISTS `seed_numbers`;

COMMIT;
