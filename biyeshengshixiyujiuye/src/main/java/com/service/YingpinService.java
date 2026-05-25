package com.service;

import com.baomidou.mybatisplus.service.IService;
import com.entity.YingpinEntity;
import com.utils.PageUtils;

import java.util.Map;

/**
 * 应聘学生服务
 */
public interface YingpinService extends IService<YingpinEntity> {

    PageUtils queryPage(Map<String, Object> params);
}
