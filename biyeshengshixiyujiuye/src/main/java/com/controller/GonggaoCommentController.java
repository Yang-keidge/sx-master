package com.controller;

import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.mapper.Wrapper;
import com.entity.GonggaoCommentEntity;
import com.entity.GonggaoEntity;
import com.entity.LaoshiEntity;
import com.entity.QiyeEntity;
import com.entity.UsersEntity;
import com.entity.XueshengEntity;
import com.service.GonggaoCommentService;
import com.service.GonggaoService;
import com.service.LaoshiService;
import com.service.QiyeService;
import com.service.UsersService;
import com.service.XueshengService;
import com.utils.PageUtils;
import com.utils.R;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
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
 * 公告评论
 */
@RestController
@Controller
@RequestMapping("/gonggaoComment")
public class GonggaoCommentController {
    private static final Logger logger = LoggerFactory.getLogger(GonggaoCommentController.class);

    @Autowired
    private GonggaoCommentService gonggaoCommentService;

    @Autowired
    private GonggaoService gonggaoService;

    @Autowired
    private XueshengService xueshengService;

    @Autowired
    private LaoshiService laoshiService;

    @Autowired
    private QiyeService qiyeService;

    @Autowired
    private UsersService usersService;

    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params, HttpServletRequest request) {
        logger.debug("page方法:,,Controller:{},,params:{}", this.getClass().getName(), JSONObject.toJSONString(params));
        if (params.get("orderBy") == null || params.get("orderBy") == "") {
            params.put("orderBy", "create_time");
        }
        if ("true".equals(String.valueOf(params.get("myOnly")))) {
            params.put("pinglunrenId", request.getSession().getAttribute("userId"));
            params.put("pinglunrenRole", request.getSession().getAttribute("role"));
        }
        PageUtils page = gonggaoCommentService.queryPage(params);
        return R.ok().put("data", page);
    }

    @RequestMapping("/list")
    public R list(@RequestParam Map<String, Object> params) {
        if (params.get("orderBy") == null || params.get("orderBy") == "") {
            params.put("orderBy", "create_time");
        }
        PageUtils page = gonggaoCommentService.queryPage(params);
        return R.ok().put("data", page);
    }

    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id) {
        logger.debug("info方法:,,Controller:{},,id:{}", this.getClass().getName(), id);
        GonggaoCommentEntity gonggaoComment = gonggaoCommentService.selectById(id);
        if (gonggaoComment != null) {
            return R.ok().put("data", gonggaoComment);
        } else {
            return R.error(511, "查不到数据");
        }
    }

    @RequestMapping("/save")
    public R save(@RequestBody GonggaoCommentEntity gonggaoComment, HttpServletRequest request) {
        logger.debug("save方法:,,Controller:{},,gonggaoComment:{}", this.getClass().getName(), gonggaoComment.toString());
        if (gonggaoComment.getGonggaoId() == null) {
            return R.error(511, "公告不能为空");
        }
        GonggaoEntity gonggao = gonggaoService.selectById(gonggaoComment.getGonggaoId());
        if (gonggao == null) {
            return R.error(511, "公告不存在");
        }
        if (StringUtils.isBlank(gonggaoComment.getGonggaoCommentContent())) {
            return R.error(511, "评论内容不能为空");
        }

        fillCommenter(gonggaoComment, request);
        Date date = new Date();
        gonggaoComment.setCreateTime(date);
        gonggaoComment.setUpdateTime(date);
        gonggaoCommentService.insert(gonggaoComment);
        return R.ok();
    }

    @RequestMapping("/update")
    public R update(@RequestBody GonggaoCommentEntity gonggaoComment, HttpServletRequest request) {
        logger.debug("update方法:,,Controller:{},,gonggaoComment:{}", this.getClass().getName(), gonggaoComment.toString());
        if (gonggaoComment.getId() == null) {
            return R.error(511, "评论不能为空");
        }
        if (StringUtils.isBlank(gonggaoComment.getGonggaoCommentContent())) {
            return R.error(511, "评论内容不能为空");
        }

        GonggaoCommentEntity oldComment = gonggaoCommentService.selectById(gonggaoComment.getId());
        if (oldComment == null) {
            return R.error(511, "查不到数据");
        }
        if (!canManage(oldComment, request)) {
            return R.error(403, "只能修改自己的评论");
        }

        GonggaoCommentEntity updateComment = new GonggaoCommentEntity();
        updateComment.setId(oldComment.getId());
        updateComment.setGonggaoCommentContent(gonggaoComment.getGonggaoCommentContent());
        updateComment.setUpdateTime(new Date());
        gonggaoCommentService.updateById(updateComment);
        return R.ok();
    }

    @RequestMapping("/delete")
    public R delete(@RequestBody Integer[] ids, HttpServletRequest request) {
        logger.debug("delete:,,Controller:{},,ids:{}", this.getClass().getName(), ids.toString());
        if (ids == null || ids.length == 0) {
            return R.error(511, "评论不能为空");
        }
        Wrapper<GonggaoCommentEntity> queryWrapper = new EntityWrapper<GonggaoCommentEntity>().in("id", Arrays.asList(ids));
        for (GonggaoCommentEntity comment : gonggaoCommentService.selectList(queryWrapper)) {
            if (!canManage(comment, request)) {
                return R.error(403, "只能删除自己的评论");
            }
        }
        gonggaoCommentService.deleteBatchIds(Arrays.asList(ids));
        return R.ok();
    }

    private void fillCommenter(GonggaoCommentEntity gonggaoComment, HttpServletRequest request) {
        String role = String.valueOf(request.getSession().getAttribute("role"));
        Integer userId = Integer.valueOf(String.valueOf(request.getSession().getAttribute("userId")));
        String tableName = String.valueOf(request.getSession().getAttribute("tableName"));

        gonggaoComment.setPinglunrenId(userId);
        gonggaoComment.setPinglunrenRole(role);
        gonggaoComment.setPinglunrenTable(tableName);
        gonggaoComment.setPinglunrenName(getCommenterName(tableName, userId));
    }

    private String getCommenterName(String tableName, Integer userId) {
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

    private boolean canManage(GonggaoCommentEntity gonggaoComment, HttpServletRequest request) {
        String role = String.valueOf(request.getSession().getAttribute("role"));
        if ("管理员".equals(role)) {
            return true;
        }
        Integer userId = Integer.valueOf(String.valueOf(request.getSession().getAttribute("userId")));
        return userId.equals(gonggaoComment.getPinglunrenId()) && role.equals(gonggaoComment.getPinglunrenRole());
    }
}
