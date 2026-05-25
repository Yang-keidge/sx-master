package com.dao;

import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.pagination.Pagination;
import com.entity.ZhaopinGangweiEntity;
import com.entity.view.ZhaopinGangweiView;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 招聘岗位 Dao
 */
public interface ZhaopinGangweiDao extends BaseMapper<ZhaopinGangweiEntity> {

    List<ZhaopinGangweiView> selectListView(Pagination page, @Param("params") Map<String, Object> params);
}
