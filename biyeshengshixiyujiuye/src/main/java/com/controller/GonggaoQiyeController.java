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
@RequestMapping("/gonggaoQiye")
public class GonggaoQiyeController {
    private static final Logger logger = LoggerFactory.getLogger(GonggaoQiyeController.class);

    @Autowired
    private GonggaoQiyeService gonggaoQiyeService;

    @Autowired
    private TokenService tokenService;
    @Autowired
    private DictionaryService dictionaryService;

    @Autowired
    private QiyeService qiyeService;

    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params, HttpServletRequest request){
        logger.debug("page方法:,,Controller:{},,params:{}",this.getClass().getName(),JSONObject.toJSONString(params));
        String role = String.valueOf(request.getSession().getAttribute("role"));
        if(false)
            return R.error(511,"永不会进入");
        else if("企业".equals(role))
            params.put("qiyeId",request.getSession().getAttribute("userId"));
        if(params.get("orderBy")==null || params.get("orderBy")==""){
            params.put("orderBy","id");
        }
        PageUtils page = gonggaoQiyeService.queryPage(params);

        List<GonggaoQiyeView> list =(List<GonggaoQiyeView>)page.getList();
        for(GonggaoQiyeView c:list){
            dictionaryService.dictionaryConvert(c, request);
        }
        return R.ok().put("data", page);
    }

    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id, HttpServletRequest request){
        logger.debug("info方法:,,Controller:{},,id:{}",this.getClass().getName(),id);
        GonggaoQiyeEntity gonggaoQiye = gonggaoQiyeService.selectById(id);
        if(gonggaoQiye !=null){
            GonggaoQiyeView view = new GonggaoQiyeView();
            BeanUtils.copyProperties( gonggaoQiye , view );

                QiyeEntity qiye = qiyeService.selectById(gonggaoQiye.getQiyeId());
                if(qiye != null){
                    BeanUtils.copyProperties( qiye , view ,new String[]{ "id", "createTime", "insertTime", "updateTime"});
                    view.setQiyeId(qiye.getId());
                }
            dictionaryService.dictionaryConvert(view, request);
            return R.ok().put("data", view);
        }else {
            return R.error(511,"查不到数据");
        }

    }

    @RequestMapping("/save")
    public R save(@RequestBody GonggaoQiyeEntity gonggaoQiye, HttpServletRequest request){
        logger.debug("save方法:,,Controller:{},,gonggaoQiye:{}",this.getClass().getName(),gonggaoQiye.toString());

        String role = String.valueOf(request.getSession().getAttribute("role"));
        if(false)
            return R.error(511,"永远不会进入");
        else if("企业".equals(role))
            gonggaoQiye.setQiyeId(Integer.valueOf(String.valueOf(request.getSession().getAttribute("userId"))));

        Wrapper<GonggaoQiyeEntity> queryWrapper = new EntityWrapper<GonggaoQiyeEntity>()
            .eq("qiye_id", gonggaoQiye.getQiyeId())
            .eq("gonggao_qiye_name", gonggaoQiye.getGonggaoQiyeName())
            ;

        logger.info("sql语句:"+queryWrapper.getSqlSegment());
        GonggaoQiyeEntity gonggaoQiyeEntity = gonggaoQiyeService.selectOne(queryWrapper);
        if(gonggaoQiyeEntity==null){
            gonggaoQiye.setInsertTime(new Date());
            gonggaoQiye.setCreateTime(new Date());
            gonggaoQiyeService.insert(gonggaoQiye);
            return R.ok();
        }else {
            return R.error(511,"表中有相同数据");
        }
    }

    @RequestMapping("/update")
    public R update(@RequestBody GonggaoQiyeEntity gonggaoQiye, HttpServletRequest request){
        logger.debug("update方法:,,Controller:{},,gonggaoQiye:{}",this.getClass().getName(),gonggaoQiye.toString());

        Wrapper<GonggaoQiyeEntity> queryWrapper = new EntityWrapper<GonggaoQiyeEntity>()
            .notIn("id",gonggaoQiye.getId())
            .andNew()
            .eq("qiye_id", gonggaoQiye.getQiyeId())
            .eq("gonggao_qiye_name", gonggaoQiye.getGonggaoQiyeName())
            ;

        logger.info("sql语句:"+queryWrapper.getSqlSegment());
        GonggaoQiyeEntity gonggaoQiyeEntity = gonggaoQiyeService.selectOne(queryWrapper);
        if("".equals(gonggaoQiye.getGonggaoQiyeContent()) || "null".equals(gonggaoQiye.getGonggaoQiyeContent())){
                gonggaoQiye.setGonggaoQiyeContent(null);
        }
        if(gonggaoQiyeEntity==null){
            gonggaoQiyeService.updateById(gonggaoQiye);
            return R.ok();
        }else {
            return R.error(511,"表中有相同数据");
        }
    }

    @RequestMapping("/delete")
    public R delete(@RequestBody Integer[] ids){
        logger.debug("delete:,,Controller:{},,ids:{}",this.getClass().getName(),ids.toString());
        gonggaoQiyeService.deleteBatchIds(Arrays.asList(ids));
        return R.ok();
    }

    @RequestMapping("/batchInsert")
    public R save( String fileName, HttpServletRequest request){
        logger.debug("batchInsert方法:,,Controller:{},,fileName:{}",this.getClass().getName(),fileName);
        try {
            List<GonggaoQiyeEntity> gonggaoQiyeList = new ArrayList<>();
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
                            GonggaoQiyeEntity gonggaoQiyeEntity = new GonggaoQiyeEntity();
                            gonggaoQiyeList.add(gonggaoQiyeEntity);
                        }
                        gonggaoQiyeService.insertBatch(gonggaoQiyeList);
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