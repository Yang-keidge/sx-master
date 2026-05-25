package com.controller;

import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.mapper.Wrapper;
import com.entity.LaoshiEntity;
import com.entity.WentiJiedaEntity;
import com.entity.XueshengEntity;
import com.entity.view.WentiJiedaView;
import com.service.DictionaryService;
import com.service.LaoshiService;
import com.service.WentiJiedaService;
import com.service.XueshengService;
import com.utils.PageUtils;
import com.utils.R;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 问题解答
 */
@RestController
@Controller
@RequestMapping("/wentiJieda")
public class WentiJiedaController {
    private static final Logger logger = LoggerFactory.getLogger(WentiJiedaController.class);

    private static final String STATUS_UNREPLIED = "未回复";
    private static final String STATUS_REPLIED = "已回复";

    @Resource
    private WentiJiedaService wentiJiedaService;

    @Resource
    private XueshengService xueshengService;

    @Resource
    private LaoshiService laoshiService;

    @Resource
    private DictionaryService dictionaryService;

    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params, HttpServletRequest request) {
        logger.debug("page方法:,,Controller:{},,params:{}", this.getClass().getName(), JSONObject.toJSONString(params));
        if (params.get("orderBy") == null || params.get("orderBy") == "") {
            params.put("orderBy", "create_time");
        }
        applyRoleScope(params, request);
        PageUtils page = wentiJiedaService.queryPage(params);

        List<WentiJiedaView> list = (List<WentiJiedaView>) page.getList();
        for (WentiJiedaView c : list) {
            dictionaryService.dictionaryConvert(c, request);
        }
        return R.ok().put("data", page);
    }

    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id, HttpServletRequest request) {
        logger.debug("info方法:,,Controller:{},,id:{}", this.getClass().getName(), id);
        WentiJiedaEntity wentiJieda = wentiJiedaService.selectById(id);
        if (wentiJieda == null) {
            return R.error(511, "查不到数据");
        }
        if (!canView(wentiJieda, request)) {
            return R.error(403, "无权查看该问题");
        }

        Map<String, Object> params = new HashMap<>();
        params.put("page", "1");
        params.put("limit", "1");
        params.put("orderBy", "id");
        params.put("ids", Arrays.asList(id));
        PageUtils page = wentiJiedaService.queryPage(params);
        List<WentiJiedaView> list = (List<WentiJiedaView>) page.getList();
        if (list != null && !list.isEmpty()) {
            WentiJiedaView view = list.get(0);
            dictionaryService.dictionaryConvert(view, request);
            return R.ok().put("data", view);
        }
        return R.error(511, "查不到数据");
    }

    @RequestMapping("/save")
    public R save(@RequestBody WentiJiedaEntity wentiJieda, HttpServletRequest request) {
        logger.debug("save方法:,,Controller:{},,wentiJieda:{}", this.getClass().getName(), wentiJieda.toString());
        if (!"学生".equals(currentRole(request))) {
            return R.error(403, "只有学生可以发布问题");
        }
        if (wentiJieda.getLaoshiId() == null) {
            return R.error(511, "请选择答疑老师");
        }
        if (StringUtils.isBlank(wentiJieda.getWentiTitle())) {
            return R.error(511, "问题标题不能为空");
        }
        if (StringUtils.isBlank(wentiJieda.getWentiContent())) {
            return R.error(511, "问题内容不能为空");
        }
        Integer studentId = currentUserId(request);
        XueshengEntity xuesheng = xueshengService.selectById(studentId);
        LaoshiEntity laoshi = laoshiService.selectById(wentiJieda.getLaoshiId());
        if (xuesheng == null) {
            return R.error(511, "学生信息不存在");
        }
        if (laoshi == null) {
            return R.error(511, "老师信息不存在");
        }
        if (!sameMajor(xuesheng, laoshi)) {
            return R.error(511, "只能向本专业老师提问");
        }

        Date date = new Date();
        wentiJieda.setXueshengId(studentId);
        wentiJieda.setWentiStatus(STATUS_UNREPLIED);
        wentiJieda.setCreateTime(date);
        wentiJieda.setUpdateTime(date);
        wentiJiedaService.insert(wentiJieda);
        return R.ok();
    }

    @RequestMapping("/update")
    public R update(@RequestBody WentiJiedaEntity wentiJieda, HttpServletRequest request) {
        logger.debug("update方法:,,Controller:{},,wentiJieda:{}", this.getClass().getName(), wentiJieda.toString());
        if (wentiJieda.getId() == null) {
            return R.error(511, "问题不能为空");
        }
        WentiJiedaEntity oldWenti = wentiJiedaService.selectById(wentiJieda.getId());
        if (oldWenti == null) {
            return R.error(511, "查不到数据");
        }

        String role = currentRole(request);
        if ("老师".equals(role)) {
            return teacherReply(wentiJieda, oldWenti, request);
        } else if ("学生".equals(role)) {
            return studentUpdate(wentiJieda, oldWenti, request);
        } else if ("管理员".equals(role)) {
            return adminUpdate(wentiJieda, oldWenti);
        }
        return R.error(403, "无权修改该问题");
    }

    @RequestMapping("/delete")
    public R delete(@RequestBody Integer[] ids, HttpServletRequest request) {
        logger.debug("delete:,,Controller:{},,ids:{}", this.getClass().getName(), ids.toString());
        if (ids == null || ids.length == 0) {
            return R.error(511, "问题不能为空");
        }
        Wrapper<WentiJiedaEntity> queryWrapper = new EntityWrapper<WentiJiedaEntity>().in("id", Arrays.asList(ids));
        for (WentiJiedaEntity wenti : wentiJiedaService.selectList(queryWrapper)) {
            if (!canDelete(wenti, request)) {
                return R.error(403, "只能删除自己的问题");
            }
        }
        wentiJiedaService.deleteBatchIds(Arrays.asList(ids));
        return R.ok();
    }

    private R teacherReply(WentiJiedaEntity newWenti, WentiJiedaEntity oldWenti, HttpServletRequest request) {
        if (StringUtils.isBlank(newWenti.getHuifuContent())) {
            return R.error(511, "回复内容不能为空");
        }
        Integer teacherId = currentUserId(request);
        LaoshiEntity laoshi = laoshiService.selectById(teacherId);
        XueshengEntity xuesheng = xueshengService.selectById(oldWenti.getXueshengId());
        if (laoshi == null || xuesheng == null || !sameMajor(xuesheng, laoshi)) {
            return R.error(403, "只能回复本专业学生的问题");
        }
        if (oldWenti.getLaoshiId() != null && !teacherId.equals(oldWenti.getLaoshiId())) {
            return R.error(403, "只能回复分配给自己的问题");
        }

        WentiJiedaEntity updateWenti = new WentiJiedaEntity();
        updateWenti.setId(oldWenti.getId());
        updateWenti.setLaoshiId(oldWenti.getLaoshiId() == null ? teacherId : oldWenti.getLaoshiId());
        updateWenti.setHuifuContent(newWenti.getHuifuContent());
        updateWenti.setHuifuLaoshiId(teacherId);
        updateWenti.setHuifuTime(new Date());
        updateWenti.setWentiStatus(STATUS_REPLIED);
        updateWenti.setUpdateTime(new Date());
        wentiJiedaService.updateById(updateWenti);
        return R.ok();
    }

    private R studentUpdate(WentiJiedaEntity newWenti, WentiJiedaEntity oldWenti, HttpServletRequest request) {
        if (!currentUserId(request).equals(oldWenti.getXueshengId())) {
            return R.error(403, "只能修改自己的问题");
        }
        if (STATUS_REPLIED.equals(oldWenti.getWentiStatus())) {
            return R.error(511, "老师已回复的问题不能修改");
        }
        if (newWenti.getLaoshiId() == null) {
            return R.error(511, "请选择答疑老师");
        }
        if (StringUtils.isBlank(newWenti.getWentiTitle())) {
            return R.error(511, "问题标题不能为空");
        }
        if (StringUtils.isBlank(newWenti.getWentiContent())) {
            return R.error(511, "问题内容不能为空");
        }

        XueshengEntity xuesheng = xueshengService.selectById(oldWenti.getXueshengId());
        LaoshiEntity laoshi = laoshiService.selectById(newWenti.getLaoshiId());
        if (xuesheng == null || laoshi == null || !sameMajor(xuesheng, laoshi)) {
            return R.error(511, "只能向本专业老师提问");
        }

        WentiJiedaEntity updateWenti = new WentiJiedaEntity();
        updateWenti.setId(oldWenti.getId());
        updateWenti.setLaoshiId(newWenti.getLaoshiId());
        updateWenti.setWentiTitle(newWenti.getWentiTitle());
        updateWenti.setWentiContent(newWenti.getWentiContent());
        updateWenti.setUpdateTime(new Date());
        wentiJiedaService.updateById(updateWenti);
        return R.ok();
    }

    private R adminUpdate(WentiJiedaEntity newWenti, WentiJiedaEntity oldWenti) {
        if (StringUtils.isBlank(newWenti.getWentiTitle())) {
            return R.error(511, "问题标题不能为空");
        }
        if (StringUtils.isBlank(newWenti.getWentiContent())) {
            return R.error(511, "问题内容不能为空");
        }
        WentiJiedaEntity updateWenti = new WentiJiedaEntity();
        updateWenti.setId(oldWenti.getId());
        updateWenti.setLaoshiId(newWenti.getLaoshiId());
        updateWenti.setWentiTitle(newWenti.getWentiTitle());
        updateWenti.setWentiContent(newWenti.getWentiContent());
        updateWenti.setHuifuContent(newWenti.getHuifuContent());
        updateWenti.setWentiStatus(StringUtils.isBlank(newWenti.getHuifuContent()) ? STATUS_UNREPLIED : STATUS_REPLIED);
        updateWenti.setUpdateTime(new Date());
        if (StringUtils.isNotBlank(newWenti.getHuifuContent()) && oldWenti.getHuifuTime() == null) {
            updateWenti.setHuifuTime(new Date());
        }
        wentiJiedaService.updateById(updateWenti);
        return R.ok();
    }

    private void applyRoleScope(Map<String, Object> params, HttpServletRequest request) {
        String role = currentRole(request);
        if ("学生".equals(role)) {
            params.put("xueshengId", request.getSession().getAttribute("userId"));
        } else if ("老师".equals(role)) {
            LaoshiEntity laoshi = laoshiService.selectById(currentUserId(request));
            if (laoshi == null || laoshi.getYuanxiTypes() == null || laoshi.getZhuanyeTypes() == null) {
                params.put("yuanxiTypes", -1);
                params.put("zhuanyeTypes", -1);
                return;
            }
            params.put("teacherScopeId", request.getSession().getAttribute("userId"));
            params.put("yuanxiTypes", laoshi.getYuanxiTypes());
            params.put("zhuanyeTypes", laoshi.getZhuanyeTypes());
        }
    }

    private boolean canView(WentiJiedaEntity wentiJieda, HttpServletRequest request) {
        String role = currentRole(request);
        if ("管理员".equals(role)) {
            return true;
        }
        if ("学生".equals(role)) {
            return currentUserId(request).equals(wentiJieda.getXueshengId());
        }
        if ("老师".equals(role)) {
            Integer teacherId = currentUserId(request);
            if (wentiJieda.getLaoshiId() != null && !teacherId.equals(wentiJieda.getLaoshiId())) {
                return false;
            }
            XueshengEntity xuesheng = xueshengService.selectById(wentiJieda.getXueshengId());
            LaoshiEntity laoshi = laoshiService.selectById(teacherId);
            return xuesheng != null && laoshi != null && sameMajor(xuesheng, laoshi);
        }
        return false;
    }

    private boolean canDelete(WentiJiedaEntity wentiJieda, HttpServletRequest request) {
        String role = currentRole(request);
        if ("管理员".equals(role)) {
            return true;
        }
        return "学生".equals(role) && currentUserId(request).equals(wentiJieda.getXueshengId());
    }

    private boolean sameMajor(XueshengEntity xuesheng, LaoshiEntity laoshi) {
        return xuesheng.getYuanxiTypes() != null
                && xuesheng.getZhuanyeTypes() != null
                && xuesheng.getYuanxiTypes().equals(laoshi.getYuanxiTypes())
                && xuesheng.getZhuanyeTypes().equals(laoshi.getZhuanyeTypes());
    }

    private String currentRole(HttpServletRequest request) {
        return String.valueOf(request.getSession().getAttribute("role"));
    }

    private Integer currentUserId(HttpServletRequest request) {
        return Integer.valueOf(String.valueOf(request.getSession().getAttribute("userId")));
    }
}
