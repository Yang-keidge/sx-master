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
import java.util.Map;

/**
 * 讨论区回复
 */
@RestController
@Controller
@RequestMapping("/taolunHuifu")
public class TaolunHuifuController {
    private static final Logger logger = LoggerFactory.getLogger(TaolunHuifuController.class);

    @Resource
    private TaolunHuifuService taolunHuifuService;

    @Resource
    private TaolunService taolunService;

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
            params.put("huifurenId", request.getSession().getAttribute("userId"));
            params.put("huifurenRole", request.getSession().getAttribute("role"));
        }
        PageUtils page = taolunHuifuService.queryPage(params);
        return R.ok().put("data", page);
    }

    @RequestMapping("/list")
    public R list(@RequestParam Map<String, Object> params) {
        if (params.get("orderBy") == null || params.get("orderBy") == "") {
            params.put("orderBy", "create_time");
        }
        PageUtils page = taolunHuifuService.queryPage(params);
        return R.ok().put("data", page);
    }

    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id) {
        logger.debug("info方法:,,Controller:{},,id:{}", this.getClass().getName(), id);
        TaolunHuifuEntity taolunHuifu = taolunHuifuService.selectById(id);
        if (taolunHuifu != null) {
            return R.ok().put("data", taolunHuifu);
        }
        return R.error(511, "查不到数据");
    }

    @RequestMapping("/save")
    public R save(@RequestBody TaolunHuifuEntity taolunHuifu, HttpServletRequest request) {
        logger.debug("save方法:,,Controller:{},,taolunHuifu:{}", this.getClass().getName(), taolunHuifu.toString());
        if (taolunHuifu.getTaolunId() == null) {
            return R.error(511, "帖子不能为空");
        }
        TaolunEntity taolun = taolunService.selectById(taolunHuifu.getTaolunId());
        if (taolun == null) {
            return R.error(511, "帖子不存在");
        }
        if (StringUtils.isBlank(taolunHuifu.getHuifuContent())) {
            return R.error(511, "回复内容不能为空");
        }
        fillReplier(taolunHuifu, request);
        Date date = new Date();
        taolunHuifu.setCreateTime(date);
        taolunHuifu.setUpdateTime(date);
        taolunHuifuService.insert(taolunHuifu);
        return R.ok();
    }

    @RequestMapping("/update")
    public R update(@RequestBody TaolunHuifuEntity taolunHuifu, HttpServletRequest request) {
        logger.debug("update方法:,,Controller:{},,taolunHuifu:{}", this.getClass().getName(), taolunHuifu.toString());
        if (taolunHuifu.getId() == null) {
            return R.error(511, "回复不能为空");
        }
        if (StringUtils.isBlank(taolunHuifu.getHuifuContent())) {
            return R.error(511, "回复内容不能为空");
        }
        TaolunHuifuEntity oldHuifu = taolunHuifuService.selectById(taolunHuifu.getId());
        if (oldHuifu == null) {
            return R.error(511, "查不到数据");
        }
        if (!canManage(oldHuifu, request)) {
            return R.error(403, "只能修改自己的回复");
        }
        TaolunHuifuEntity updateHuifu = new TaolunHuifuEntity();
        updateHuifu.setId(oldHuifu.getId());
        updateHuifu.setHuifuContent(taolunHuifu.getHuifuContent());
        updateHuifu.setUpdateTime(new Date());
        taolunHuifuService.updateById(updateHuifu);
        return R.ok();
    }

    @RequestMapping("/delete")
    public R delete(@RequestBody Integer[] ids, HttpServletRequest request) {
        logger.debug("delete:,,Controller:{},,ids:{}", this.getClass().getName(), ids.toString());
        if (ids == null || ids.length == 0) {
            return R.error(511, "回复不能为空");
        }
        Wrapper<TaolunHuifuEntity> queryWrapper = new EntityWrapper<TaolunHuifuEntity>().in("id", Arrays.asList(ids));
        for (TaolunHuifuEntity huifu : taolunHuifuService.selectList(queryWrapper)) {
            if (!canManage(huifu, request)) {
                return R.error(403, "只能删除自己的回复");
            }
        }
        taolunHuifuService.deleteBatchIds(Arrays.asList(ids));
        return R.ok();
    }

    private void fillReplier(TaolunHuifuEntity taolunHuifu, HttpServletRequest request) {
        Integer userId = currentUserId(request);
        String role = String.valueOf(request.getSession().getAttribute("role"));
        String tableName = String.valueOf(request.getSession().getAttribute("tableName"));
        taolunHuifu.setHuifurenId(userId);
        taolunHuifu.setHuifurenRole(role);
        taolunHuifu.setHuifurenTable(tableName);
        taolunHuifu.setHuifurenName(getUserName(tableName, userId));
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

    private boolean canManage(TaolunHuifuEntity taolunHuifu, HttpServletRequest request) {
        String role = String.valueOf(request.getSession().getAttribute("role"));
        if ("管理员".equals(role)) {
            return true;
        }
        return currentUserId(request).equals(taolunHuifu.getHuifurenId()) && role.equals(taolunHuifu.getHuifurenRole());
    }

    private Integer currentUserId(HttpServletRequest request) {
        return Integer.valueOf(String.valueOf(request.getSession().getAttribute("userId")));
    }
}
