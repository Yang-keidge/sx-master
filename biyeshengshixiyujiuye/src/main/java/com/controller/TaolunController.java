package com.controller;

import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.mapper.Wrapper;
import com.entity.LaoshiEntity;
import com.entity.QiyeEntity;
import com.entity.TaolunEntity;
import com.entity.TaolunHuifuEntity;
import com.entity.UsersEntity;
import com.entity.XueshengEntity;
import com.entity.view.TaolunView;
import com.service.LaoshiService;
import com.service.QiyeService;
import com.service.TaolunHuifuService;
import com.service.TaolunService;
import com.service.UsersService;
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
 * 讨论区帖子
 */
@RestController
@Controller
@RequestMapping("/taolun")
public class TaolunController {
    private static final Logger logger = LoggerFactory.getLogger(TaolunController.class);

    @Resource
    private TaolunService taolunService;

    @Resource
    private TaolunHuifuService taolunHuifuService;

    @Resource
    private XueshengService xueshengService;

    @Resource
    private LaoshiService laoshiService;

    @Resource
    private QiyeService qiyeService;

    @Resource
    private UsersService usersService;

    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params, HttpServletRequest request) {
        logger.debug("page方法:,,Controller:{},,params:{}", this.getClass().getName(), JSONObject.toJSONString(params));
        if (params.get("orderBy") == null || params.get("orderBy") == "") {
            params.put("orderBy", "create_time");
        }
        if ("true".equals(String.valueOf(params.get("myOnly")))) {
            params.put("fabuzheId", request.getSession().getAttribute("userId"));
            params.put("fabuzheRole", request.getSession().getAttribute("role"));
        }
        PageUtils page = taolunService.queryPage(params);
        return R.ok().put("data", page);
    }

    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id) {
        logger.debug("info方法:,,Controller:{},,id:{}", this.getClass().getName(), id);
        Map<String, Object> params = new HashMap<>();
        params.put("page", "1");
        params.put("limit", "1");
        params.put("orderBy", "id");
        params.put("ids", Arrays.asList(id));
        PageUtils page = taolunService.queryPage(params);
        List<TaolunView> list = (List<TaolunView>) page.getList();
        if (list != null && !list.isEmpty()) {
            return R.ok().put("data", list.get(0));
        }
        return R.error(511, "查不到数据");
    }

    @RequestMapping("/save")
    public R save(@RequestBody TaolunEntity taolun, HttpServletRequest request) {
        logger.debug("save方法:,,Controller:{},,taolun:{}", this.getClass().getName(), taolun.toString());
        if (StringUtils.isBlank(taolun.getTaolunTitle())) {
            return R.error(511, "帖子标题不能为空");
        }
        if (StringUtils.isBlank(taolun.getTaolunContent())) {
            return R.error(511, "帖子内容不能为空");
        }
        fillPublisher(taolun, request);
        Date date = new Date();
        taolun.setCreateTime(date);
        taolun.setUpdateTime(date);
        taolunService.insert(taolun);
        return R.ok();
    }

    @RequestMapping("/update")
    public R update(@RequestBody TaolunEntity taolun, HttpServletRequest request) {
        logger.debug("update方法:,,Controller:{},,taolun:{}", this.getClass().getName(), taolun.toString());
        if (taolun.getId() == null) {
            return R.error(511, "帖子不能为空");
        }
        if (StringUtils.isBlank(taolun.getTaolunTitle())) {
            return R.error(511, "帖子标题不能为空");
        }
        if (StringUtils.isBlank(taolun.getTaolunContent())) {
            return R.error(511, "帖子内容不能为空");
        }
        TaolunEntity oldTaolun = taolunService.selectById(taolun.getId());
        if (oldTaolun == null) {
            return R.error(511, "查不到数据");
        }
        if (!canManage(oldTaolun, request)) {
            return R.error(403, "只能修改自己的帖子");
        }

        TaolunEntity updateTaolun = new TaolunEntity();
        updateTaolun.setId(oldTaolun.getId());
        updateTaolun.setTaolunTitle(taolun.getTaolunTitle());
        updateTaolun.setTaolunContent(taolun.getTaolunContent());
        updateTaolun.setUpdateTime(new Date());
        taolunService.updateById(updateTaolun);
        return R.ok();
    }

    @RequestMapping("/delete")
    public R delete(@RequestBody Integer[] ids, HttpServletRequest request) {
        logger.debug("delete:,,Controller:{},,ids:{}", this.getClass().getName(), ids.toString());
        if (ids == null || ids.length == 0) {
            return R.error(511, "帖子不能为空");
        }
        Wrapper<TaolunEntity> queryWrapper = new EntityWrapper<TaolunEntity>().in("id", Arrays.asList(ids));
        for (TaolunEntity taolun : taolunService.selectList(queryWrapper)) {
            if (!canManage(taolun, request)) {
                return R.error(403, "只能删除自己的帖子");
            }
        }
        taolunHuifuService.delete(new EntityWrapper<TaolunHuifuEntity>().in("taolun_id", Arrays.asList(ids)));
        taolunService.deleteBatchIds(Arrays.asList(ids));
        return R.ok();
    }

    private void fillPublisher(TaolunEntity taolun, HttpServletRequest request) {
        Integer userId = currentUserId(request);
        String role = String.valueOf(request.getSession().getAttribute("role"));
        String tableName = String.valueOf(request.getSession().getAttribute("tableName"));
        taolun.setFabuzheId(userId);
        taolun.setFabuzheRole(role);
        taolun.setFabuzheTable(tableName);
        taolun.setFabuzheName(getUserName(tableName, userId));
    }

    private String getUserName(String tableName, Integer userId) {
        if ("xuesheng".equals(tableName)) {
            XueshengEntity xuesheng = xueshengService.selectById(userId);
            return xuesheng == null ? "" : xuesheng.getXueshengName();
        } else if ("laoshi".equals(tableName)) {
            LaoshiEntity laoshi = laoshiService.selectById(userId);
            return laoshi == null ? "" : laoshi.getLaoshiName();
        } else if ("qiye".equals(tableName)) {
            QiyeEntity qiye = qiyeService.selectById(userId);
            return qiye == null ? "" : qiye.getQiyeName();
        } else {
            UsersEntity users = usersService.selectById(userId);
            return users == null ? "" : users.getUsername();
        }
    }

    private boolean canManage(TaolunEntity taolun, HttpServletRequest request) {
        String role = String.valueOf(request.getSession().getAttribute("role"));
        if ("管理员".equals(role)) {
            return true;
        }
        return currentUserId(request).equals(taolun.getFabuzheId()) && role.equals(taolun.getFabuzheRole());
    }

    private Integer currentUserId(HttpServletRequest request) {
        return Integer.valueOf(String.valueOf(request.getSession().getAttribute("userId")));
    }
}
