package com.service;

import com.baomidou.mybatisplus.service.IService;
import com.entity.GonggaoCommentEntity;
import com.utils.PageUtils;

import java.util.Map;

/**
 * 公告评论 服务类
 */
public interface GonggaoCommentService extends IService<GonggaoCommentEntity> {

    PageUtils queryPage(Map<String, Object> params);
}
