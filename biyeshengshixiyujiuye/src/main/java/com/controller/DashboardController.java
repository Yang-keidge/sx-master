package com.controller;

import com.service.DashboardService;
import com.utils.R;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * Dashboard 数据统计 Controller
 */
@RestController
@RequestMapping("/dashboard")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;

    /**
     * 基础统计数据
     */
    @GetMapping("/base")
    public R base() {
        Map<String, Object> data = dashboardService.getBaseData();
        return R.ok().put("data", data);
    }

    /**
     * 实习类型统计
     */
    @GetMapping("/shixiType")
    public R shixiType() {
        List<Map<String, Object>> data = dashboardService.getShixiTypeStats();
        return R.ok().put("data", data);
    }

    /**
     * 就业率统计
     */
    @GetMapping("/employmentRate")
    public R employmentRate() {
        Map<String, Object> baseData = dashboardService.getBaseData();
        return R.ok().put("data", baseData.get("employmentRate"));
    }

    /**
     * 实习结果统计
     */
    @GetMapping("/shixiResult")
    public R shixiResult() {
        List<Map<String, Object>> data = dashboardService.getShixiResultStats();
        return R.ok().put("data", data);
    }

    /**
     * 月度趋势分析
     */
    @GetMapping("/monthTrend")
    public R monthTrend() {
        Map<String, Object> data = dashboardService.getMonthTrend();
        return R.ok().put("data", data);
    }

    /**
     * 企业招聘 TOP10
     */
    @GetMapping("/companyTop")
    public R companyTop() {
        List<Map<String, Object>> data = dashboardService.getCompanyTop();
        return R.ok().put("data", data);
    }
}
