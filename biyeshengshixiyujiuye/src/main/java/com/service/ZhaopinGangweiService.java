package com.service;

import com.baomidou.mybatisplus.service.IService;
import com.entity.ZhaopinGangweiEntity;
import com.utils.PageUtils;

import java.util.Map;

/**
 * 招聘岗位服务
 */
public interface ZhaopinGangweiService extends IService<ZhaopinGangweiEntity> {

    PageUtils queryPage(Map<String, Object> params);
}
