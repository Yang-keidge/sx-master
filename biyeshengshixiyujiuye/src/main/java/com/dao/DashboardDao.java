package com.dao;

import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

/**
 * Dashboard 数据统计 Dao 接口
 */
public interface DashboardDao {

    /**
     * 查询基础统计数据
     */
    Map<String, Object> selectBaseData();

    /**
     * 查询实习类型统计
     */
    List<Map<String, Object>> selectShixiTypeStats();

    /**
     * 查询实习结果统计
     */
    List<Map<String, Object>> selectShixiResultStats();

    /**
     * 查询月度趋势
     */
    List<Map<String, Object>> selectMonthTrend(@Param("year") String year);

    /**
     * 查询企业招聘 TOP10
     */
    List<Map<String, Object>> selectCompanyTop();
}
