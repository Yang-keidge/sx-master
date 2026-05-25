package com.service;

import com.baomidou.mybatisplus.service.IService;
import com.entity.TaolunEntity;
import com.utils.PageUtils;

import java.util.Map;

/**
 * 讨论区帖子 服务类
 */
public interface TaolunService extends IService<TaolunEntity> {

    PageUtils queryPage(Map<String, Object> params);
}
