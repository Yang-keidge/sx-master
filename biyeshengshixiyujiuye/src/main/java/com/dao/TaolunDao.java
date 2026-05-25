package com.dao;

import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.pagination.Pagination;
import com.entity.TaolunEntity;
import com.entity.view.TaolunView;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 讨论区帖子 Dao 接口
 */
public interface TaolunDao extends BaseMapper<TaolunEntity> {

    List<TaolunView> selectListView(Pagination page, @Param("params") Map<String, Object> params);
}
