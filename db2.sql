/*
基础数据脚本
使用方式：先导入 db.sql，再导入本文件。
说明：
1. 本文件包含除 dictionary 字典数据以外的所有基础数据。
2. db.sql 负责库表结构和字典数据，本文件负责账号、企业、学生、实习、招聘、公告评论等基础数据。
3. 补充演示数据保持 INSERT IGNORE，重复导入时会跳过已存在主键或唯一键的数据。
*/

/*!40101 SET NAMES utf8 */;

USE `biyeshengshixiyujiuye`;

START TRANSACTION;

/*Data for the table `gonggao` */

insert  into `gonggao`(`id`,`fabuzhe_id`,`fabuzhe_table`,`fabuzhe_role`,`gonggao_name`,`gonggao_types`,`insert_time`,`gonggao_content`,`create_time`) values (1,6,'users','管理员','2025届毕业生就业数据集中核验通知',5,'2025-06-01','请各学院就业负责老师在6月15日前完成2025届毕业生就业协议、劳动合同和升学录取材料核验，核验结果将纳入就业质量统计。','2025-06-01 09:00:00'),(2,6,'users','管理员','校企合作实习岗位申报说明',5,'2025-06-03','企业账号发布实习推荐前需补全企业编号、行业、联系方式和岗位要求，学校管理员审核后统一向学生开放。','2025-06-03 10:00:00'),(3,1,'laoshi','老师','2021级毕业生就业材料核验通知',2,'2025-06-05','请2021级毕业生在6月12日前上传劳动合同、三方协议或录用证明，辅导员将逐项核验。','2025-06-05 09:00:00'),(4,1,'qiye','企业','Java开发工程师校园招聘',3,'2025-06-10','郑州云启软件有限公司面向2021级软件工程、网络工程毕业生招聘Java开发工程师，要求掌握Spring Boot基础。','2025-06-10 09:30:00'),(5,4,'qiye','企业','后端开发实习生岗位开放',4,'2025-06-18','河南数科信息技术有限公司开放2022级后端开发实习岗位，实习期4个月，提供导师带教。','2025-06-18 10:30:00'),(6,1,'laoshi','老师','2022级专业实习动员会安排',4,'2025-06-20','数学与计算机应用学院2022级专业实习动员会定于6月25日下午在综合楼302举行，请相关学生准时参加。','2025-06-20 10:00:00'),(7,2,'qiye','企业','化工分析员招聘简章',3,'2025-06-22','河南中原化工科技有限公司招聘化工分析员，面向应用化学、化学工程与工艺专业毕业生。','2025-06-22 15:00:00'),(8,2,'laoshi','老师','化工类实习安全与保密要求',1,'2025-06-25','进入化工企业实习前须完成安全教育，不得擅自拍摄生产装置和工艺资料。','2025-06-25 14:30:00'),(9,3,'qiye','企业','智能制造设备工程师招聘',3,'2025-06-28','洛阳智造装备有限公司招聘设备工程师，欢迎机械类毕业生投递简历。','2025-06-28 13:30:00'),(10,3,'laoshi','老师','就业协议签订注意事项',2,'2025-07-01','已确定就业单位的毕业生请核对单位名称、岗位、入职日期后再提交就业协议。','2025-07-01 09:30:00'),(11,5,'qiye','企业','财务助理岗位招聘',3,'2025-07-02','河南华信财务咨询有限公司招聘财务助理，要求熟悉基础会计处理和办公软件。','2025-07-02 10:00:00'),(12,6,'qiye','企业','软件测试实习与就业岗位',4,'2025-07-08','郑州星河网络科技有限公司提供软件测试实习岗位，表现优秀者可转为正式员工。','2025-07-08 09:00:00'),(13,3,'laoshi','老师','毕业去向信息确认提醒',2,'2025-08-25','请2021级毕业生在8月31日前确认毕业去向，信息将用于学院就业质量统计。','2025-08-25 16:00:00'),(14,1,'laoshi','老师','秋季校园招聘宣讲安排',2,'2025-09-10','9月中旬起学校将陆续举办软件开发、智能制造、财务管理方向专场宣讲，请关注系统通知。','2025-09-10 11:00:00');
/*Data for the table `gonggao_comment` */

