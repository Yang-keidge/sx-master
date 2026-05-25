package com.controller;

import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.entity.QiyeEntity;
import com.entity.ShixiEntity;
import com.entity.XueshengEntity;
import com.entity.YingpinEntity;
import com.entity.ZhaopinGangweiEntity;
import com.entity.view.YingpinView;
import com.service.DictionaryService;
import com.service.QiyeService;
import com.service.ShixiService;
import com.service.XueshengService;
import com.service.YingpinService;
import com.service.ZhaopinGangweiService;
import com.utils.PageUtils;
import com.utils.R;
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
import java.time.LocalDate;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 应聘学生后端接口
 */
@RestController
@Controller
@RequestMapping("/yingpin")
public class YingpinController {

    @Autowired
    private YingpinService yingpinService;

    @Autowired
    private ZhaopinGangweiService zhaopinGangweiService;

    @Autowired
    private XueshengService xueshengService;

    @Autowired
    private QiyeService qiyeService;

    @Autowired
    private ShixiService shixiService;

    @Autowired
    private DictionaryService dictionaryService;

    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params, HttpServletRequest request) {
        String role = String.valueOf(request.getSession().getAttribute("role"));
        if ("学生".equals(role)) {
            params.put("xueshengId", request.getSession().getAttribute("userId"));
        } else if ("企业".equals(role)) {
            params.put("qiyeId", request.getSession().getAttribute("userId"));
        }
        if (params.get("orderBy") == null || "".equals(params.get("orderBy"))) {
            params.put("orderBy", "id");
        }
        PageUtils page = yingpinService.queryPage(params);
        for (YingpinView item : (List<YingpinView>) page.getList()) {
            dictionaryService.dictionaryConvert(item, request);
        }
        return R.ok().put("data", page);
    }

    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id, HttpServletRequest request) {
        YingpinEntity yingpin = yingpinService.selectById(id);
        if (yingpin == null) {
            return R.error(511, "查不到数据");
        }
        R scopeCheck = checkScope(yingpin, request);
        if (scopeCheck != null) {
            return scopeCheck;
        }

        YingpinView view = new YingpinView();
        BeanUtils.copyProperties(yingpin, view);
        fillView(view);
        dictionaryService.dictionaryConvert(view, request);
        return R.ok().put("data", view);
    }

    @RequestMapping("/save")
    public R save(@RequestBody YingpinEntity yingpin, HttpServletRequest request) {
        String role = String.valueOf(request.getSession().getAttribute("role"));
        if ("学生".equals(role)) {
            yingpin.setXueshengId(Integer.valueOf(String.valueOf(request.getSession().getAttribute("userId"))));
        }
        R validate = prepareAndValidateApplication(yingpin);
        if (validate != null) {
            return validate;
        }
        yingpin.setYingpinStatus("待处理");
        yingpin.setCreateTime(new Date());
        yingpinService.insert(yingpin);
        return R.ok();
    }

    @RequestMapping("/update")
    public R update(@RequestBody YingpinEntity yingpin, HttpServletRequest request) {
        if (yingpin.getId() == null) {
            return R.error(511, "缺少应聘ID");
        }
        YingpinEntity old = yingpinService.selectById(yingpin.getId());
        if (old == null) {
            return R.error(511, "查不到数据");
        }
        R scopeCheck = checkScope(old, request);
        if (scopeCheck != null) {
            return scopeCheck;
        }
        R validate = prepareAndValidateApplication(yingpin);
        if (validate != null) {
            return validate;
        }
        yingpin.setYingpinStatus(old.getYingpinStatus());
        yingpinService.updateById(yingpin);
        return R.ok();
    }

    @RequestMapping("/apply/{zhaopinId}")
    public R apply(@PathVariable("zhaopinId") Integer zhaopinId, HttpServletRequest request) {
        String role = String.valueOf(request.getSession().getAttribute("role"));
        if (!"学生".equals(role)) {
            return R.error(403, "只有学生可以应聘");
        }
        YingpinEntity yingpin = new YingpinEntity();
        yingpin.setZhaopinId(zhaopinId);
        yingpin.setXueshengId(Integer.valueOf(String.valueOf(request.getSession().getAttribute("userId"))));
        R validate = prepareAndValidateApplication(yingpin);
        if (validate != null) {
            return validate;
        }
        yingpin.setYingpinStatus("待处理");
        yingpin.setCreateTime(new Date());
        yingpinService.insert(yingpin);
        return R.ok();
    }

    @Transactional
    @RequestMapping("/accept/{id}")
    public R accept(@PathVariable("id") Integer id, HttpServletRequest request) {
        YingpinEntity yingpin = yingpinService.selectById(id);
        if (yingpin == null) {
            return R.error(511, "查不到数据");
        }
        String role = String.valueOf(request.getSession().getAttribute("role"));
        if (!"企业".equals(role)) {
            return R.error(403, "只有企业可以录用应聘学生");
        }
        Integer qiyeId = (Integer) request.getSession().getAttribute("userId");
        if (!qiyeId.equals(yingpin.getQiyeId())) {
            return R.error(403, "只能录用应聘本企业岗位的学生");
        }

        ZhaopinGangweiEntity zhaopin = zhaopinGangweiService.selectById(yingpin.getZhaopinId());
        XueshengEntity xuesheng = xueshengService.selectById(yingpin.getXueshengId());
        if (zhaopin == null || xuesheng == null) {
            return R.error(511, "岗位或学生不存在");
        }
        if (isJobFull(zhaopin)) {
            return R.error(511, "该岗位已招满");
        }
        if (isStudentGraduated(xuesheng)) {
            return R.error(511, "您已毕业无法参加实习招聘");
        }
        if (isStudentInActiveInternship(xuesheng.getId())) {
            return R.error(511, "您正在实习中，如已离职请联系企业修改实习结束时间");
        }

        ShixiEntity shixi = new ShixiEntity();
        shixi.setXueshengId(yingpin.getXueshengId());
        shixi.setQiyeId(qiyeId);
        shixi.setShixiName("招聘录用实习");
        shixi.setShixiTypes(3);
        shixi.setShixiKaishiTime(today());
        shixi.setShixiJieshuTime(null);
        shixi.setShixiJieguoTypes(3);
        shixi.setShixiGangweiName(zhaopin.getZhaopinGangweiName());
        shixi.setShixiContent("由招聘应聘录用自动生成，实习类型为校企合作实习。");
        shixi.setCreateTime(new Date());
        shixiService.insert(shixi);

        zhaopin.setYizhaoRenshu(safeInt(zhaopin.getYizhaoRenshu()) + 1);
        zhaopinGangweiService.updateById(zhaopin);

        yingpinService.delete(new EntityWrapper<YingpinEntity>().eq("xuesheng_id", yingpin.getXueshengId()));
        return R.ok();
    }

    @Transactional
    @RequestMapping("/delete")
    public R delete(@RequestBody Integer[] ids, HttpServletRequest request) {
        for (Integer id : ids) {
            YingpinEntity yingpin = yingpinService.selectById(id);
            if (yingpin == null) {
                continue;
            }
            R scopeCheck = checkScope(yingpin, request);
            if (scopeCheck != null) {
                return scopeCheck;
            }
        }
        yingpinService.deleteBatchIds(Arrays.asList(ids));
        return R.ok();
    }

    private R prepareAndValidateApplication(YingpinEntity yingpin) {
        if (yingpin.getZhaopinId() == null) {
            return R.error(511, "请选择招聘岗位");
        }
        if (yingpin.getXueshengId() == null) {
            return R.error(511, "请选择学生");
        }
        ZhaopinGangweiEntity zhaopin = zhaopinGangweiService.selectById(yingpin.getZhaopinId());
        if (zhaopin == null) {
            return R.error(511, "招聘岗位不存在");
        }
        XueshengEntity xuesheng = xueshengService.selectById(yingpin.getXueshengId());
        if (xuesheng == null) {
            return R.error(511, "学生不存在");
        }
        if (isStudentInActiveInternship(xuesheng.getId())) {
            return R.error(511, "您正在实习中，如已离职请联系企业修改实习结束时间");
        }
        if (isStudentGraduated(xuesheng)) {
            return R.error(511, "您已毕业无法参加实习招聘");
        }
        if (isJobFull(zhaopin)) {
            return R.error(511, "该岗位已招满");
        }
        YingpinEntity duplicate = yingpinService.selectOne(new EntityWrapper<YingpinEntity>()
                .eq("zhaopin_id", yingpin.getZhaopinId())
                .eq("xuesheng_id", yingpin.getXueshengId()));
        if (duplicate != null && (yingpin.getId() == null || !duplicate.getId().equals(yingpin.getId()))) {
            return R.error(511, "您已应聘该岗位");
        }
        yingpin.setQiyeId(zhaopin.getQiyeId());
        return null;
    }

    private R checkScope(YingpinEntity yingpin, HttpServletRequest request) {
        String role = String.valueOf(request.getSession().getAttribute("role"));
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if ("学生".equals(role) && !userId.equals(yingpin.getXueshengId())) {
            return R.error(403, "只能操作自己的应聘数据");
        }
        if ("企业".equals(role) && !userId.equals(yingpin.getQiyeId())) {
            return R.error(403, "只能操作本企业的应聘数据");
        }
        return null;
    }

    private void fillView(YingpinView view) {
        ZhaopinGangweiEntity zhaopin = zhaopinGangweiService.selectById(view.getZhaopinId());
        if (zhaopin != null) {
            BeanUtils.copyProperties(zhaopin, view, new String[]{"id", "createTime"});
            view.setZhaopinId(zhaopin.getId());
        }
        QiyeEntity qiye = qiyeService.selectById(view.getQiyeId());
        if (qiye != null) {
            BeanUtils.copyProperties(qiye, view, new String[]{"id", "createTime", "updateTime"});
            view.setQiyeId(qiye.getId());
        }
        XueshengEntity xuesheng = xueshengService.selectById(view.getXueshengId());
        if (xuesheng != null) {
            BeanUtils.copyProperties(xuesheng, view, new String[]{"id", "createTime", "updateTime"});
            view.setXueshengId(xuesheng.getId());
        }
    }

    private boolean isStudentGraduated(XueshengEntity xuesheng) {
        if (xuesheng == null || xuesheng.getRuxueYear() == null) {
            return false;
        }
        LocalDate graduationDate = LocalDate.of(xuesheng.getRuxueYear() + 4, 6, 1);
        return !LocalDate.now().isBefore(graduationDate);
    }

    private boolean isStudentInActiveInternship(Integer xueshengId) {
        if (xueshengId == null) {
            return false;
        }
        Date today = today();
        List<ShixiEntity> internships = shixiService.selectList(new EntityWrapper<ShixiEntity>().eq("xuesheng_id", xueshengId));
        for (ShixiEntity shixi : internships) {
            Date start = truncate(shixi.getShixiKaishiTime());
            Date end = truncate(shixi.getShixiJieshuTime());
            boolean started = start == null || !start.after(today);
            boolean notEnded = end == null || !end.before(today);
            if (started && notEnded) {
                return true;
            }
        }
        return false;
    }

    private boolean isJobFull(ZhaopinGangweiEntity zhaopin) {
        return safeInt(zhaopin.getYizhaoRenshu()) >= safeInt(zhaopin.getZhaopinRenshu());
    }

    private int safeInt(Integer value) {
        return value == null ? 0 : value;
    }

    private Date today() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        return calendar.getTime();
    }

    private Date truncate(Date value) {
        if (value == null) {
            return null;
        }
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(value);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        return calendar.getTime();
    }
}
