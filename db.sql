/*
SQLyog Ultimate v11.3 (64 bit)
MySQL - 5.7.32-log : Database - biyeshengshixiyujiuye
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`biyeshengshixiyujiuye` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `biyeshengshixiyujiuye`;

/*Table structure for table `config` */

DROP TABLE IF EXISTS `config`;

CREATE TABLE `config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(100) NOT NULL COMMENT '配置参数名称',
  `value` varchar(100) DEFAULT NULL COMMENT '配置参数值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='配置文件';

/*Data for the table `config` */

/*Table structure for table `dictionary` */

DROP TABLE IF EXISTS `dictionary`;

CREATE TABLE `dictionary` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dic_code` varchar(200) DEFAULT NULL COMMENT '字段',
  `dic_name` varchar(200) DEFAULT NULL COMMENT '字段名',
  `code_index` int(11) DEFAULT NULL COMMENT '编码',
  `index_name` varchar(200) DEFAULT NULL COMMENT '编码名字  Search111 ',
  `super_id` int(11) DEFAULT NULL COMMENT '父字段id',
  `beizhu` varchar(200) DEFAULT NULL COMMENT '备注',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COMMENT='字典';

/*Data for the table `dictionary` */

insert  into `dictionary`(`id`,`dic_code`,`dic_name`,`code_index`,`index_name`,`super_id`,`beizhu`,`create_time`) values (1,'sex_types','性别类型',1,'男',NULL,NULL,'2022-03-28 21:46:16'),(2,'sex_types','性别类型',2,'女',NULL,NULL,'2022-03-28 21:46:16'),(3,'yuanxi_types','院系',1,'数学与计算机应用学院',NULL,NULL,'2022-03-28 21:46:16'),(4,'yuanxi_types','院系',2,'化学化工学院',NULL,NULL,'2022-03-28 21:46:16'),(5,'yuanxi_types','院系',3,'经济管理学院',NULL,NULL,'2022-03-28 21:46:16'),(6,'yuanxi_types','院系',4,'机械与电气工程学院',NULL,NULL,'2022-03-28 21:46:16'),(7,'banji_types','班级',1,'网络工程2021',NULL,NULL,'2022-03-28 21:46:16'),(8,'banji_types','班级',2,'软件工程2021',NULL,NULL,'2022-03-28 21:46:16'),(9,'banji_types','班级',3,'应用化学2021',NULL,NULL,'2022-03-28 21:46:16'),(10,'banji_types','班级',4,'财务管理2021',NULL,NULL,'2022-03-28 21:46:16'),(11,'banji_types','班级',5,'机械设计制造及其自动化2021',NULL,NULL,'2022-03-28 21:46:16'),(12,'banji_types','班级',6,'化学工程与工艺2022',NULL,NULL,'2022-03-28 21:46:16'),(13,'banji_types','班级',7,'网络工程2022',NULL,NULL,'2022-03-28 21:46:16'),(14,'banji_types','班级',8,'应用化学2022',NULL,NULL,'2022-03-28 21:46:16'),(15,'banji_types','班级',9,'机械电子工程2022',NULL,NULL,'2022-03-28 21:46:16'),(16,'banji_types','班级',10,'会计学2023',NULL,NULL,'2022-03-28 21:46:16'),(17,'banji_types','班级',11,'软件工程2023',NULL,NULL,'2022-03-28 21:46:16'),(18,'gonggao_types','公告类型',1,'教学通知',NULL,NULL,'2022-03-28 21:46:16'),(19,'gonggao_types','公告类型',2,'就业提醒',NULL,NULL,'2022-03-28 21:46:16'),(20,'gonggao_types','公告类型',3,'招聘信息',NULL,NULL,'2022-03-28 21:46:16'),(21,'gonggao_types','公告类型',4,'实习推荐',NULL,NULL,'2022-03-28 21:46:16'),(22,'gonggao_types','公告类型',5,'系统公告',NULL,NULL,'2022-03-28 21:46:16'),(23,'qiye_types','行业',1,'信息技术',NULL,NULL,'2022-03-28 21:46:16'),(24,'qiye_types','行业',2,'化工医药',NULL,NULL,'2022-03-28 21:46:16'),(25,'qiye_types','行业',3,'智能制造',NULL,NULL,'2022-03-28 21:46:16'),(26,'qiye_types','行业',4,'金融服务',NULL,NULL,'2022-03-28 21:46:16'),(27,'shixi_types','实习信息类型',1,'学校统一安排实习',NULL,NULL,'2022-03-28 21:46:16'),(28,'shixi_types','实习信息类型',2,'自主联系实习',NULL,NULL,'2022-03-28 21:46:16'),(29,'shixi_types','实习信息类型',3,'校企合作实习',NULL,NULL,'2022-03-28 21:46:16'),(30,'shixi_types','实习信息类型',4,'顶岗实习',NULL,NULL,'2022-03-28 21:46:16'),(31,'shixi_jieguo_types','实习结果',1,'优秀',NULL,NULL,'2022-03-28 21:46:16'),(32,'shixi_jieguo_types','实习结果',2,'良好',NULL,NULL,'2022-03-28 21:46:16'),(33,'shixi_jieguo_types','实习结果',3,'合格',NULL,NULL,'2022-03-28 21:46:16');

