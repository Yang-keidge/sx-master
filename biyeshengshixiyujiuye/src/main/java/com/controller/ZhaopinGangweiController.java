package com.controller;

import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.entity.QiyeEntity;
import com.entity.YingpinEntity;
import com.entity.ZhaopinGangweiEntity;
import com.entity.view.ZhaopinGangweiView;
import com.service.DictionaryService;
import com.service.QiyeService;
import com.service.YingpinService;
import com.service.ZhaopinGangweiService;
import com.utils.PageUtils;
import com.utils.R;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.Date;
import java.util.Map;

/**
 * 招聘岗位后端接口
 */
@RestController
@Controller
@RequestMapping("/zhaopinGangwei")
public class ZhaopinGangweiController {
    private static final Logger logger = LoggerFactory.getLogger(ZhaopinGangweiController.class);

    @Autowired
    private ZhaopinGangweiService zhaopinGangweiService;

    @Autowired
    private QiyeService qiyeService;

    @Autowired
    private YingpinService yingpinService;

    @Autowired
    private DictionaryService dictionaryService;

    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params, HttpServletRequest request) {
        logger.debug("page方法:,,Controller:{},,params:{}", this.getClass().getName(), JSONObject.toJSONString(params));
        String role = String.valueOf(request.getSession().getAttribute("role"));
        if ("企业".equals(role)) {
            params.put("qiyeId", request.getSession().getAttribute("userId"));
        }
        if (params.get("orderBy") == null || "".equals(params.get("orderBy"))) {
            params.put("orderBy", "id");
        }
        PageUtils page = zhaopinGangweiService.queryPage(params);
        for (ZhaopinGangweiView item : (java.util.List<ZhaopinGangweiView>) page.getList()) {
            dictionaryService.dictionaryConvert(item, request);
        }
        return R.ok().put("data", page);
    }

    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id, HttpServletRequest request) {
        ZhaopinGangweiEntity zhaopinGangwei = zhaopinGangweiService.selectById(id);
        if (zhaopinGangwei == null) {
            return R.error(511, "查不到数据");
        }
        R scopeCheck = checkCompanyScope(zhaopinGangwei, request);
        if (scopeCheck != null) {
            return scopeCheck;
        }

        ZhaopinGangweiView view = new ZhaopinGangweiView();
        BeanUtils.copyProperties(zhaopinGangwei, view);
        QiyeEntity qiye = qiyeService.selectById(zhaopinGangwei.getQiyeId());
        if (qiye != null) {
            BeanUtils.copyProperties(qiye, view, new String[]{"id", "createTime", "updateTime"});
            view.setQiyeId(qiye.getId());
        }
        dictionaryService.dictionaryConvert(view, request);
        return R.ok().put("data", view);
    }

    @RequestMapping("/save")
    public R save(@RequestBody ZhaopinGangweiEntity zhaopinGangwei, HttpServletRequest request) {
        String role = String.valueOf(request.getSession().getAttribute("role"));
        if ("企业".equals(role)) {
            zhaopinGangwei.setQiyeId(Integer.valueOf(String.valueOf(request.getSession().getAttribute("userId"))));
        }
        R validate = validateJob(zhaopinGangwei);
        if (validate != null) {
            return validate;
        }
        zhaopinGangwei.setYizhaoRenshu(0);
        zhaopinGangwei.setCreateTime(new Date());
        zhaopinGangweiService.insert(zhaopinGangwei);
        return R.ok();
    }

    @RequestMapping("/update")
    public R update(@RequestBody ZhaopinGangweiEntity zhaopinGangwei, HttpServletRequest request) {
        if (zhaopinGangwei.getId() == null) {
            return R.error(511, "缺少岗位ID");
        }
        ZhaopinGangweiEntity old = zhaopinGangweiService.selectById(zhaopinGangwei.getId());
        if (old == null) {
            return R.error(511, "查不到数据");
        }
        R scopeCheck = checkCompanyScope(old, request);
        if (scopeCheck != null) {
            return scopeCheck;
        }
        String role = String.valueOf(request.getSession().getAttribute("role"));
        if ("企业".equals(role)) {
            zhaopinGangwei.setQiyeId(old.getQiyeId());
            zhaopinGangwei.setYizhaoRenshu(old.getYizhaoRenshu());
        }
        R validate = validateJob(zhaopinGangwei);
        if (validate != null) {
            return validate;
        }
        zhaopinGangweiService.updateById(zhaopinGangwei);
        return R.ok();
    }

    @Transactional
    @RequestMapping("/delete")
    public R delete(@RequestBody Integer[] ids, HttpServletRequest request) {
        for (Integer id : ids) {
            ZhaopinGangweiEntity zhaopinGangwei = zhaopinGangweiService.selectById(id);
            if (zhaopinGangwei == null) {
                continue;
            }
            R scopeCheck = checkCompanyScope(zhaopinGangwei, request);
            if (scopeCheck != null) {
                return scopeCheck;
            }
        }
        yingpinService.delete(new EntityWrapper<YingpinEntity>().in("zhaopin_id", Arrays.asList(ids)));
        zhaopinGangweiService.deleteBatchIds(Arrays.asList(ids));
        return R.ok();
    }

    private R validateJob(ZhaopinGangweiEntity zhaopinGangwei) {
        if (zhaopinGangwei.getQiyeId() == null) {
            return R.error(511, "请选择企业");
        }
        if (StringUtils.isBlank(zhaopinGangwei.getZhaopinGangweiName())) {
            return R.error(511, "请填写职位名称");
        }
        if (StringUtils.isBlank(zhaopinGangwei.getZhaopinLeixing())) {
            return R.error(511, "请填写职位类型");
        }
        if (StringUtils.isBlank(zhaopinGangwei.getXinziFanwei())) {
            return R.error(511, "请填写薪资范围");
        }
        if (StringUtils.isBlank(zhaopinGangwei.getGongzuoDizhi())) {
            return R.error(511, "请填写工作地址");
        }
        if (StringUtils.isBlank(zhaopinGangwei.getGongzuoYaoqiu())) {
            return R.error(511, "请填写工作要求");
        }
        if (zhaopinGangwei.getZhaopinRenshu() == null || zhaopinGangwei.getZhaopinRenshu() <= 0) {
            return R.error(511, "招聘数量必须大于0");
        }
        if (zhaopinGangwei.getYizhaoRenshu() == null) {
            zhaopinGangwei.setYizhaoRenshu(0);
        }
        if (zhaopinGangwei.getYizhaoRenshu() < 0) {
            return R.error(511, "已招人数不能小于0");
        }
        if (zhaopinGangwei.getYizhaoRenshu() > zhaopinGangwei.getZhaopinRenshu()) {
            return R.error(511, "已招人数不能大于招聘数量");
        }
        if (qiyeService.selectById(zhaopinGangwei.getQiyeId()) == null) {
            return R.error(511, "企业不存在");
        }
        return null;
    }

    private R checkCompanyScope(ZhaopinGangweiEntity zhaopinGangwei, HttpServletRequest request) {
        String role = String.valueOf(request.getSession().getAttribute("role"));
        if (!"企业".equals(role)) {
            return null;
        }
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (zhaopinGangwei.getQiyeId() == null || !zhaopinGangwei.getQiyeId().equals(userId)) {
            return R.error(403, "只能操作本企业的招聘岗位");
        }
        return null;
    }
}
