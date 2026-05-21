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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COMMENT='字典';

/*Data for the table `dictionary` */

insert  into `dictionary`(`id`,`dic_code`,`dic_name`,`code_index`,`index_name`,`super_id`,`beizhu`,`create_time`) values (1,'sex_types','性别类型',1,'男',NULL,NULL,'2022-03-28 21:46:16'),(2,'sex_types','性别类型',2,'女',NULL,NULL,'2022-03-28 21:46:16'),(3,'yuanxi_types','院系',1,'院系1',NULL,NULL,'2022-03-28 21:46:16'),(4,'yuanxi_types','院系',2,'院系2',NULL,NULL,'2022-03-28 21:46:16'),(5,'yuanxi_types','院系',3,'院系3',NULL,NULL,'2022-03-28 21:46:16'),(6,'banji_types','班级',1,'班级1',NULL,NULL,'2022-03-28 21:46:16'),(7,'banji_types','班级',2,'班级2',NULL,NULL,'2022-03-28 21:46:16'),(8,'banji_types','班级',3,'班级3',NULL,NULL,'2022-03-28 21:46:16'),(9,'gonggao_laoshi_types','公告类型',1,'公告类型1',NULL,NULL,'2022-03-28 21:46:16'),(10,'gonggao_laoshi_types','公告类型',2,'公告类型2',NULL,NULL,'2022-03-28 21:46:16'),(11,'qiye_types','行业',1,'行业1',NULL,NULL,'2022-03-28 21:46:16'),(12,'qiye_types','行业',2,'行业2',NULL,NULL,'2022-03-28 21:46:16'),(13,'qiye_types','行业',3,'行业3',NULL,NULL,'2022-03-28 21:46:16'),(14,'gonggao_qiye_types','公告类型',1,'公告类型1',NULL,NULL,'2022-03-28 21:46:16'),(15,'gonggao_qiye_types','公告类型',2,'公告类型2',NULL,NULL,'2022-03-28 21:46:16'),(16,'shixi_types','实习信息类型',1,'学校统一安排实习',NULL,NULL,'2022-03-28 21:46:16'),(17,'shixi_types','实习信息类型',2,'自主联系实习',NULL,NULL,'2022-03-28 21:46:16'),(22,'shixi_types','实习信息类型',3,'校企合作实习',NULL,NULL,'2022-03-28 21:46:16'),(23,'shixi_types','实习信息类型',4,'顶岗实习',NULL,NULL,'2022-03-28 21:46:16'),(18,'shixi_jieguo_types','实习结果',1,'优秀',NULL,NULL,'2022-03-28 21:46:16'),(19,'shixi_jieguo_types','实习结果',2,'良好',NULL,NULL,'2022-03-28 21:46:16'),(20,'shixi_jieguo_types','实习结果',3,'较差',NULL,NULL,'2022-03-28 21:46:16'),(21,'yuanxi_types','院系',4,'院系',NULL,'','2022-03-29 09:10:16');

/*Table structure for table `gonggao_laoshi` */

DROP TABLE IF EXISTS `gonggao_laoshi`;

CREATE TABLE `gonggao_laoshi` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键 ',
  `laoshi_id` int(11) DEFAULT NULL COMMENT '老师',
  `gonggao_laoshi_name` varchar(200) DEFAULT NULL COMMENT '公告名称 Search111  ',
  `gonggao_laoshi_types` int(11) NOT NULL COMMENT '公告类型 Search111 ',
  `insert_time` timestamp NULL DEFAULT NULL COMMENT '公告发布时间 ',
  `gonggao_laoshi_content` text COMMENT '公告详情 ',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='老师发布的公告';

/*Data for the table `gonggao_laoshi` */