insert  into `gonggao_comment`(`id`,`gonggao_id`,`pinglunren_id`,`pinglunren_table`,`pinglunren_role`,`pinglunren_name`,`gonggao_comment_content`,`create_time`,`update_time`) values (1,1,1,'xuesheng','学生','张三','老师，材料核验是否需要同时提交纸质版？','2025-06-01 10:20:00','2025-06-01 10:20:00'),(2,1,1,'laoshi','老师','王老师','先在线上传材料，学院复核后会另行通知是否需要纸质版。','2025-06-01 11:00:00','2025-06-01 11:00:00'),(3,4,2,'xuesheng','学生','李四','请问这个岗位是否接受远程面试？','2025-06-10 11:20:00','2025-06-10 11:20:00'),(4,4,1,'qiye','企业','郑州云启软件有限公司','可以远程初面，复试安排会通过系统通知。','2025-06-10 14:00:00','2025-06-10 14:00:00'),(5,6,7,'xuesheng','学生','吴八','实习动员会可以请假吗？','2025-06-20 12:30:00','2025-06-20 12:30:00'),(6,6,1,'laoshi','老师','王老师','特殊情况请提前向辅导员提交请假说明。','2025-06-20 13:10:00','2025-06-20 13:10:00');
/*Data for the table `laoshi` */

insert  into `laoshi`(`id`,`username`,`password`,`laoshi_gonghao`,`laoshi_name`,`laoshi_phone`,`laoshi_id_number`,`laoshi_photo`,`sex_types`,`yuanxi_types`,`zhuanye_types`,`laoshi_email`,`create_time`) values (1,'T2020001','123456','T2020001','刘建华','13937100001','410102198106120011','http://localhost:8080/biyeshengshixiyujiuye/upload/laoshi1.jpg',1,1,1,'liujianhua@hnxy.edu.cn','2022-03-28 21:46:24'),(2,'T2019008','123456','T2019008','张晓梅','13937100002','410103198409180022','http://localhost:8080/biyeshengshixiyujiuye/upload/laoshi2.jpg',2,3,4,'zhangxiaomei@hnxy.edu.cn','2022-03-28 21:46:24'),(3,'T2018012','123456','T2018012','陈志远','13937100003','410104197912050033','http://localhost:8080/biyeshengshixiyujiuye/upload/laoshi3.jpg',1,2,3,'chenzhiyuan@hnxy.edu.cn','2022-03-28 21:46:24');
/*Data for the table `qiye` */

insert  into `qiye`(`id`,`username`,`password`,`qiye_bianhao`,`qiye_name`,`qiye_address`,`qiye_photo`,`qiye_phone`,`qiye_email`,`qiye_types`,`qiye_content`,`create_time`) values (1,'QY001','123456','QY001','郑州云启软件有限公司','河南省郑州市高新区科学大道89号','http://localhost:8080/biyeshengshixiyujiuye/upload/qiye1.jpg','0371-65010001','hr@yunqisoft.com',1,'主要从事政企管理系统、数据中台和移动应用开发，长期接收软件工程与网络工程专业学生实习。','2022-03-28 21:46:24'),(2,'QY002','123456','QY002','河南中原化工科技有限公司','河南省新乡市经开区化工路18号','http://localhost:8080/biyeshengshixiyujiuye/upload/qiye2.jpg','0373-61020002','hr@zychem.com',2,'从事精细化工产品研发、检测与生产管理，适合应用化学、化学工程与工艺专业学生。','2022-03-28 21:46:24'),(3,'QY003','123456','QY003','洛阳智造装备有限公司','河南省洛阳市涧西区建设路66号','http://localhost:8080/biyeshengshixiyujiuye/upload/qiye3.jpg','0379-62030003','campus@lyzzzb.com',3,'聚焦智能装备制造、自动化生产线集成和设备运维，提供机械类实习和就业岗位。','2022-03-28 21:46:24'),(4,'QY004','123456','QY004','河南数科信息技术有限公司','河南省郑州市郑东新区龙子湖智慧岛12号','http://localhost:8080/biyeshengshixiyujiuye/upload/qiye1.jpg','0371-65040004','campus@hndigital.com',1,'面向高校提供数字化项目实训、软件开发和数据分析岗位。','2022-03-28 21:46:24'),(5,'QY005','123456','QY005','河南华信财务咨询有限公司','河南省郑州市金水区经三路58号','http://localhost:8080/biyeshengshixiyujiuye/upload/qiye2.jpg','0371-65050005','hr@huaxincw.com',4,'提供代理记账、审计辅助和企业财税咨询服务，适合财务管理、会计学专业学生。','2022-03-28 21:46:24'),(6,'QY006','123456','QY006','郑州星河网络科技有限公司','河南省郑州市管城区航海东路168号','http://localhost:8080/biyeshengshixiyujiuye/upload/qiye3.jpg','0371-65060006','jobs@xinghenet.com',1,'专注互联网应用测试、运维和质量保障，提供软件测试方向岗位。','2022-03-28 21:46:24');
/*Data for the table `shixi` */

