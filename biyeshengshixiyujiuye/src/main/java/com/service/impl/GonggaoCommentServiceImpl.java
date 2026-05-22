package com.service.impl;

import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.dao.GonggaoCommentDao;
import com.entity.GonggaoCommentEntity;
import com.entity.view.GonggaoCommentView;
import com.service.GonggaoCommentService;
import com.utils.PageUtils;
import com.utils.Query;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

/**
 * 公告评论 服务实现类
 */
@Service("gonggaoCommentService")
@Transactional
public class GonggaoCommentServiceImpl extends ServiceImpl<GonggaoCommentDao, GonggaoCommentEntity> implements GonggaoCommentService {

    @Override
    public PageUtils queryPage(Map<String, Object> params) {
        if (params != null && (params.get("limit") == null || params.get("page") == null)) {
            params.put("page", "1");
            params.put("limit", "10");
        }
        Page<GonggaoCommentView> page = new Query<GonggaoCommentView>(params).getPage();
        page.setRecords(baseMapper.selectListView(page, params));
        return new PageUtils(page);
    }
}
