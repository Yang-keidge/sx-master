package com.service.impl;

import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.dao.WentiJiedaDao;
import com.entity.WentiJiedaEntity;
import com.entity.view.WentiJiedaView;
import com.service.WentiJiedaService;
import com.utils.PageUtils;
import com.utils.Query;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

/**
 * 问题解答 服务实现类
 */
@Service("wentiJiedaService")
@Transactional
public class WentiJiedaServiceImpl extends ServiceImpl<WentiJiedaDao, WentiJiedaEntity> implements WentiJiedaService {

    @Override
    public PageUtils queryPage(Map<String, Object> params) {
        if (params != null && (params.get("limit") == null || params.get("page") == null)) {
            params.put("page", "1");
            params.put("limit", "10");
        }
        Page<WentiJiedaView> page = new Query<WentiJiedaView>(params).getPage();
        page.setRecords(baseMapper.selectListView(page, params));
        return new PageUtils(page);
    }
}