insert  into `shixi`(`id`,`xuesheng_id`,`qiye_id`,`shixi_name`,`shixi_types`,`shixi_kaishi_time`,`shixi_jieshu_time`,`shixi_jieguo_types`,`shixi_gangwei_name`,`shixi_content`,`create_time`) values (1,1,4,'网络工程专业综合实习',3,'2024-07-01','2024-10-31',1,'前端开发实习生','李明轩参与学院推荐的Web项目开发实习，完成页面开发和接口联调任务。','2024-07-01 09:00:00'),(2,2,1,'软件工程企业项目实习',3,'2024-07-01','2024-10-31',1,'Java开发实习生','王雨晴参与企业内部管理系统模块开发，实习表现优秀。','2024-07-01 09:00:00'),(3,4,2,'应用化学生产检测实习',1,'2024-07-08','2024-11-08',2,'化验员实习生','赵子涵在质量检测中心完成原料检测、记录整理等实习任务。','2024-07-08 09:00:00'),(4,5,5,'财务管理岗位认知实习',2,'2024-07-01','2024-10-15',2,'财务助理实习生','刘佳怡参与凭证整理、发票核对和财务档案归档。','2024-07-01 09:00:00'),(5,6,3,'机械设备运维实习',3,'2024-07-15','2024-11-15',1,'设备调试实习生','周浩然参与自动化设备巡检、装配调试和故障记录。','2024-07-15 09:00:00'),(6,7,6,'软件测试实践实习',2,'2024-07-01','2024-10-31',1,'测试工程师实习生','孙若曦完成测试用例编写、缺陷跟踪和回归测试。','2024-07-01 09:00:00'),(7,3,2,'化学工程工艺实习',1,'2025-07-01','2025-10-31',2,'工艺助理实习生','陈思远在生产技术部学习工艺流程、安全规范和数据记录。','2025-07-01 09:00:00'),(8,8,4,'网络工程后端开发实习',3,'2025-07-01','2025-10-31',1,'后端开发实习生','郭宇航参与接口开发、数据库脚本整理和接口文档维护。','2025-07-01 09:00:00'),(9,9,2,'应用化学质量检测实习',1,'2025-07-10','2025-10-31',2,'质检实习生','何欣然参与产品取样、检测记录和实验室安全管理。','2025-07-10 09:00:00'),(10,10,3,'机械电子工程实习',3,'2025-07-15','2025-11-15',1,'机械设计实习生','马俊杰参与零部件建模、图纸整理和设备装配跟进。','2025-07-15 09:00:00');
/*Data for the table `token` */

insert  into `token`(`id`,`userid`,`username`,`tablename`,`role`,`token`,`addtime`,`expiratedtime`) values (1,6,'admin','users','管理员','1h6qij82klsexddjfemplwnmdle0r88r','2022-03-29 09:08:23','2022-03-29 10:18:55'),(2,1,'T2020001','laoshi','老师','8qs6v394h7tgb7ebtvjmoc69ij50fply','2022-03-29 09:12:47','2022-03-29 10:12:48'),(3,1,'QY001','qiye','企业','8xz0lbqznlx7vgcvxiu371c6u0c8elxk','2022-03-29 09:13:26','2022-03-29 10:13:26'),(4,1,'20210001','xuesheng','学生','lkru0n0255sqt9r0gjc9wwxnrwvhsexd','2022-03-29 09:14:57','2022-03-29 10:14:57');
/*Data for the table `users` */

insert  into `users`(`id`,`username`,`password`,`role`,`addtime`) values (6,'admin','admin','管理员','2022-05-02 14:51:13');
/*Data for the table `xuesheng` */

