package com.service;

import java.util.List;
import java.util.Map;

/**
 * Dashboard 数据统计 Service 接口
 */
public interface DashboardService {

    /**
     * 获取基础统计数据
     */
    Map<String, Object> getBaseData();

    /**
     * 获取实习类型统计
     */
    List<Map<String, Object>> getShixiTypeStats();

    /**
     * 获取实习结果统计
     */
    List<Map<String, Object>> getShixiResultStats();

    /**
     * 获取月度趋势
     */
    Map<String, Object> getMonthTrend();

    /**
     * 获取企业招聘 TOP10
     */
    List<Map<String, Object>> getCompanyTop();
}
