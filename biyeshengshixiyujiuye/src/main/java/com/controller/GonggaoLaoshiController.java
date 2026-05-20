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
@RequestMapping("/gonggaoLaoshi")
public class GonggaoLaoshiController {
    private static final Logger logger = LoggerFactory.getLogger(GonggaoLaoshiController.class);

    @Autowired
    private GonggaoLaoshiService gonggaoLaoshiService;

    @Autowired
    private TokenService tokenService;
    @Autowired
    private DictionaryService dictionaryService;

    @Autowired
    private LaoshiService laoshiService;

    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params, HttpServletRequest request){
        logger.debug("page方法:,,Controller:{},,params:{}",this.getClass().getName(),JSONObject.toJSONString(params));
        String role = String.valueOf(request.getSession().getAttribute("role"));
        if(false)
            return R.error(511,"永不会进入");
        else if("老师".equals(role))
            params.put("laoshiId",request.getSession().getAttribute("userId"));
        if(params.get("orderBy")==null || params.get("orderBy")==""){
            params.put("orderBy","id");
        }
        PageUtils page = gonggaoLaoshiService.queryPage(params);

        List<GonggaoLaoshiView> list =(List<GonggaoLaoshiView>)page.getList();
        for(GonggaoLaoshiView c:list){
            dictionaryService.dictionaryConvert(c, request);
        }
        return R.ok().put("data", page);
    }

    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id, HttpServletRequest request){
        logger.debug("info方法:,,Controller:{},,id:{}",this.getClass().getName(),id);
        GonggaoLaoshiEntity gonggaoLaoshi = gonggaoLaoshiService.selectById(id);
        if(gonggaoLaoshi !=null){
            GonggaoLaoshiView view = new GonggaoLaoshiView();
            BeanUtils.copyProperties( gonggaoLaoshi , view );

                LaoshiEntity laoshi = laoshiService.selectById(gonggaoLaoshi.getLaoshiId());
                if(laoshi != null){
                    BeanUtils.copyProperties( laoshi , view ,new String[]{ "id", "createTime", "insertTime", "updateTime"});
                    view.setLaoshiId(laoshi.getId());
                }
            dictionaryService.dictionaryConvert(view, request);
            return R.ok().put("data", view);
        }else {
            return R.error(511,"查不到数据");
        }

    }

    @RequestMapping("/save")
    public R save(@RequestBody GonggaoLaoshiEntity gonggaoLaoshi, HttpServletRequest request){
        logger.debug("save方法:,,Controller:{},,gonggaoLaoshi:{}",this.getClass().getName(),gonggaoLaoshi.toString());

        String role = String.valueOf(request.getSession().getAttribute("role"));
        if(false)
            return R.error(511,"永远不会进入");
        else if("老师".equals(role))
            gonggaoLaoshi.setLaoshiId(Integer.valueOf(String.valueOf(request.getSession().getAttribute("userId"))));

        Wrapper<GonggaoLaoshiEntity> queryWrapper = new EntityWrapper<GonggaoLaoshiEntity>()
            .eq("laoshi_id", gonggaoLaoshi.getLaoshiId())
            .eq("gonggao_laoshi_name", gonggaoLaoshi.getGonggaoLaoshiName())
            ;

        logger.info("sql语句:"+queryWrapper.getSqlSegment());
        GonggaoLaoshiEntity gonggaoLaoshiEntity = gonggaoLaoshiService.selectOne(queryWrapper);
        if(gonggaoLaoshiEntity==null){
            gonggaoLaoshi.setInsertTime(new Date());
            gonggaoLaoshi.setCreateTime(new Date());
            gonggaoLaoshiService.insert(gonggaoLaoshi);
            return R.ok();
        }else {
            return R.error(511,"表中有相同数据");
        }
    }

    @RequestMapping("/update")
    public R update(@RequestBody GonggaoLaoshiEntity gonggaoLaoshi, HttpServletRequest request){
        logger.debug("update方法:,,Controller:{},,gonggaoLaoshi:{}",this.getClass().getName(),gonggaoLaoshi.toString());

        Wrapper<GonggaoLaoshiEntity> queryWrapper = new EntityWrapper<GonggaoLaoshiEntity>()
            .notIn("id",gonggaoLaoshi.getId())
            .andNew()
            .eq("laoshi_id", gonggaoLaoshi.getLaoshiId())
            .eq("gonggao_laoshi_name", gonggaoLaoshi.getGonggaoLaoshiName())
            ;

        logger.info("sql语句:"+queryWrapper.getSqlSegment());
        GonggaoLaoshiEntity gonggaoLaoshiEntity = gonggaoLaoshiService.selectOne(queryWrapper);
        if("".equals(gonggaoLaoshi.getGonggaoLaoshiContent()) || "null".equals(gonggaoLaoshi.getGonggaoLaoshiContent())){
                gonggaoLaoshi.setGonggaoLaoshiContent(null);
        }
        if(gonggaoLaoshiEntity==null){
            gonggaoLaoshiService.updateById(gonggaoLaoshi);
            return R.ok();
        }else {
            return R.error(511,"表中有相同数据");
        }
    }

    @RequestMapping("/delete")
    public R delete(@RequestBody Integer[] ids){
        logger.debug("delete:,,Controller:{},,ids:{}",this.getClass().getName(),ids.toString());
        gonggaoLaoshiService.deleteBatchIds(Arrays.asList(ids));
        return R.ok();
    }

    @RequestMapping("/batchInsert")
    public R save( String fileName, HttpServletRequest request){
        logger.debug("batchInsert方法:,,Controller:{},,fileName:{}",this.getClass().getName(),fileName);
        try {
            List<GonggaoLaoshiEntity> gonggaoLaoshiList = new ArrayList<>();
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
                            GonggaoLaoshiEntity gonggaoLaoshiEntity = new GonggaoLaoshiEntity();
                            gonggaoLaoshiList.add(gonggaoLaoshiEntity);
                        }
                        gonggaoLaoshiService.insertBatch(gonggaoLaoshiList);
                        return R.ok();
                    }
                }
            }
        }catch (Exception e){
            e.printStackTrace();
            return R.error(511,"批量插入数据异常，请联系管理员");
        }
    }
}