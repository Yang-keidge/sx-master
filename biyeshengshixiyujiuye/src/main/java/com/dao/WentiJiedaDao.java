package com.dao;

import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.pagination.Pagination;
import com.entity.WentiJiedaEntity;
import com.entity.view.WentiJiedaView;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 问题解答 Dao 接口
 */
public interface WentiJiedaDao extends BaseMapper<WentiJiedaEntity> {

    List<WentiJiedaView> selectListView(Pagination page, @Param("params") Map<String, Object> params);
}