insert  into `gonggao_laoshi`(`id`,`laoshi_id`,`gonggao_laoshi_name`,`gonggao_laoshi_types`,`insert_time`,`gonggao_laoshi_content`,`create_time`) values (1,2,'公告名称1',1,'2022-03-28 21:46:24','公告详情1','2022-03-28 21:46:24'),(2,3,'公告名称2',1,'2022-03-28 21:46:24','公告详情2','2022-03-28 21:46:24'),(3,1,'公告名称3',2,'2022-03-28 21:46:24','公告详情3','2022-03-28 21:46:24'),(4,3,'公告名称4',1,'2022-03-28 21:46:24','公告详情4','2022-03-28 21:46:24'),(5,3,'公告名称5',2,'2022-03-28 21:46:24','公告详情5','2022-03-28 21:46:24'),(6,1,'公告1211',2,'2022-03-29 09:13:05','<p>公告1111</p>','2022-03-29 09:13:05');

/*Table structure for table `gonggao_qiye` */

DROP TABLE IF EXISTS `gonggao_qiye`;

CREATE TABLE `gonggao_qiye` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键 ',
  `qiye_id` int(11) DEFAULT NULL COMMENT '企业',
  `gonggao_qiye_name` varchar(200) DEFAULT NULL COMMENT '公告名称 Search111  ',
  `gonggao_qiye_types` int(11) NOT NULL COMMENT '公告类型 Search111 ',
  `insert_time` timestamp NULL DEFAULT NULL COMMENT '公告发布时间 ',
  `gonggao_qiye_content` text COMMENT '公告详情 ',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='企业发布的公告';

/*Data for the table `gonggao_qiye` */

insert  into `gonggao_qiye`(`id`,`qiye_id`,`gonggao_qiye_name`,`gonggao_qiye_types`,`insert_time`,`gonggao_qiye_content`,`create_time`) values (1,2,'公告名称1',1,'2022-03-28 21:46:24','公告详情1','2022-03-28 21:46:24'),(2,3,'公告名称2',1,'2022-03-28 21:46:24','公告详情2','2022-03-28 21:46:24'),(3,1,'公告名称3',1,'2022-03-28 21:46:24','公告详情3','2022-03-28 21:46:24'),(4,2,'公告名称4',2,'2022-03-28 21:46:24','公告详情4','2022-03-28 21:46:24'),(5,1,'公告名称5',2,'2022-03-28 21:46:24','公告详情5','2022-03-28 21:46:24'),(6,1,'公告11111',2,'2022-03-29 09:14:48','<p>公告111111</p>','2022-03-29 09:14:48');

/*Table structure for table `jiuye` */

DROP TABLE IF EXISTS `jiuye`;

CREATE TABLE `jiuye` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键 ',
  `xuesheng_id` int(11) DEFAULT NULL COMMENT '学生',
  `qiye_id` int(11) DEFAULT NULL COMMENT '企业',
  `jiuye_kaishi_time` timestamp NULL DEFAULT NULL COMMENT '入职时间',
  `jiuye_gangwei_name` varchar(200) DEFAULT NULL COMMENT '入职岗位',
  `jiuye_file` varchar(200) DEFAULT NULL COMMENT '相关文件',
  `jiuye_content` text COMMENT '就业备注 ',
  `insert_time` timestamp NULL DEFAULT NULL COMMENT '录入时间',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='就业信息';

/*Data for the table `jiuye` */

insert  into `jiuye`(`id`,`xuesheng_id`,`qiye_id`,`jiuye_kaishi_time`,`jiuye_gangwei_name`,`jiuye_file`,`jiuye_content`,`insert_time`,`create_time`) values (1,2,2,'2025-07-01 09:00:00','入职岗位1','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar','就业备注1','2025-07-01 09:00:00','2025-07-01 09:00:00'),(2,1,1,'2025-07-01 09:00:00','入职岗位2','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar','就业备注2','2025-07-01 09:00:00','2025-07-01 09:00:00'),(3,2,3,'2025-07-15 10:00:00','入职岗位3','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar','就业备注3','2025-07-15 10:00:00','2025-07-15 10:00:00'),(4,1,2,'2025-08-01 09:00:00','入职岗位4','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar','就业备注4','2025-08-01 09:00:00','2025-08-01 09:00:00'),(5,2,1,'2025-08-15 10:00:00','入职岗位5','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar','<p>就业备注5111</p>','2025-08-15 10:00:00','2025-08-15 10:00:00'),(6,4,1,'2025-07-20 09:00:00','入职岗位6','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar','就业备注6','2025-07-20 09:00:00','2025-07-20 09:00:00'),(7,5,3,'2025-08-01 10:00:00','入职岗位7','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar','就业备注7','2025-08-01 10:00:00','2025-08-01 10:00:00'),(8,6,2,'2025-09-01 09:00:00','入职岗位8','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar','就业备注8','2025-09-01 09:00:00','2025-09-01 09:00:00'),(9,7,1,'2025-07-10 10:00:00','入职岗位9','http://localhost:8080/biyeshengshixiyujiuye/upload/file.rar','就业备注9','2025-07-10 10:00:00','2025-07-10 10:00:00');

