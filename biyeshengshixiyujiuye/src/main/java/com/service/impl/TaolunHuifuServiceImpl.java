package com.service.impl;

import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.dao.TaolunHuifuDao;
import com.entity.TaolunHuifuEntity;
import com.entity.view.TaolunHuifuView;
import com.service.TaolunHuifuService;
import com.utils.PageUtils;
import com.utils.Query;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

/**
 * 讨论区回复 服务实现类
 */
@Service("taolunHuifuService")
@Transactional
public class TaolunHuifuServiceImpl extends ServiceImpl<TaolunHuifuDao, TaolunHuifuEntity> implements TaolunHuifuService {

    @Override
    public PageUtils queryPage(Map<String, Object> params) {
        if (params != null && (params.get("limit") == null || params.get("page") == null)) {
            params.put("page", "1");
            params.put("limit", "10");
        }
        Page<TaolunHuifuView> page = new Query<TaolunHuifuView>(params).getPage();
        page.setRecords(baseMapper.selectListView(page, params));
        return new PageUtils(page);
    }
}
