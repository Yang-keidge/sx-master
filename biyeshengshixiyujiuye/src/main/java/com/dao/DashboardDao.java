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
     * 查询最近有实习数据的年份
     */
    String selectLatestShixiYear();

    /**
     * 查询企业招聘 TOP10
     */
    List<Map<String, Object>> selectCompanyTop();

    /**
     * 查询最新实习记录
     */
    List<Map<String, Object>> selectLatestShixi();

    /**
     * 查询最新招聘岗位
     */
    List<Map<String, Object>> selectLatestRecruitmentJobs();
}