/*Table structure for table `laoshi` */

DROP TABLE IF EXISTS `laoshi`;

CREATE TABLE `laoshi` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(200) DEFAULT NULL COMMENT '账户',
  `password` varchar(200) DEFAULT NULL COMMENT '密码',
  `laoshi_name` varchar(200) DEFAULT NULL COMMENT '老师姓名 Search111 ',
  `laoshi_phone` varchar(200) DEFAULT NULL COMMENT '老师手机号',
  `laoshi_id_number` varchar(200) DEFAULT NULL COMMENT '老师身份证号',
  `laoshi_photo` varchar(200) DEFAULT NULL COMMENT '老师头像',
  `sex_types` int(11) DEFAULT NULL COMMENT '性别',
  `laoshi_email` varchar(200) DEFAULT NULL COMMENT '电子邮箱',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='老师';

/*Data for the table `laoshi` */

insert  into `laoshi`(`id`,`username`,`password`,`laoshi_name`,`laoshi_phone`,`laoshi_id_number`,`laoshi_photo`,`sex_types`,`laoshi_email`,`create_time`) values (1,'a1','123456','老师姓名1','17703786901','410224199610232001','http://localhost:8080/biyeshengshixiyujiuye/upload/laoshi1.jpg',2,'1@qq.com','2022-03-28 21:46:24'),(2,'a2','123456','老师姓名2','17703786902','410224199610232002','http://localhost:8080/biyeshengshixiyujiuye/upload/laoshi2.jpg',1,'2@qq.com','2022-03-28 21:46:24'),(3,'a3','123456','老师姓名3','17703786903','410224199610232003','http://localhost:8080/biyeshengshixiyujiuye/upload/laoshi3.jpg',2,'3@qq.com','2022-03-28 21:46:24');

/*Table structure for table `qiye` */

DROP TABLE IF EXISTS `qiye`;

CREATE TABLE `qiye` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(200) DEFAULT NULL COMMENT '账户',
  `password` varchar(200) DEFAULT NULL COMMENT '密码',
  `qiye_name` varchar(200) DEFAULT NULL COMMENT '企业名称 Search111 ',
  `qiye_address` varchar(200) DEFAULT NULL COMMENT '企业地址',
  `qiye_photo` varchar(200) DEFAULT NULL COMMENT '企业图片',
  `qiye_phone` varchar(200) DEFAULT NULL COMMENT '企业联系方式',
  `qiye_email` varchar(200) DEFAULT NULL COMMENT '企业邮箱',
  `qiye_types` int(11) DEFAULT NULL COMMENT '所在行业 Search111 ',
  `qiye_content` text COMMENT '企业详情',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='企业';

/*Data for the table `qiye` */

insert  into `qiye`(`id`,`username`,`password`,`qiye_name`,`qiye_address`,`qiye_photo`,`qiye_phone`,`qiye_email`,`qiye_types`,`qiye_content`,`create_time`) values (1,'a1','123456','企业名称1','企业地址1','http://localhost:8080/biyeshengshixiyujiuye/upload/qiye1.jpg','17703786901','1@qq.com',1,'企业详情1','2022-03-28 21:46:24'),(2,'a2','123456','企业名称2','企业地址2','http://localhost:8080/biyeshengshixiyujiuye/upload/qiye2.jpg','17703786902','2@qq.com',2,'企业详情2','2022-03-28 21:46:24'),(3,'a3','123456','企业名称3','企业地址3','http://localhost:8080/biyeshengshixiyujiuye/upload/qiye3.jpg','17703786903','3@qq.com',2,'企业详情3','2022-03-28 21:46:24');

