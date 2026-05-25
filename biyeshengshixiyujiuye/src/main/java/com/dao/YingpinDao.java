package com.dao;

import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.pagination.Pagination;
import com.entity.YingpinEntity;
import com.entity.view.YingpinView;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 应聘学生 Dao
 */
public interface YingpinDao extends BaseMapper<YingpinEntity> {

    List<YingpinView> selectListView(Pagination page, @Param("params") Map<String, Object> params);
}