/*Table structure for table `gonggao` */

DROP TABLE IF EXISTS `gonggao`;

CREATE TABLE `gonggao` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键 ',
  `fabuzhe_id` int(11) NOT NULL COMMENT '发布者',
  `fabuzhe_table` varchar(50) NOT NULL COMMENT '发布者表名',
  `fabuzhe_role` varchar(50) NOT NULL COMMENT '发布者身份 Search111 ',
  `gonggao_name` varchar(200) NOT NULL COMMENT '公告标题 Search111  ',
  `gonggao_types` int(11) NOT NULL COMMENT '公告类型 Search111 ',
  `insert_time` date DEFAULT NULL COMMENT '公告发布日期 ',
  `gonggao_content` text COMMENT '公告内容 ',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_gonggao_publisher_title` (`fabuzhe_id`,`fabuzhe_role`,`gonggao_name`),
  KEY `idx_gonggao_fabuzhe` (`fabuzhe_table`,`fabuzhe_id`),
  KEY `idx_gonggao_types` (`gonggao_types`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COMMENT='公告';

/*Data for the table `gonggao` */

insert  into `gonggao`(`id`,`fabuzhe_id`,`fabuzhe_table`,`fabuzhe_role`,`gonggao_name`,`gonggao_types`,`insert_time`,`gonggao_content`,`create_time`) values (1,6,'users','管理员','2025届毕业生就业数据集中核验通知',5,'2025-06-01','请各学院就业负责老师在6月15日前完成2025届毕业生就业协议、劳动合同和升学录取材料核验，核验结果将纳入就业质量统计。','2025-06-01 09:00:00'),(2,6,'users','管理员','校企合作实习岗位申报说明',5,'2025-06-03','企业账号发布实习推荐前需补全企业编号、行业、联系方式和岗位要求，学校管理员审核后统一向学生开放。','2025-06-03 10:00:00'),(3,1,'laoshi','老师','2021级毕业生就业材料核验通知',2,'2025-06-05','请2021级毕业生在6月12日前上传劳动合同、三方协议或录用证明，辅导员将逐项核验。','2025-06-05 09:00:00'),(4,1,'qiye','企业','Java开发工程师校园招聘',3,'2025-06-10','郑州云启软件有限公司面向2021级软件工程、网络工程毕业生招聘Java开发工程师，要求掌握Spring Boot基础。','2025-06-10 09:30:00'),(5,4,'qiye','企业','后端开发实习生岗位开放',4,'2025-06-18','河南数科信息技术有限公司开放2022级后端开发实习岗位，实习期4个月，提供导师带教。','2025-06-18 10:30:00'),(6,1,'laoshi','老师','2022级专业实习动员会安排',4,'2025-06-20','数学与计算机应用学院2022级专业实习动员会定于6月25日下午在综合楼302举行，请相关学生准时参加。','2025-06-20 10:00:00'),(7,2,'qiye','企业','化工分析员招聘简章',3,'2025-06-22','河南中原化工科技有限公司招聘化工分析员，面向应用化学、化学工程与工艺专业毕业生。','2025-06-22 15:00:00'),(8,2,'laoshi','老师','化工类实习安全与保密要求',1,'2025-06-25','进入化工企业实习前须完成安全教育，不得擅自拍摄生产装置和工艺资料。','2025-06-25 14:30:00'),(9,3,'qiye','企业','智能制造设备工程师招聘',3,'2025-06-28','洛阳智造装备有限公司招聘设备工程师，欢迎机械类毕业生投递简历。','2025-06-28 13:30:00'),(10,3,'laoshi','老师','就业协议签订注意事项',2,'2025-07-01','已确定就业单位的毕业生请核对单位名称、岗位、入职日期后再提交就业协议。','2025-07-01 09:30:00'),(11,5,'qiye','企业','财务助理岗位招聘',3,'2025-07-02','河南华信财务咨询有限公司招聘财务助理，要求熟悉基础会计处理和办公软件。','2025-07-02 10:00:00'),(12,6,'qiye','企业','软件测试实习与就业岗位',4,'2025-07-08','郑州星河网络科技有限公司提供软件测试实习岗位，表现优秀者可转为正式员工。','2025-07-08 09:00:00'),(13,3,'laoshi','老师','毕业去向信息确认提醒',2,'2025-08-25','请2021级毕业生在8月31日前确认毕业去向，信息将用于学院就业质量统计。','2025-08-25 16:00:00'),(14,1,'laoshi','老师','秋季校园招聘宣讲安排',2,'2025-09-10','9月中旬起学校将陆续举办软件开发、智能制造、财务管理方向专场宣讲，请关注系统通知。','2025-09-10 11:00:00');

/*Table structure for table `jiuye` */

DROP TABLE IF EXISTS `jiuye`;

CREATE TABLE `jiuye` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键 ',
  `xuesheng_id` int(11) DEFAULT NULL COMMENT '学生',
  `qiye_id` int(11) DEFAULT NULL COMMENT '企业',
  `jiuye_kaishi_time` date DEFAULT NULL COMMENT '入职日期',
  `jiuye_gangwei_name` varchar(200) DEFAULT NULL COMMENT '入职岗位',
  `jiuye_file` varchar(200) DEFAULT NULL COMMENT '相关文件',
  `jiuye_content` text COMMENT '就业备注 ',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_jiuye_xuesheng_id` (`xuesheng_id`),
  KEY `idx_jiuye_qiye_id` (`qiye_id`),
  UNIQUE KEY `uk_jiuye_student_company_start` (`xuesheng_id`,`qiye_id`,`jiuye_kaishi_time`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='就业信息';

/*Data for the table `jiuye` */

insert  into `jiuye`(`id`,`xuesheng_id`,`qiye_id`,`jiuye_kaishi_time`,`jiuye_gangwei_name`,`jiuye_file`,`jiuye_content`,`create_time`) values (1,1,4,'2025-07-01','前端开发工程师','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar','李明轩毕业后入职河南数科信息技术有限公司，岗位与网络工程专业方向匹配。','2025-07-01 09:00:00'),(2,2,1,'2025-07-05','Java开发工程师','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar','王雨晴通过校园招聘入职郑州云启软件有限公司，试用期三个月。','2025-07-05 09:00:00'),(3,4,2,'2025-07-10','化工分析员','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar','赵子涵入职河南中原化工科技有限公司质量分析岗位。','2025-07-10 09:00:00'),(4,5,5,'2025-07-15','财务助理','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar','刘佳怡入职河南华信财务咨询有限公司，从事财务资料整理与账务辅助工作。','2025-07-15 09:00:00'),(5,6,3,'2025-07-20','设备工程师','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar','周浩然入职洛阳智造装备有限公司设备工程部。','2025-07-20 09:00:00'),(6,7,6,'2025-07-22','软件测试工程师','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar','孙若曦入职郑州星河网络科技有限公司，负责Web系统测试。','2025-07-22 09:00:00');

/*Table structure for table `laoshi` */

DROP TABLE IF EXISTS `laoshi`;

CREATE TABLE `laoshi` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(200) NOT NULL COMMENT '账户',
  `password` varchar(200) DEFAULT NULL COMMENT '密码',
  `laoshi_gonghao` varchar(50) NOT NULL COMMENT '老师工号 Search111 ',
  `laoshi_name` varchar(200) DEFAULT NULL COMMENT '老师姓名 Search111 ',
  `laoshi_phone` varchar(200) DEFAULT NULL COMMENT '老师手机号',
  `laoshi_id_number` varchar(200) DEFAULT NULL COMMENT '老师身份证号',
  `laoshi_photo` varchar(200) DEFAULT NULL COMMENT '老师头像',
  `sex_types` int(11) DEFAULT NULL COMMENT '性别',
  `laoshi_email` varchar(200) DEFAULT NULL COMMENT '电子邮箱',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_laoshi_username` (`username`),
  UNIQUE KEY `uk_laoshi_gonghao` (`laoshi_gonghao`),
  UNIQUE KEY `uk_laoshi_phone` (`laoshi_phone`),
  UNIQUE KEY `uk_laoshi_id_number` (`laoshi_id_number`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='老师';

/*Data for the table `laoshi` */

insert  into `laoshi`(`id`,`username`,`password`,`laoshi_gonghao`,`laoshi_name`,`laoshi_phone`,`laoshi_id_number`,`laoshi_photo`,`sex_types`,`laoshi_email`,`create_time`) values (1,'T2020001','123456','T2020001','刘建华','13937100001','410102198106120011','http://localhost:8080/biyeshengshixiyujiuye/upload/laoshi1.jpg',1,'liujianhua@hnxy.edu.cn','2022-03-28 21:46:24'),(2,'T2019008','123456','T2019008','张晓梅','13937100002','410103198409180022','http://localhost:8080/biyeshengshixiyujiuye/upload/laoshi2.jpg',2,'zhangxiaomei@hnxy.edu.cn','2022-03-28 21:46:24'),(3,'T2018012','123456','T2018012','陈志远','13937100003','410104197912050033','http://localhost:8080/biyeshengshixiyujiuye/upload/laoshi3.jpg',1,'chenzhiyuan@hnxy.edu.cn','2022-03-28 21:46:24');

/*Table structure for table `qiye` */

DROP TABLE IF EXISTS `qiye`;

CREATE TABLE `qiye` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(200) NOT NULL COMMENT '账户',
  `password` varchar(200) DEFAULT NULL COMMENT '密码',
  `qiye_bianhao` varchar(50) NOT NULL COMMENT '企业编号 Search111 ',
  `qiye_name` varchar(200) DEFAULT NULL COMMENT '企业名称 Search111 ',
  `qiye_address` varchar(200) DEFAULT NULL COMMENT '企业地址',
  `qiye_photo` varchar(200) DEFAULT NULL COMMENT '企业图片',
  `qiye_phone` varchar(200) DEFAULT NULL COMMENT '企业联系方式',
  `qiye_email` varchar(200) DEFAULT NULL COMMENT '企业邮箱',
  `qiye_types` int(11) DEFAULT NULL COMMENT '所在行业 Search111 ',
  `qiye_content` text COMMENT '企业详情',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_qiye_username` (`username`),
  UNIQUE KEY `uk_qiye_bianhao` (`qiye_bianhao`),
  UNIQUE KEY `uk_qiye_phone` (`qiye_phone`),
  UNIQUE KEY `uk_qiye_email` (`qiye_email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='企业';

/*Data for the table `qiye` */

insert  into `qiye`(`id`,`username`,`password`,`qiye_bianhao`,`qiye_name`,`qiye_address`,`qiye_photo`,`qiye_phone`,`qiye_email`,`qiye_types`,`qiye_content`,`create_time`) values (1,'QY001','123456','QY001','郑州云启软件有限公司','河南省郑州市高新区科学大道89号','http://localhost:8080/biyeshengshixiyujiuye/upload/qiye1.jpg','0371-65010001','hr@yunqisoft.com',1,'主要从事政企管理系统、数据中台和移动应用开发，长期接收软件工程与网络工程专业学生实习。','2022-03-28 21:46:24'),(2,'QY002','123456','QY002','河南中原化工科技有限公司','河南省新乡市经开区化工路18号','http://localhost:8080/biyeshengshixiyujiuye/upload/qiye2.jpg','0373-61020002','hr@zychem.com',2,'从事精细化工产品研发、检测与生产管理，适合应用化学、化学工程与工艺专业学生。','2022-03-28 21:46:24'),(3,'QY003','123456','QY003','洛阳智造装备有限公司','河南省洛阳市涧西区建设路66号','http://localhost:8080/biyeshengshixiyujiuye/upload/qiye3.jpg','0379-62030003','campus@lyzzzb.com',3,'聚焦智能装备制造、自动化生产线集成和设备运维，提供机械类实习和就业岗位。','2022-03-28 21:46:24'),(4,'QY004','123456','QY004','河南数科信息技术有限公司','河南省郑州市郑东新区龙子湖智慧岛12号','http://localhost:8080/biyeshengshixiyujiuye/upload/qiye1.jpg','0371-65040004','campus@hndigital.com',1,'面向高校提供数字化项目实训、软件开发和数据分析岗位。','2022-03-28 21:46:24'),(5,'QY005','123456','QY005','河南华信财务咨询有限公司','河南省郑州市金水区经三路58号','http://localhost:8080/biyeshengshixiyujiuye/upload/qiye2.jpg','0371-65050005','hr@huaxincw.com',4,'提供代理记账、审计辅助和企业财税咨询服务，适合财务管理、会计学专业学生。','2022-03-28 21:46:24'),(6,'QY006','123456','QY006','郑州星河网络科技有限公司','河南省郑州市管城区航海东路168号','http://localhost:8080/biyeshengshixiyujiuye/upload/qiye3.jpg','0371-65060006','jobs@xinghenet.com',1,'专注互联网应用测试、运维和质量保障，提供软件测试方向岗位。','2022-03-28 21:46:24');

/*Table structure for table `shixi` */

DROP TABLE IF EXISTS `shixi`;

CREATE TABLE `shixi` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键 ',
  `xuesheng_id` int(11) DEFAULT NULL COMMENT '学生',
  `qiye_id` int(11) DEFAULT NULL COMMENT '企业',
  `shixi_name` varchar(200) DEFAULT NULL COMMENT '实习名称 Search111  ',
  `shixi_types` int(11) NOT NULL COMMENT '实习类型 ',
  `shixi_kaishi_time` date DEFAULT NULL COMMENT '实习开始日期',
  `shixi_jieshu_time` date DEFAULT NULL COMMENT '实习结束日期',
  `shixi_jieguo_types` int(11) NOT NULL COMMENT '实习结果 Search111 ',
  `shixi_gangwei_name` varchar(200) DEFAULT NULL COMMENT '实习岗位',
  `shixi_content` text COMMENT '实习详情 ',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_shixi_xuesheng_id` (`xuesheng_id`),
  KEY `idx_shixi_qiye_id` (`qiye_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COMMENT='实习信息';

/*Data for the table `shixi` */

insert  into `shixi`(`id`,`xuesheng_id`,`qiye_id`,`shixi_name`,`shixi_types`,`shixi_kaishi_time`,`shixi_jieshu_time`,`shixi_jieguo_types`,`shixi_gangwei_name`,`shixi_content`,`create_time`) values (1,1,4,'网络工程专业综合实习',3,'2024-07-01','2024-10-31',1,'前端开发实习生','李明轩参与学院推荐的Web项目开发实习，完成页面开发和接口联调任务。','2024-07-01 09:00:00'),(2,2,1,'软件工程企业项目实习',3,'2024-07-01','2024-10-31',1,'Java开发实习生','王雨晴参与企业内部管理系统模块开发，实习表现优秀。','2024-07-01 09:00:00'),(3,4,2,'应用化学生产检测实习',1,'2024-07-08','2024-11-08',2,'化验员实习生','赵子涵在质量检测中心完成原料检测、记录整理等实习任务。','2024-07-08 09:00:00'),(4,5,5,'财务管理岗位认知实习',2,'2024-07-01','2024-10-15',2,'财务助理实习生','刘佳怡参与凭证整理、发票核对和财务档案归档。','2024-07-01 09:00:00'),(5,6,3,'机械设备运维实习',3,'2024-07-15','2024-11-15',1,'设备调试实习生','周浩然参与自动化设备巡检、装配调试和故障记录。','2024-07-15 09:00:00'),(6,7,6,'软件测试实践实习',2,'2024-07-01','2024-10-31',1,'测试工程师实习生','孙若曦完成测试用例编写、缺陷跟踪和回归测试。','2024-07-01 09:00:00'),(7,3,2,'化学工程工艺实习',1,'2025-07-01','2025-10-31',2,'工艺助理实习生','陈思远在生产技术部学习工艺流程、安全规范和数据记录。','2025-07-01 09:00:00'),(8,8,4,'网络工程后端开发实习',3,'2025-07-01','2025-10-31',1,'后端开发实习生','郭宇航参与接口开发、数据库脚本整理和接口文档维护。','2025-07-01 09:00:00'),(9,9,2,'应用化学质量检测实习',1,'2025-07-10','2025-10-31',2,'质检实习生','何欣然参与产品取样、检测记录和实验室安全管理。','2025-07-10 09:00:00'),(10,10,3,'机械电子工程实习',3,'2025-07-15','2025-11-15',1,'机械设计实习生','马俊杰参与零部件建模、图纸整理和设备装配跟进。','2025-07-15 09:00:00');

/*Table structure for table `token` */

DROP TABLE IF EXISTS `token`;

CREATE TABLE `token` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `userid` bigint(20) NOT NULL COMMENT '用户id',
  `username` varchar(100) NOT NULL COMMENT '用户名',
  `tablename` varchar(100) DEFAULT NULL COMMENT '表名',
  `role` varchar(100) DEFAULT NULL COMMENT '角色',
  `token` varchar(200) NOT NULL COMMENT '密码',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '新增时间',
  `expiratedtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '过期时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='token表';

/*Data for the table `token` */

insert  into `token`(`id`,`userid`,`username`,`tablename`,`role`,`token`,`addtime`,`expiratedtime`) values (1,6,'admin','users','管理员','1h6qij82klsexddjfemplwnmdle0r88r','2022-03-29 09:08:23','2022-03-29 10:18:55'),(2,1,'T2020001','laoshi','老师','8qs6v394h7tgb7ebtvjmoc69ij50fply','2022-03-29 09:12:47','2022-03-29 10:12:48'),(3,1,'QY001','qiye','企业','8xz0lbqznlx7vgcvxiu371c6u0c8elxk','2022-03-29 09:13:26','2022-03-29 10:13:26'),(4,1,'20210001','xuesheng','学生','lkru0n0255sqt9r0gjc9wwxnrwvhsexd','2022-03-29 09:14:57','2022-03-29 10:14:57');

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(100) NOT NULL COMMENT '用户名',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `role` varchar(100) DEFAULT '管理员' COMMENT '角色',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '新增时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='管理员';

/*Data for the table `users` */

insert  into `users`(`id`,`username`,`password`,`role`,`addtime`) values (6,'admin','admin','管理员','2022-05-02 14:51:13');

/*Table structure for table `xuesheng` */

DROP TABLE IF EXISTS `xuesheng`;

CREATE TABLE `xuesheng` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(200) NOT NULL COMMENT '账户',
  `password` varchar(200) DEFAULT NULL COMMENT '密码',
  `xuesheng_xuehao` varchar(50) NOT NULL COMMENT '学生学号 Search111 ',
  `xuesheng_name` varchar(200) DEFAULT NULL COMMENT '学生姓名 Search111 ',
  `xuesheng_phone` varchar(200) DEFAULT NULL COMMENT '学生手机号',
  `xuesheng_id_number` varchar(200) DEFAULT NULL COMMENT '学生身份证号',
  `xuesheng_photo` varchar(200) DEFAULT NULL COMMENT '学生头像',
  `sex_types` int(11) DEFAULT NULL COMMENT '性别',
  `yuanxi_types` int(11) DEFAULT NULL COMMENT '院系',
  `banji_types` int(11) DEFAULT NULL COMMENT '班级',
  `ruxue_year` int(11) DEFAULT NULL COMMENT '入学年份 Search111 ',
  `xuesheng_email` varchar(200) DEFAULT NULL COMMENT '电子邮箱',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_xuesheng_username` (`username`),
  UNIQUE KEY `uk_xuesheng_xuehao` (`xuesheng_xuehao`),
  UNIQUE KEY `uk_xuesheng_phone` (`xuesheng_phone`),
  UNIQUE KEY `uk_xuesheng_id_number` (`xuesheng_id_number`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='学生';

/*Data for the table `xuesheng` */

insert  into `xuesheng`(`id`,`username`,`password`,`xuesheng_xuehao`,`xuesheng_name`,`xuesheng_phone`,`xuesheng_id_number`,`xuesheng_photo`,`sex_types`,`yuanxi_types`,`banji_types`,`ruxue_year`,`xuesheng_email`,`create_time`) values (1,'20210001','123456','20210001','李明轩','13837110001','410102200302010011','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng1.jpg',1,1,1,2021,'20210001@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(2,'20210002','123456','20210002','王雨晴','13837110002','410102200303120022','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng2.jpg',2,1,2,2021,'20210002@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(3,'20220003','123456','20220003','陈思远','13837110003','410102200404180033','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng3.jpg',1,2,6,2022,'20220003@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(4,'20210004','123456','20210004','赵子涵','13837110004','410102200302270044','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng4.jpg',2,2,3,2021,'20210004@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(5,'20210005','123456','20210005','刘佳怡','13837110005','410102200301160055','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng5.jpg',2,3,4,2021,'20210005@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(6,'20210006','123456','20210006','周浩然','13837110006','410102200302080066','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng6.jpg',1,4,5,2021,'20210006@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(7,'20210007','123456','20210007','孙若曦','13837110007','410102200303210077','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng7.jpg',2,1,1,2021,'20210007@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(8,'20220008','123456','20220008','郭宇航','13837110008','410102200405060088','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng8.jpg',1,1,7,2022,'20220008@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(9,'20220009','123456','20220009','何欣然','13837110009','410102200404300099','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng9.jpg',2,2,8,2022,'20220009@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(10,'20220010','123456','20220010','马俊杰','13837110010','410102200405190101','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng10.jpg',1,4,9,2022,'20220010@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(11,'20230011','123456','20230011','唐诗涵','13837110011','410102200509070111','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng11.jpg',2,3,10,2023,'20230011@stu.hnxy.edu.cn','2022-03-28 21:46:24'),(12,'20230012','123456','20230012','吴嘉豪','13837110012','410102200510230122','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng12.jpg',1,1,11,2023,'20230012@stu.hnxy.edu.cn','2022-03-28 21:46:24');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
