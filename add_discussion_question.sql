USE `biyeshengshixiyujiuye`;

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