/*Table structure for table `shixi` */

DROP TABLE IF EXISTS `shixi`;

CREATE TABLE `shixi` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键 ',
  `xuesheng_id` int(11) DEFAULT NULL COMMENT '学生',
  `qiye_id` int(11) DEFAULT NULL COMMENT '企业',
  `shixi_name` varchar(200) DEFAULT NULL COMMENT '实习名称 Search111  ',
  `shixi_types` int(11) NOT NULL COMMENT '实习类型 ',
  `shixi_kaishi_time` timestamp NULL DEFAULT NULL COMMENT '实习开始时间',
  `shixi_jieshu_time` timestamp NULL DEFAULT NULL COMMENT '实习结束时间',
  `shixi_jieguo_types` int(11) NOT NULL COMMENT '实习结果 Search111 ',
  `shixi_gangwei_name` varchar(200) DEFAULT NULL COMMENT '实习岗位',
  `shixi_content` text COMMENT '实习详情 ',
  `insert_time` timestamp NULL DEFAULT NULL COMMENT '录入时间 ',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COMMENT='实习信息';

/*Data for the table `shixi` */

insert  into `shixi`(`id`,`xuesheng_id`,`qiye_id`,`shixi_name`,`shixi_types`,`shixi_kaishi_time`,`shixi_jieshu_time`,`shixi_jieguo_types`,`shixi_gangwei_name`,`shixi_content`,`insert_time`,`create_time`) values (1,1,3,'实习名称1',1,'2022-03-28 21:46:24','2022-03-28 21:46:24',3,'实习岗位1','实习详情1','2022-03-28 21:46:24','2022-03-28 21:46:24'),(2,1,1,'实习名称2',2,'2022-03-28 21:46:24','2022-03-28 21:46:24',1,'实习岗位2','实习详情2','2022-03-28 21:46:24','2022-03-28 21:46:24'),(3,1,1,'实习名称3',1,'2022-03-28 21:46:24','2022-03-28 21:46:24',1,'实习岗位3','实习详情3','2022-03-28 21:46:24','2022-03-28 21:46:24'),(4,1,2,'实习名称4',1,'2022-03-28 21:46:24','2022-03-28 21:46:24',2,'实习岗位4','实习详情4','2022-03-28 21:46:24','2022-03-28 21:46:24'),(5,1,3,'实习名称5',1,'2022-03-28 21:46:24','2022-03-28 21:46:24',3,'实习岗位5','实习详情5','2022-03-28 21:46:24','2022-03-28 21:46:24'),(6,2,1,'学生2的企业1的实习信息',1,'2022-03-29 09:14:09','2022-03-31 00:00:00',1,'一般职员','<p>萨阿德哥桑撒</p>','2022-03-29 09:14:30','2022-03-29 09:14:30'),(7,4,2,'学生4的实习',2,'2023-05-10 10:00:00','2023-08-10 10:00:00',1,'前端开发','实习详情7','2023-05-10 10:00:00','2023-05-10 10:00:00'),(8,5,1,'学生5的实习',1,'2023-06-15 09:00:00','2023-09-15 09:00:00',2,'后端开发','实习详情8','2023-06-15 09:00:00','2023-06-15 09:00:00'),(9,6,3,'学生6的实习',2,'2023-07-01 08:00:00','2023-10-01 08:00:00',1,'测试工程师','实习详情9','2023-07-01 08:00:00','2023-07-01 08:00:00'),(10,7,2,'学生7的实习',1,'2023-04-20 14:00:00','2023-07-20 14:00:00',3,'产品经理','实习详情10','2023-04-20 14:00:00','2023-04-20 14:00:00'),(11,3,1,'学生3的实习',2,'2025-03-01 09:00:00','2025-06-01 09:00:00',1,'Java开发','实习详情11','2025-03-01 09:00:00','2025-03-01 09:00:00'),(12,8,2,'学生8的实习',1,'2025-04-10 10:00:00','2025-07-10 10:00:00',2,'UI设计','实习详情12','2025-04-10 10:00:00','2025-04-10 10:00:00'),(13,9,3,'学生9的实习',2,'2025-05-15 08:00:00','2025-08-15 08:00:00',1,'数据分析','实习详情13','2025-05-15 08:00:00','2025-05-15 08:00:00'),(14,10,1,'学生10的实习',1,'2025-06-01 09:00:00','2025-09-01 09:00:00',2,'运维工程师','实习详情14','2025-06-01 09:00:00','2025-06-01 09:00:00'),(15,11,2,'学生11的实习',2,'2025-07-01 10:00:00','2025-10-01 10:00:00',1,'算法工程师','实习详情15','2025-07-01 10:00:00','2025-07-01 10:00:00');

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

