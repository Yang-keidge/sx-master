package com.service;

import com.baomidou.mybatisplus.service.IService;
import com.entity.GonggaoEntity;
import com.utils.PageUtils;

import java.util.Map;

/**
 * 公告 服务类
 */
public interface GonggaoService extends IService<GonggaoEntity> {

    PageUtils queryPage(Map<String, Object> params);
}
