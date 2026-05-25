package com.service.impl;

import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.dao.ZhaopinGangweiDao;
import com.entity.ZhaopinGangweiEntity;
import com.entity.view.ZhaopinGangweiView;
import com.service.ZhaopinGangweiService;
import com.utils.PageUtils;
import com.utils.Query;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

/**
 * 招聘岗位服务实现
 */
@Service("zhaopinGangweiService")
@Transactional
public class ZhaopinGangweiServiceImpl extends ServiceImpl<ZhaopinGangweiDao, ZhaopinGangweiEntity> implements ZhaopinGangweiService {

    @Override
    public PageUtils queryPage(Map<String, Object> params) {
        if (params != null && (params.get("limit") == null || params.get("page") == null)) {
            params.put("page", "1");
            params.put("limit", "10");
        }
        Page<ZhaopinGangweiView> page = new Query<ZhaopinGangweiView>(params).getPage();
        page.setRecords(baseMapper.selectListView(page, params));
        return new PageUtils(page);
    }
}