insert  into `token`(`id`,`userid`,`username`,`tablename`,`role`,`token`,`addtime`,`expiratedtime`) values (1,6,'admin','users','管理员','1h6qij82klsexddjfemplwnmdle0r88r','2022-03-29 09:08:23','2022-03-29 10:18:55'),(2,1,'a1','laoshi','老师','8qs6v394h7tgb7ebtvjmoc69ij50fply','2022-03-29 09:12:47','2022-03-29 10:12:48'),(3,1,'a1','qiye','企业','8xz0lbqznlx7vgcvxiu371c6u0c8elxk','2022-03-29 09:13:26','2022-03-29 10:13:26'),(4,1,'a1','xuesheng','学生','lkru0n0255sqt9r0gjc9wwxnrwvhsexd','2022-03-29 09:14:57','2022-03-29 10:14:57');

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
  `username` varchar(200) DEFAULT NULL COMMENT '账户',
  `password` varchar(200) DEFAULT NULL COMMENT '密码',
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='学生';

/*Data for the table `xuesheng` */

insert  into `xuesheng`(`id`,`username`,`password`,`xuesheng_name`,`xuesheng_phone`,`xuesheng_id_number`,`xuesheng_photo`,`sex_types`,`yuanxi_types`,`banji_types`,`ruxue_year`,`xuesheng_email`,`create_time`) values (1,'a1','123456','学生姓名1','17703786901','410224199610232001','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng1.jpg',2,3,2,2021,'1@qq.com','2022-03-28 21:46:24'),(2,'a2','123456','学生姓名2','17703786902','410224199610232002','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng2.jpg',2,2,3,2021,'2@qq.com','2022-03-28 21:46:24'),(3,'a3','123456','学生姓名3','17703786903','410224199610232003','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng3.jpg',2,3,1,2022,'3@qq.com','2022-03-28 21:46:24'),(4,'a4','123456','学生姓名4','17703786904','410224199610232004','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng4.jpg',1,1,2,2021,'4@qq.com','2022-03-28 21:46:24'),(5,'a5','123456','学生姓名5','17703786905','410224199610232005','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng5.jpg',2,2,1,2021,'5@qq.com','2022-03-28 21:46:24'),(6,'a6','123456','学生姓名6','17703786906','410224199610232006','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng6.jpg',1,3,3,2021,'6@qq.com','2022-03-28 21:46:24'),(7,'a7','123456','学生姓名7','17703786907','410224199610232007','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng7.jpg',2,1,2,2021,'7@qq.com','2022-03-28 21:46:24'),(8,'a8','123456','学生姓名8','17703786908','410224199610232008','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng8.jpg',1,2,3,2022,'8@qq.com','2022-03-28 21:46:24'),(9,'a9','123456','学生姓名9','17703786909','410224199610232009','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng9.jpg',2,3,1,2022,'9@qq.com','2022-03-28 21:46:24'),(10,'a10','123456','学生姓名10','17703786910','410224199610232010','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng10.jpg',1,1,2,2022,'10@qq.com','2022-03-28 21:46:24'),(11,'a11','123456','学生姓名11','17703786911','410224199610232011','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng11.jpg',2,2,3,2023,'11@qq.com','2022-03-28 21:46:24'),(12,'a12','123456','学生姓名12','17703786912','410224199610232012','http://localhost:8080/biyeshengshixiyujiuye/upload/xuesheng12.jpg',1,3,1,2023,'12@qq.com','2022-03-28 21:46:24');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
