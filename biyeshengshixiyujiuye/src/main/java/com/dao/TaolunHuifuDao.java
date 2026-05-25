package com.dao;

import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.pagination.Pagination;
import com.entity.TaolunHuifuEntity;
import com.entity.view.TaolunHuifuView;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 讨论区回复 Dao 接口
 */
public interface TaolunHuifuDao extends BaseMapper<TaolunHuifuEntity> {

    List<TaolunHuifuView> selectListView(Pagination page, @Param("params") Map<String, Object> params);
}
