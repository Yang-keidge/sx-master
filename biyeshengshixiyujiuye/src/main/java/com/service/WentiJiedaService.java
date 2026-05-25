package com.service;

import com.baomidou.mybatisplus.service.IService;
import com.entity.WentiJiedaEntity;
import com.utils.PageUtils;

import java.util.Map;

/**
 * 问题解答 服务类
 */
public interface WentiJiedaService extends IService<WentiJiedaEntity> {

    PageUtils queryPage(Map<String, Object> params);
}
