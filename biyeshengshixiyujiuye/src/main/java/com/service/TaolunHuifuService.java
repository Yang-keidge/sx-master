package com.service;

import com.baomidou.mybatisplus.service.IService;
import com.entity.TaolunHuifuEntity;
import com.utils.PageUtils;

import java.util.Map;

/**
 * 讨论区回复 服务类
 */
public interface TaolunHuifuService extends IService<TaolunHuifuEntity> {

    PageUtils queryPage(Map<String, Object> params);
}
