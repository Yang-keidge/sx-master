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
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 COMMENT='字典';

/*Data for the table `dictionary` */

insert  into `dictionary`(`id`,`dic_code`,`dic_name`,`code_index`,`index_name`,`super_id`,`beizhu`,`create_time`) values (1,'sex_types','性别类型',1,'男',NULL,NULL,'2022-03-28 21:46:16'),(2,'sex_types','性别类型',2,'女',NULL,NULL,'2022-03-28 21:46:16'),(3,'yuanxi_types','院系',1,'数学与计算机应用学院',NULL,NULL,'2022-03-28 21:46:16'),(4,'yuanxi_types','院系',2,'化学化工学院',NULL,NULL,'2022-03-28 21:46:16'),(5,'yuanxi_types','院系',3,'经济管理学院',NULL,NULL,'2022-03-28 21:46:16'),(6,'yuanxi_types','院系',4,'机械与电气工程学院',NULL,NULL,'2022-03-28 21:46:16'),(7,'zhuanye_types','专业',1,'网络工程',1,NULL,'2022-03-28 21:46:16'),(8,'zhuanye_types','专业',2,'软件工程',1,NULL,'2022-03-28 21:46:16'),(9,'zhuanye_types','专业',3,'应用化学',2,NULL,'2022-03-28 21:46:16'),(10,'zhuanye_types','专业',4,'财务管理',3,NULL,'2022-03-28 21:46:16'),(11,'zhuanye_types','专业',5,'机械设计制造及其自动化',4,NULL,'2022-03-28 21:46:16'),(12,'zhuanye_types','专业',6,'化学工程与工艺',2,NULL,'2022-03-28 21:46:16'),(13,'zhuanye_types','专业',7,'机械电子工程',4,NULL,'2022-03-28 21:46:16'),(14,'zhuanye_types','专业',8,'会计学',3,NULL,'2022-03-28 21:46:16'),(15,'banji_types','班级',1,'网络工程2101',1,NULL,'2022-03-28 21:46:16'),(16,'banji_types','班级',2,'软件工程2101',2,NULL,'2022-03-28 21:46:16'),(17,'banji_types','班级',3,'应用化学2101',3,NULL,'2022-03-28 21:46:16'),(18,'banji_types','班级',4,'财务管理2101',4,NULL,'2022-03-28 21:46:16'),(19,'banji_types','班级',5,'机械设计制造及其自动化2101',5,NULL,'2022-03-28 21:46:16'),(20,'banji_types','班级',6,'化学工程与工艺2201',6,NULL,'2022-03-28 21:46:16'),(21,'banji_types','班级',7,'网络工程2201',1,NULL,'2022-03-28 21:46:16'),(22,'banji_types','班级',8,'应用化学2201',3,NULL,'2022-03-28 21:46:16'),(23,'banji_types','班级',9,'机械电子工程2201',7,NULL,'2022-03-28 21:46:16'),(24,'banji_types','班级',10,'会计学2301',8,NULL,'2022-03-28 21:46:16'),(25,'banji_types','班级',11,'软件工程2301',2,NULL,'2022-03-28 21:46:16'),(26,'gonggao_types','公告类型',1,'教学通知',NULL,NULL,'2022-03-28 21:46:16'),(27,'gonggao_types','公告类型',2,'就业提醒',NULL,NULL,'2022-03-28 21:46:16'),(28,'gonggao_types','公告类型',3,'招聘信息',NULL,NULL,'2022-03-28 21:46:16'),(29,'gonggao_types','公告类型',4,'实习推荐',NULL,NULL,'2022-03-28 21:46:16'),(30,'gonggao_types','公告类型',5,'系统公告',NULL,NULL,'2022-03-28 21:46:16'),(31,'qiye_types','行业',1,'信息技术',NULL,NULL,'2022-03-28 21:46:16'),(32,'qiye_types','行业',2,'化工医药',NULL,NULL,'2022-03-28 21:46:16'),(33,'qiye_types','行业',3,'智能制造',NULL,NULL,'2022-03-28 21:46:16'),(34,'qiye_types','行业',4,'金融服务',NULL,NULL,'2022-03-28 21:46:16'),(35,'shixi_types','实习信息类型',1,'学校统一安排实习',NULL,NULL,'2022-03-28 21:46:16'),(36,'shixi_types','实习信息类型',2,'自主联系实习',NULL,NULL,'2022-03-28 21:46:16'),(37,'shixi_types','实习信息类型',3,'校企合作实习',NULL,NULL,'2022-03-28 21:46:16'),(38,'shixi_types','实习信息类型',4,'顶岗实习',NULL,NULL,'2022-03-28 21:46:16'),(39,'shixi_jieguo_types','实习结果',1,'优秀',NULL,NULL,'2022-03-28 21:46:16'),(40,'shixi_jieguo_types','实习结果',2,'良好',NULL,NULL,'2022-03-28 21:46:16'),(41,'shixi_jieguo_types','实习结果',3,'合格',NULL,NULL,'2022-03-28 21:46:16'),(42,'shixi_jieguo_types','实习结果',4,'待评定',NULL,NULL,'2022-03-28 21:46:16');

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


/*Table structure for table `gonggao_comment` */

