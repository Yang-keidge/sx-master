package com.service.impl;

import com.dao.DashboardDao;
import com.service.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
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

        Long studentCount = ((Number) baseData.get("studentCount")).longValue();
        Long jiuyeCount = ((Number) baseData.get("jiuyeCount")).longValue();
        Long shixiCount = ((Number) baseData.get("shixiCount")).longValue();

        // 计算就业率
        BigDecimal employmentRate = BigDecimal.ZERO;
        if (studentCount != null && studentCount > 0 && jiuyeCount != null) {
            employmentRate = new BigDecimal(jiuyeCount)
                    .multiply(new BigDecimal(100))
                    .divide(new BigDecimal(studentCount), 1, RoundingMode.HALF_UP);
        }
        baseData.put("employmentRate", employmentRate);

        // 计算实习完成率（优秀 + 良好）/ 总实习数
        List<Map<String, Object>> resultStats = dashboardDao.selectShixiResultStats();
        long goodCount = 0;
        for (Map<String, Object> stat : resultStats) {
            String name = (String) stat.get("name");
            Number value = (Number) stat.get("value");
            if (value == null) value = 0;
            if ("优秀".equals(name) || "良好".equals(name)) {
                goodCount += value.longValue();
            }
        }
        BigDecimal shixiRate = BigDecimal.ZERO;
        if (shixiCount != null && shixiCount > 0) {
            shixiRate = new BigDecimal(goodCount)
                    .multiply(new BigDecimal(100))
                    .divide(new BigDecimal(shixiCount), 1, RoundingMode.HALF_UP);
        }
        baseData.put("shixiRate", shixiRate);

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
        result.put("xData", Arrays.asList(xData));
        result.put("yData", Arrays.asList(yData));
        return result;
    }

    @Override
    public List<Map<String, Object>> getCompanyTop() {
        return dashboardDao.selectCompanyTop();
    }
}
