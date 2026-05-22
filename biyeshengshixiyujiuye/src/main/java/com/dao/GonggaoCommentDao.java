package com.dao;

import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.pagination.Pagination;
import com.entity.GonggaoCommentEntity;
import com.entity.view.GonggaoCommentView;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 公告评论 Dao 接口
 */
public interface GonggaoCommentDao extends BaseMapper<GonggaoCommentEntity> {

    List<GonggaoCommentView> selectListView(Pagination page, @Param("params") Map<String, Object> params);
}