CREATE TABLE IF NOT EXISTS `gonggao_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `gonggao_id` int(11) NOT NULL COMMENT '公告',
  `pinglunren_id` int(11) NOT NULL COMMENT '评论人',
  `pinglunren_table` varchar(50) NOT NULL COMMENT '评论人表名',
  `pinglunren_role` varchar(50) NOT NULL COMMENT '评论人身份 Search111 ',
  `pinglunren_name` varchar(200) DEFAULT NULL COMMENT '评论人名称 Search111 ',
  `gonggao_comment_content` text NOT NULL COMMENT '评论内容',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_gonggao_comment_gonggao` (`gonggao_id`),
  KEY `idx_gonggao_comment_pinglunren` (`pinglunren_table`,`pinglunren_id`),
  KEY `idx_gonggao_comment_role` (`pinglunren_role`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='公告评论';


/*Table structure for table `taolun` */
CREATE TABLE IF NOT EXISTS `taolun` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `fabuzhe_id` int(11) NOT NULL COMMENT '发布者',
  `fabuzhe_table` varchar(50) NOT NULL COMMENT '发布者表名',
  `fabuzhe_role` varchar(50) NOT NULL COMMENT '发布者身份 Search111',
  `fabuzhe_name` varchar(200) DEFAULT NULL COMMENT '发布者名称 Search111',
  `taolun_title` varchar(200) NOT NULL COMMENT '帖子标题 Search111',
  `taolun_content` text NOT NULL COMMENT '帖子内容',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_taolun_fabuzhe` (`fabuzhe_table`,`fabuzhe_id`),
  KEY `idx_taolun_role` (`fabuzhe_role`),
  KEY `idx_taolun_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='讨论区帖子';

CREATE TABLE IF NOT EXISTS `taolun_huifu` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `taolun_id` int(11) NOT NULL COMMENT '讨论区帖子',
  `huifuren_id` int(11) NOT NULL COMMENT '回复人',
  `huifuren_table` varchar(50) NOT NULL COMMENT '回复人表名',
  `huifuren_role` varchar(50) NOT NULL COMMENT '回复人身份 Search111',
  `huifuren_name` varchar(200) DEFAULT NULL COMMENT '回复人名称 Search111',
  `huifu_content` text NOT NULL COMMENT '回复内容',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_taolun_huifu_taolun` (`taolun_id`),
  KEY `idx_taolun_huifu_user` (`huifuren_table`,`huifuren_id`),
  KEY `idx_taolun_huifu_role` (`huifuren_role`),
  KEY `idx_taolun_huifu_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='讨论区回复';

CREATE TABLE IF NOT EXISTS `wenti_jieda` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `xuesheng_id` int(11) NOT NULL COMMENT '提问学生',
  `laoshi_id` int(11) NOT NULL COMMENT '答疑老师',
  `wenti_title` varchar(200) NOT NULL COMMENT '问题标题 Search111',
  `wenti_content` text NOT NULL COMMENT '问题内容',
  `wenti_status` varchar(20) NOT NULL DEFAULT '未回复' COMMENT '回复状态 Search111',
  `huifu_content` text COMMENT '回复内容',
  `huifu_laoshi_id` int(11) DEFAULT NULL COMMENT '回复老师',
  `huifu_time` timestamp NULL DEFAULT NULL COMMENT '回复时间',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_wenti_xuesheng` (`xuesheng_id`),
  KEY `idx_wenti_laoshi` (`laoshi_id`),
  KEY `idx_wenti_status` (`wenti_status`),
  KEY `idx_wenti_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='问题解答';

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
  `yuanxi_types` int(11) DEFAULT NULL COMMENT '院系',
  `zhuanye_types` int(11) DEFAULT NULL COMMENT '专业',
  `laoshi_email` varchar(200) DEFAULT NULL COMMENT '电子邮箱',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_laoshi_username` (`username`),
  UNIQUE KEY `uk_laoshi_gonghao` (`laoshi_gonghao`),
  UNIQUE KEY `uk_laoshi_phone` (`laoshi_phone`),
  UNIQUE KEY `uk_laoshi_id_number` (`laoshi_id_number`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='老师';


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


/*Table structure for table `zhaopin_gangwei` */

DROP TABLE IF EXISTS `zhaopin_gangwei`;

CREATE TABLE `zhaopin_gangwei` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `qiye_id` int(11) NOT NULL COMMENT '企业',
  `zhaopin_gangwei_name` varchar(200) NOT NULL COMMENT '职位名称 Search111',
  `zhaopin_leixing` varchar(200) NOT NULL COMMENT '职位类型 Search111',
  `xinzi_fanwei` varchar(200) NOT NULL COMMENT '薪资范围',
  `gongzuo_dizhi` varchar(200) NOT NULL COMMENT '工作地址 Search111',
  `gongzuo_yaoqiu` text NOT NULL COMMENT '工作要求',
  `yizhao_renshu` int(11) NOT NULL DEFAULT '0' COMMENT '已招人数',
  `zhaopin_renshu` int(11) NOT NULL COMMENT '招聘人数',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_zhaopin_qiye_id` (`qiye_id`),
  KEY `idx_zhaopin_status` (`yizhao_renshu`,`zhaopin_renshu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='招聘岗位';


/*Table structure for table `yingpin` */

DROP TABLE IF EXISTS `yingpin`;

CREATE TABLE `yingpin` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `zhaopin_id` int(11) NOT NULL COMMENT '招聘岗位',
  `xuesheng_id` int(11) NOT NULL COMMENT '学生',
  `qiye_id` int(11) NOT NULL COMMENT '企业',
  `yingpin_status` varchar(50) NOT NULL DEFAULT '待处理' COMMENT '应聘状态',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_yingpin_job_student` (`zhaopin_id`,`xuesheng_id`),
  KEY `idx_yingpin_xuesheng_id` (`xuesheng_id`),
  KEY `idx_yingpin_qiye_id` (`qiye_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='应聘学生';


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
  `xuesheng_jianli_file` varchar(200) DEFAULT NULL COMMENT '学生简历',
  `sex_types` int(11) DEFAULT NULL COMMENT '性别',
  `yuanxi_types` int(11) DEFAULT NULL COMMENT '院系',
  `zhuanye_types` int(11) DEFAULT NULL COMMENT '专业',
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


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
