/*
简历管理、招聘应聘模块增量 SQL
使用方式：在已有 biyeshengshixiyujiuye 数据库上导入本文件。
说明：本脚本不删除已有数据；xuesheng 简历字段采用存在性判断后再添加。
*/

USE `biyeshengshixiyujiuye`;

START TRANSACTION;

SET @column_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'xuesheng'
    AND COLUMN_NAME = 'xuesheng_jianli_file'
);

SET @sql := IF(
  @column_exists = 0,
  'ALTER TABLE `xuesheng` ADD COLUMN `xuesheng_jianli_file` varchar(200) DEFAULT NULL COMMENT ''学生简历'' AFTER `xuesheng_photo`',
  'SELECT ''xuesheng_jianli_file exists'''
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS `zhaopin_gangwei` (
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

CREATE TABLE IF NOT EXISTS `yingpin` (
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

COMMIT;
