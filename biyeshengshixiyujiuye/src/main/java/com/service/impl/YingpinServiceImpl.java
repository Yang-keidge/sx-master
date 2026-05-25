package com.service.impl;

import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.dao.YingpinDao;
import com.entity.YingpinEntity;
import com.entity.view.YingpinView;
import com.service.YingpinService;
import com.utils.PageUtils;
import com.utils.Query;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

/**
 * 应聘学生服务实现
 */
@Service("yingpinService")
@Transactional
public class YingpinServiceImpl extends ServiceImpl<YingpinDao, YingpinEntity> implements YingpinService {

    @Override
    public PageUtils queryPage(Map<String, Object> params) {
        if (params != null && (params.get("limit") == null || params.get("page") == null)) {
            params.put("page", "1");
            params.put("limit", "10");
        }
        Page<YingpinView> page = new Query<YingpinView>(params).getPage();
        page.setRecords(baseMapper.selectListView(page, params));
        return new PageUtils(page);
    }
}
