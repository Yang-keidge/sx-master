package com.service.impl;

import com.dao.DashboardDao;
import com.service.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Dashboard 数据统计 Service 实现类
 */
@Service("dashboardService")
public class DashboardServiceImpl implements DashboardService {

    @Autowired
    private DashboardDao dashboardDao;

    @Override
    public Map<String, Object> getBaseData() {
        Map<String, Object> baseData = dashboardDao.selectBaseData();

        baseData.put("studentMonthChange", getLong(baseData, "studentCurrentMonthCount") - getLong(baseData, "studentPreviousMonthCount"));
        baseData.put("qiyeMonthChange", getLong(baseData, "qiyeCurrentMonthCount") - getLong(baseData, "qiyePreviousMonthCount"));
        baseData.put("laoshiMonthChange", getLong(baseData, "laoshiCurrentMonthCount") - getLong(baseData, "laoshiPreviousMonthCount"));
        baseData.put("shixiMonthChange", getLong(baseData, "shixiCurrentMonthCount") - getLong(baseData, "shixiPreviousMonthCount"));
        baseData.put("zhaopinMonthChange", getLong(baseData, "zhaopinCurrentMonthCount") - getLong(baseData, "zhaopinPreviousMonthCount"));
        baseData.put("yingpinMonthChange", getLong(baseData, "yingpinCurrentMonthCount") - getLong(baseData, "yingpinPreviousMonthCount"));

        return baseData;
    }

    @Override
    public List<Map<String, Object>> getShixiTypeStats() {
        return dashboardDao.selectShixiTypeStats();
    }

    @Override
    public List<Map<String, Object>> getShixiResultStats() {
        return dashboardDao.selectShixiResultStats();
    }

    @Override
    public Map<String, Object> getMonthTrend() {
        String year = new SimpleDateFormat("yyyy").format(new Date());
        List<Map<String, Object>> list = dashboardDao.selectMonthTrend(year);

        if (isEmptyTrend(list)) {
            String latestYear = dashboardDao.selectLatestShixiYear();
            if (latestYear != null && latestYear.length() > 0) {
                year = latestYear;
                list = dashboardDao.selectMonthTrend(year);
            }
        }

        String[] xData = new String[12];
        Integer[] yData = new Integer[12];
        for (int i = 0; i < 12; i++) {
            xData[i] = (i + 1) + "月";
            yData[i] = 0;
        }

        for (Map<String, Object> item : list) {
            Object monthObj = item.get("monthNum");
            Object totalObj = item.get("total");
            if (monthObj != null && totalObj != null) {
                int month = Integer.parseInt(monthObj.toString()) - 1;
                if (month >= 0 && month < 12) {
                    yData[month] = ((Number) totalObj).intValue();
                }
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("year", year);
        result.put("xData", Arrays.asList(xData));
        result.put("yData", Arrays.asList(yData));
        return result;
    }

    @Override
    public List<Map<String, Object>> getCompanyTop() {
        return dashboardDao.selectCompanyTop();
    }

    @Override
    public Map<String, Object> getSummary() {
        Map<String, Object> result = new HashMap<>();
        result.put("base", getBaseData());
        result.put("shixiType", getShixiTypeStats());
        result.put("shixiResult", getShixiResultStats());
        result.put("monthTrend", getMonthTrend());
        result.put("companyTop", getCompanyTop());
        result.put("latestShixi", dashboardDao.selectLatestShixi());
        result.put("latestRecruitmentJobs", dashboardDao.selectLatestRecruitmentJobs());
        return result;
    }

    private Long getLong(Map<String, Object> data, String key) {
        Object value = data.get(key);
        if (value == null) {
            return 0L;
        }
        return ((Number) value).longValue();
    }

    private boolean isEmptyTrend(List<Map<String, Object>> list) {
        if (list == null || list.isEmpty()) {
            return true;
        }

        for (Map<String, Object> item : list) {
            Object totalObj = item.get("total");
            if (totalObj != null && ((Number) totalObj).intValue() > 0) {
                return false;
            }
        }
        return true;
    }
}
