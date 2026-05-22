package com.controller;

import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.mapper.Wrapper;
import com.entity.GonggaoEntity;
import com.entity.GonggaoCommentEntity;
import com.entity.view.GonggaoView;
import com.service.DictionaryService;
import com.service.GonggaoCommentService;
import com.service.GonggaoService;
import com.utils.PageUtils;
import com.utils.R;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 公告
 */
@RestController
@Controller
@RequestMapping("/gonggao")
public class GonggaoController {
    private static final Logger logger = LoggerFactory.getLogger(GonggaoController.class);

    @Autowired
    private GonggaoService gonggaoService;

    @Autowired
    private GonggaoCommentService gonggaoCommentService;

    @Autowired
    private DictionaryService dictionaryService;

    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params, HttpServletRequest request) {
        logger.debug("page方法:,,Controller:{},,params:{}", this.getClass().getName(), JSONObject.toJSONString(params));
        if (params.get("orderBy") == null || params.get("orderBy") == "") {
            params.put("orderBy", "id");
        }
        if ("true".equals(String.valueOf(params.get("myOnly")))) {
            params.put("fabuzheId", request.getSession().getAttribute("userId"));
            params.put("fabuzheRole", request.getSession().getAttribute("role"));
        }
        PageUtils page = gonggaoService.queryPage(params);

        List<GonggaoView> list = (List<GonggaoView>) page.getList();
        for (GonggaoView c : list) {
            dictionaryService.dictionaryConvert(c, request);
        }
        return R.ok().put("data", page);
    }

    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id, HttpServletRequest request) {
        logger.debug("info方法:,,Controller:{},,id:{}", this.getClass().getName(), id);
        GonggaoEntity gonggao = gonggaoService.selectById(id);
        if (gonggao != null) {
            GonggaoView view = new GonggaoView();
            BeanUtils.copyProperties(gonggao, view);
            view.setCommentCount(gonggaoCommentService.selectCount(new EntityWrapper<GonggaoCommentEntity>().eq("gonggao_id", id)));
            dictionaryService.dictionaryConvert(view, request);
            return R.ok().put("data", view);
        } else {
            return R.error(511, "查不到数据");
        }
    }

    @RequestMapping("/save")
    public R save(@RequestBody GonggaoEntity gonggao, HttpServletRequest request) {
        logger.debug("save方法:,,Controller:{},,gonggao:{}", this.getClass().getName(), gonggao.toString());
        fillPublisher(gonggao, request);

        Wrapper<GonggaoEntity> queryWrapper = new EntityWrapper<GonggaoEntity>()
                .eq("fabuzhe_id", gonggao.getFabuzheId())
                .eq("fabuzhe_role", gonggao.getFabuzheRole())
                .eq("gonggao_name", gonggao.getGonggaoName());

        GonggaoEntity gonggaoEntity = gonggaoService.selectOne(queryWrapper);
        if (gonggaoEntity == null) {
            gonggao.setInsertTime(new Date());
            gonggao.setCreateTime(new Date());
            gonggaoService.insert(gonggao);
            return R.ok();
        } else {
            return R.error(511, "当前发布者已有相同标题的公告");
        }
    }

    @RequestMapping("/update")
    public R update(@RequestBody GonggaoEntity gonggao, HttpServletRequest request) {
        logger.debug("update方法:,,Controller:{},,gonggao:{}", this.getClass().getName(), gonggao.toString());
        if (StringUtils.isBlank(gonggao.getFabuzheRole()) || gonggao.getFabuzheId() == null) {
            fillPublisher(gonggao, request);
        }

        Wrapper<GonggaoEntity> queryWrapper = new EntityWrapper<GonggaoEntity>()
                .notIn("id", gonggao.getId())
                .andNew()
                .eq("fabuzhe_id", gonggao.getFabuzheId())
                .eq("fabuzhe_role", gonggao.getFabuzheRole())
                .eq("gonggao_name", gonggao.getGonggaoName());

        GonggaoEntity gonggaoEntity = gonggaoService.selectOne(queryWrapper);
        if ("".equals(gonggao.getGonggaoContent()) || "null".equals(gonggao.getGonggaoContent())) {
            gonggao.setGonggaoContent(null);
        }
        if (gonggaoEntity == null) {
            gonggaoService.updateById(gonggao);
            return R.ok();
        } else {
            return R.error(511, "当前发布者已有相同标题的公告");
        }
    }

    @RequestMapping("/delete")
    public R delete(@RequestBody Integer[] ids) {
        logger.debug("delete:,,Controller:{},,ids:{}", this.getClass().getName(), ids.toString());
        gonggaoService.deleteBatchIds(Arrays.asList(ids));
        return R.ok();
    }

    private void fillPublisher(GonggaoEntity gonggao, HttpServletRequest request) {
        String role = String.valueOf(request.getSession().getAttribute("role"));
        Integer userId = Integer.valueOf(String.valueOf(request.getSession().getAttribute("userId")));
        gonggao.setFabuzheId(userId);
        gonggao.setFabuzheRole(role);
        if ("老师".equals(role)) {
            gonggao.setFabuzheTable("laoshi");
        } else if ("企业".equals(role)) {
            gonggao.setFabuzheTable("qiye");
        } else {
            gonggao.setFabuzheTable("users");
            gonggao.setFabuzheRole("管理员");
        }
    }
}