insert  into `xuesheng`(`id`,`username`,`password`,`xuesheng_xuehao`,`xuesheng_name`,`xuesheng_phone`,`xuesheng_id_number`,`xuesheng_photo`,`sex_types`,`yuanxi_types`,`zhuanye_types`,`banji_types`,`ruxue_year`,`xuesheng_email`,`create_time`) values (1,'20210001','123456','20210001','李明轩','13837110001','410102200302010011','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng1.jpg',1,1,1,1,2021,'20210001@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(2,'20210002','123456','20210002','王雨晴','13837110002','410102200303120022','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng2.jpg',2,1,2,2,2021,'20210002@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(3,'20220003','123456','20220003','陈思远','13837110003','410102200404180033','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng3.jpg',1,2,6,6,2022,'20220003@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(4,'20210004','123456','20210004','赵子涵','13837110004','410102200302270044','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng4.jpg',2,2,3,3,2021,'20210004@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(5,'20210005','123456','20210005','刘佳怡','13837110005','410102200301160055','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng5.jpg',2,3,4,4,2021,'20210005@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(6,'20210006','123456','20210006','周浩然','13837110006','410102200302080066','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng6.jpg',1,4,5,5,2021,'20210006@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(7,'20210007','123456','20210007','孙若曦','13837110007','410102200303210077','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng7.jpg',2,1,1,1,2021,'20210007@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(8,'20220008','123456','20220008','郭宇航','13837110008','410102200405060088','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng8.jpg',1,1,1,7,2022,'20220008@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(9,'20220009','123456','20220009','何欣然','13837110009','410102200404300099','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng9.jpg',2,2,3,8,2022,'20220009@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(10,'20220010','123456','20220010','马俊杰','13837110010','410102200405190101','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng10.jpg',1,4,7,9,2022,'20220010@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(11,'20230011','123456','20230011','唐诗涵','13837110011','410102200509070111','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng11.jpg',2,3,8,10,2023,'20230011@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(12,'20230012','123456','20230012','吴嘉豪','13837110012','410102200510230122','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng12.jpg',1,1,2,11,2023,'20230012@stu.hnxy.edu.cn','2022-03-28 21:46:24');

/* Supplementary demo data from original db2.sql */


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

/* QY001 招聘岗位：新增 6 个岗位，便于企业端展示招聘列表和岗位进度。 */
INSERT IGNORE INTO `zhaopin_gangwei`
(`id`,`qiye_id`,`zhaopin_gangwei_name`,`zhaopin_leixing`,`xinzi_fanwei`,`gongzuo_dizhi`,`gongzuo_yaoqiu`,`yizhao_renshu`,`zhaopin_renshu`,`create_time`)
VALUES
(3001,1,'Java开发工程师','校园招聘','10K-15K','河南省郑州市高新区科学大道89号','熟悉 Java 基础、Spring Boot、MySQL，能阅读接口文档并完成业务模块开发。',1,6,'2026-05-20 09:00:00'),
(3002,1,'前端开发工程师','校园招聘','9K-14K','河南省郑州市高新区科学大道89号','熟悉 Vue、JavaScript、Element Plus，了解组件化开发、接口联调和页面性能优化。',0,5,'2026-05-20 09:20:00'),
(3003,1,'软件测试工程师','校园招聘','7K-11K','河南省郑州市高新区科学大道89号','掌握测试用例设计、缺陷跟踪和接口测试基础，有项目测试或课程设计经验优先。',0,4,'2026-05-20 09:40:00'),
(3004,1,'数据分析助理','实习转正','8K-12K','河南省郑州市高新区科学大道89号','了解 SQL、Excel 数据整理和基础可视化，能配合业务部门完成数据报表分析。',1,3,'2026-05-20 10:00:00'),
(3005,1,'实施运维工程师','校园招聘','8K-13K','河南省郑州市高新区科学大道89号','了解 Linux、网络基础和系统部署流程，能适应客户现场沟通和项目交付。',0,4,'2026-05-20 10:20:00'),
(3006,1,'产品经理助理','实习岗位','7K-10K','河南省郑州市高新区科学大道89号','具备需求分析、原型绘制和文档整理能力，能参与政企系统需求调研。',0,3,'2026-05-20 10:40:00');

/* QY001 应聘学生：新增 9 名可用于应聘展示的学生账号。 */
INSERT IGNORE INTO `xuesheng`
(`id`,`username`,`password`,`xuesheng_xuehao`,`xuesheng_name`,`xuesheng_phone`,`xuesheng_id_number`,`xuesheng_photo`,`xuesheng_jianli_file`,`sex_types`,`yuanxi_types`,`zhuanye_types`,`banji_types`,`ruxue_year`,`xuesheng_email`,`create_time`)
VALUES
(1301,'20230131','123456','20230131','张予安','13837301301','410102200503010131','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng1.jpg','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar',1,1,2,11,2023,'20230131@stu.hnxy.edu.cn','2026-05-21 08:30:00'),
(1302,'20230132','123456','20230132','李思源','13837301302','410102200503020132','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng2.jpg','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar',1,1,2,11,2023,'20230132@stu.hnxy.edu.cn','2026-05-21 08:40:00'),
(1303,'20230133','123456','20230133','王若琪','13837301303','410102200503030133','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng3.jpg','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar',2,1,2,11,2023,'20230133@stu.hnxy.edu.cn','2026-05-21 08:50:00'),
(1304,'20230134','123456','20230134','赵嘉宁','13837301304','410102200503040134','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng4.jpg','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar',2,1,2,11,2023,'20230134@stu.hnxy.edu.cn','2026-05-21 09:00:00'),
(1305,'20230135','123456','20230135','陈浩辰','13837301305','410102200503050135','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng5.jpg','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar',1,1,1,7,2023,'20230135@stu.hnxy.edu.cn','2026-05-21 09:10:00'),
(1306,'20230136','123456','20230136','刘雅菲','13837301306','410102200503060136','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng6.jpg','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar',2,1,2,11,2023,'20230136@stu.hnxy.edu.cn','2026-05-21 09:20:00'),
(1307,'20230137','123456','20230137','杨博文','13837301307','410102200503070137','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng7.jpg','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar',1,1,1,7,2023,'20230137@stu.hnxy.edu.cn','2026-05-21 09:30:00'),
(1308,'20230138','123456','20230138','周锦瑜','13837301308','410102200503080138','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng8.jpg','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar',2,1,2,11,2023,'20230138@stu.hnxy.edu.cn','2026-05-21 09:40:00'),
(1309,'20230139','123456','20230139','吴泽洋','13837301309','410102200503090139','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng9.jpg','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar',1,1,1,7,2023,'20230139@stu.hnxy.edu.cn','2026-05-21 09:50:00');

/* QY001 应聘记录：新增 9 条应聘学生数据，分布到不同招聘岗位。 */
INSERT IGNORE INTO `yingpin`
(`id`,`zhaopin_id`,`xuesheng_id`,`qiye_id`,`yingpin_status`,`create_time`)
VALUES
(5001,3001,1301,1,'待处理','2026-05-22 09:10:00'),
(5002,3001,1302,1,'待处理','2026-05-22 09:35:00'),
(5003,3002,1303,1,'待处理','2026-05-22 10:05:00'),
(5004,3002,1304,1,'初筛通过','2026-05-22 10:30:00'),
(5005,3003,1305,1,'待处理','2026-05-22 11:00:00'),
(5006,3004,1306,1,'面试邀约','2026-05-22 14:10:00'),
(5007,3005,1307,1,'待处理','2026-05-22 14:45:00'),
(5008,3006,1308,1,'初筛通过','2026-05-22 15:20:00'),
(5009,3006,1309,1,'待处理','2026-05-22 16:00:00');

/* 讨论区帖子：新增 7 个帖子，覆盖企业、学生、老师和管理员视角。 */
INSERT IGNORE INTO `taolun`
(`id`,`fabuzhe_id`,`fabuzhe_table`,`fabuzhe_role`,`fabuzhe_name`,`taolun_title`,`taolun_content`,`create_time`,`update_time`)
VALUES
(4001,1,'qiye','企业','郑州云启软件有限公司','云启软件暑期项目实习答疑','公司暑期项目实习将围绕政企管理系统、数据看板和移动端接口展开，欢迎同学在本帖集中提问岗位内容、面试安排和实习周期。','2026-05-23 09:00:00','2026-05-23 09:00:00'),
(4002,1301,'xuesheng','学生','张予安','Java岗位笔试准备经验求分享','已投递云启软件 Java 开发岗位，想了解笔试会更偏 Java 基础、数据库还是项目代码阅读，希望有经验的同学分享。','2026-05-23 10:15:00','2026-05-23 10:15:00'),
(4003,1,'laoshi','老师','刘建华','简历项目经历怎么写更清晰','软件开发类岗位简历建议突出项目背景、本人职责、技术栈和可量化结果，欢迎同学把常见问题放在本帖讨论。','2026-05-23 11:00:00','2026-05-23 11:00:00'),
(4004,1,'qiye','企业','郑州云启软件有限公司','实习转正考核关注哪些能力','云启软件实习转正主要关注代码质量、需求理解、沟通协作、问题闭环和出勤表现，大家可以结合岗位方向提前准备。','2026-05-24 09:30:00','2026-05-24 09:30:00'),
(4005,1304,'xuesheng','学生','赵嘉宁','前端组件库项目需要准备哪些截图','准备投递前端岗位，想请教项目作品集中应该展示哪些页面、组件和接口联调截图。','2026-05-24 14:20:00','2026-05-24 14:20:00'),
(4006,6,'users','管理员','admin','春招宣讲后续问题集中收集','春季招聘宣讲结束后，各位同学可以在本帖补充企业岗位、投递流程、面试安排等问题，学校会协调企业集中回复。','2026-05-25 09:10:00','2026-05-25 09:10:00'),
(4007,1308,'xuesheng','学生','周锦瑜','测试岗位面试常见题记录','最近准备测试工程师岗位面试，整理了测试用例设计、缺陷生命周期、接口测试基础等问题，欢迎大家补充。','2026-05-25 15:40:00','2026-05-25 15:40:00');

/* 问题答疑：给 T2020001 刘建华补充 8 条实习中学生问题记录。学生 25-31、52 在 db2.sql 中均为网络工程专业且 2026-05-28 处于实习周期内。 */
INSERT IGNORE INTO `wenti_jieda`
(`id`,`xuesheng_id`,`laoshi_id`,`wenti_title`,`wenti_content`,`wenti_status`,`huifu_content`,`huifu_laoshi_id`,`huifu_time`,`create_time`,`update_time`)
VALUES
(6001,25,1,'实习周报需要附代码截图吗','老师，我在云启软件做接口开发，周报里除了任务说明和问题记录，是否需要附上代码提交或接口联调截图？','已回复','可以附关键截图，但不要上传企业敏感代码。周报重点写清任务目标、完成进度、遇到的问题和下周计划。',1,'2026-05-26 10:20:00','2026-05-26 09:15:00','2026-05-26 10:20:00'),
(6002,26,1,'企业导师评价表什么时候提交','我现在还在项目组实习，企业导师评价表是实习结束后提交，还是阶段检查时也需要先提交一版？','已回复','阶段检查先提交企业导师阶段评价或截图说明，最终评价表在实习结束后一周内上传即可。',1,'2026-05-26 14:10:00','2026-05-26 13:35:00','2026-05-26 14:10:00'),
(6003,27,1,'实习岗位和专业方向不完全一致怎么办','我目前做测试开发，专业是网络工程，实习岗位和开发方向不完全一致，实习总结里应该怎么说明匹配关系？','已回复','可以从接口测试、网络环境、系统部署和质量保障角度说明专业能力应用，重点体现岗位任务与专业课程的关联。',1,'2026-05-27 09:30:00','2026-05-27 08:50:00','2026-05-27 09:30:00'),
(6004,28,1,'请假一天是否影响实习考核','本周需要回校办理材料，预计请假一天，已经和企业导师沟通过，这种情况会影响实习成绩吗？','未回复',NULL,NULL,NULL,'2026-05-27 10:25:00','2026-05-27 10:25:00'),
(6005,29,1,'实习月报和周报内容可以重复吗','月报需要总结本月任务，和每周周报内容会有重复，是否可以整合周报内容后再补充阶段收获？','已回复','可以整合周报内容，但月报需要体现阶段性总结，包括能力提升、问题复盘、企业导师反馈和下月安排。',1,'2026-05-27 15:40:00','2026-05-27 14:20:00','2026-05-27 15:40:00'),
(6006,30,1,'实习系统里的结束时间需要调整吗','企业项目延期两周，系统里的预计结束时间还是原来的日期，是否需要现在申请调整？','未回复',NULL,NULL,NULL,'2026-05-28 09:05:00','2026-05-28 09:05:00'),
(6007,31,1,'项目演示材料可以用测试环境吗','阶段答辩准备项目演示材料时，企业只允许使用测试环境，不能展示真实客户数据，这样可以吗？','已回复','可以使用测试环境，演示时注意脱敏数据和流程说明，答辩材料中不要出现真实客户名称、账号或业务数据。',1,'2026-05-28 10:30:00','2026-05-28 09:55:00','2026-05-28 10:30:00'),
(6008,52,1,'实习成果证明上传哪些附件','我的实施工程师实习主要是部署和运维支持，除了实习鉴定表，还需要上传哪些成果证明？','已回复','可上传部署记录截图、运维日报节选、问题处理清单和企业导师评价。涉及企业内部信息的附件要先做脱敏处理。',1,'2026-05-28 15:00:00','2026-05-28 14:20:00','2026-05-28 15:00:00');


COMMIT;
