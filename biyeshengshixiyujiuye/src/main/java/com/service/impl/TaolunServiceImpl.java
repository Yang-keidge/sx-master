package com.service.impl;

import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.dao.TaolunDao;
import com.entity.TaolunEntity;
import com.entity.view.TaolunView;
import com.service.TaolunService;
import com.utils.PageUtils;
import com.utils.Query;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

/**
 * 讨论区帖子 服务实现类
 */
@Service("taolunService")
@Transactional
public class TaolunServiceImpl extends ServiceImpl<TaolunDao, TaolunEntity> implements TaolunService {

    @Override
    public PageUtils queryPage(Map<String, Object> params) {
        if (params != null && (params.get("limit") == null || params.get("page") == null)) {
            params.put("page", "1");
            params.put("limit", "10");
        }
        Page<TaolunView> page = new Query<TaolunView>(params).getPage();
        page.setRecords(baseMapper.selectListView(page, params));
        return new PageUtils(page);
    }
}
