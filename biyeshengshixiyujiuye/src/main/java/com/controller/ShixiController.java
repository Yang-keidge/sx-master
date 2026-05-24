package com.controller;

import java.io.File;
import java.math.BigDecimal;
import java.net.URL;
import java.text.SimpleDateFormat;
import com.alibaba.fastjson.JSONObject;
import java.util.*;
import org.springframework.beans.BeanUtils;
import javax.servlet.http.HttpServletRequest;
import org.springframework.web.context.ContextLoader;
import javax.servlet.ServletContext;
import com.service.TokenService;
import com.utils.*;
import java.lang.reflect.InvocationTargetException;

import com.service.DictionaryService;
import org.apache.commons.lang3.StringUtils;
import com.annotation.IgnoreAuth;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.mapper.Wrapper;
import com.entity.*;
import com.entity.view.*;
import com.service.*;
import com.utils.PageUtils;
import com.utils.R;
import com.alibaba.fastjson.*;

@RestController
@Controller
@RequestMapping("/shixi")
public class ShixiController {
    private static final Logger logger = LoggerFactory.getLogger(ShixiController.class);

    @Autowired
    private ShixiService shixiService;

    @Autowired
    private TokenService tokenService;
    @Autowired
    private DictionaryService dictionaryService;

    @Autowired
    private XueshengService xueshengService;
    @Autowired
    private QiyeService qiyeService;
    @Autowired
    private LaoshiService laoshiService;

    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params, HttpServletRequest request){
        logger.debug("page方法:,,Controller:{},,params:{}",this.getClass().getName(),JSONObject.toJSONString(params));
        String role = String.valueOf(request.getSession().getAttribute("role"));
        if(false)
            return R.error(511,"永不会进入");
        else if("学生".equals(role))
            params.put("xueshengId",request.getSession().getAttribute("userId"));
        else if("老师".equals(role))
            applyTeacherMajorScope(params, request);
        else if("企业".equals(role))
            params.put("qiyeId",request.getSession().getAttribute("userId"));
        if(params.get("orderBy")==null || params.get("orderBy")==""){
            params.put("orderBy","id");
        }
        PageUtils page = shixiService.queryPage(params);

        List<ShixiView> list =(List<ShixiView>)page.getList();
        for(ShixiView c:list){
            dictionaryService.dictionaryConvert(c, request);
        }
        return R.ok().put("data", page);
    }

    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id, HttpServletRequest request){
        logger.debug("info方法:,,Controller:{},,id:{}",this.getClass().getName(),id);
        ShixiEntity shixi = shixiService.selectById(id);
        if(shixi !=null){
            ShixiView view = new ShixiView();
            BeanUtils.copyProperties( shixi , view );

                QiyeEntity qiye = qiyeService.selectById(shixi.getQiyeId());
                if(qiye != null){
                    BeanUtils.copyProperties( qiye , view ,new String[]{ "id", "createTime", "updateTime"});
                    view.setQiyeId(qiye.getId());
                }
                XueshengEntity xuesheng = xueshengService.selectById(shixi.getXueshengId());
                if(xuesheng != null){
                    BeanUtils.copyProperties( xuesheng , view ,new String[]{ "id", "createTime", "updateTime"});
                    view.setXueshengId(xuesheng.getId());
                }
            dictionaryService.dictionaryConvert(view, request);
            return R.ok().put("data", view);
        }else {
            return R.error(511,"查不到数据");
        }

    }

    @RequestMapping("/save")
    public R save(@RequestBody ShixiEntity shixi, HttpServletRequest request){
        logger.debug("save方法:,,Controller:{},,shixi:{}",this.getClass().getName(),shixi.toString());

        String role = String.valueOf(request.getSession().getAttribute("role"));
        if(false)
            return R.error(511,"永远不会进入");
        else if("学生".equals(role))
            shixi.setXueshengId(Integer.valueOf(String.valueOf(request.getSession().getAttribute("userId"))));
        else if("企业".equals(role))
            shixi.setQiyeId(Integer.valueOf(String.valueOf(request.getSession().getAttribute("userId"))));

        Wrapper<ShixiEntity> queryWrapper = new EntityWrapper<ShixiEntity>()
            .eq("xuesheng_id", shixi.getXueshengId())
            .eq("qiye_id", shixi.getQiyeId())
            ;

        logger.info("sql语句:"+queryWrapper.getSqlSegment());
        ShixiEntity shixiEntity = shixiService.selectOne(queryWrapper);
        if(shixiEntity==null){
            shixi.setCreateTime(new Date());
            shixiService.insert(shixi);
            return R.ok();
        }else {
            return R.error(511,"表中有相同数据");
        }
    }

    @RequestMapping("/update")
    public R update(@RequestBody ShixiEntity shixi, HttpServletRequest request){
        logger.debug("update方法:,,Controller:{},,shixi:{}",this.getClass().getName(),shixi.toString());

        Wrapper<ShixiEntity> queryWrapper = new EntityWrapper<ShixiEntity>()
            .notIn("id",shixi.getId())
            .andNew()
            .eq("xuesheng_id", shixi.getXueshengId())
            .eq("qiye_id", shixi.getQiyeId())
            ;

        logger.info("sql语句:"+queryWrapper.getSqlSegment());
        ShixiEntity shixiEntity = shixiService.selectOne(queryWrapper);
        if("".equals(shixi.getShixiContent()) || "null".equals(shixi.getShixiContent())){
                shixi.setShixiContent(null);
        }
        if(shixiEntity==null){
            shixiService.updateById(shixi);
            return R.ok();
        }else {
            return R.error(511,"表中有相同数据");
        }
    }

    @RequestMapping("/delete")
    public R delete(@RequestBody Integer[] ids){
        logger.debug("delete:,,Controller:{},,ids:{}",this.getClass().getName(),ids.toString());
        shixiService.deleteBatchIds(Arrays.asList(ids));
        return R.ok();
    }

    @RequestMapping("/batchInsert")
    public R save( String fileName, HttpServletRequest request){
        logger.debug("batchInsert方法:,,Controller:{},,fileName:{}",this.getClass().getName(),fileName);
        Integer yonghuId = Integer.valueOf(String.valueOf(request.getSession().getAttribute("userId")));
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        try {
            List<ShixiEntity> shixiList = new ArrayList<>();
            Map<String, List<String>> seachFields= new HashMap<>();
            Date date = new Date();
            int lastIndexOf = fileName.lastIndexOf(".");
            if(lastIndexOf == -1){
                return R.error(511,"该文件没有后缀");
            }else{
                String suffix = fileName.substring(lastIndexOf);
                if(!".xls".equals(suffix)){
                    return R.error(511,"只支持后缀为xls的excel文件");
                }else{
                    URL resource = this.getClass().getClassLoader().getResource("static/upload/" + fileName);
                    File file = new File(resource.getFile());
                    if(!file.exists()){
                        return R.error(511,"找不到上传文件，请联系管理员");
                    }else{
                        List<List<String>> dataList = PoiUtil.poiImport(file.getPath());
                        dataList.remove(0);
                        for(List<String> data:dataList){
                            ShixiEntity shixiEntity = new ShixiEntity();
                            shixiList.add(shixiEntity);
                        }
                        shixiService.insertBatch(shixiList);
                        return R.ok();
                    }
                }
            }
        }catch (Exception e){
            e.printStackTrace();
            return R.error(511,"批量插入数据异常，请联系管理员");
        }
    }

    private void applyTeacherMajorScope(Map<String, Object> params, HttpServletRequest request) {
        LaoshiEntity laoshi = laoshiService.selectById((Integer) request.getSession().getAttribute("userId"));
        if (laoshi == null || laoshi.getYuanxiTypes() == null || laoshi.getZhuanyeTypes() == null) {
            params.put("yuanxiTypes", -1);
            params.put("zhuanyeTypes", -1);
            return;
        }
        params.put("yuanxiTypes", laoshi.getYuanxiTypes());
        params.put("zhuanyeTypes", laoshi.getZhuanyeTypes());
    }
}
