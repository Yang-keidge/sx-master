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
@RequestMapping("/qiye")
public class QiyeController {
    private static final Logger logger = LoggerFactory.getLogger(QiyeController.class);

    @Autowired
    private QiyeService qiyeService;

    @Autowired
    private TokenService tokenService;
    @Autowired
    private DictionaryService dictionaryService;

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
        PageUtils page = qiyeService.queryPage(params);

        List<QiyeView> list =(List<QiyeView>)page.getList();
        for(QiyeView c:list){
            dictionaryService.dictionaryConvert(c, request);
        }
        return R.ok().put("data", page);
    }

    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id, HttpServletRequest request){
        logger.debug("info方法:,,Controller:{},,id:{}",this.getClass().getName(),id);
        QiyeEntity qiye = qiyeService.selectById(id);
        if(qiye !=null){
            QiyeView view = new QiyeView();
            BeanUtils.copyProperties( qiye , view );

            dictionaryService.dictionaryConvert(view, request);
            return R.ok().put("data", view);
        }else {
            return R.error(511,"查不到数据");
        }

    }

    @RequestMapping("/save")
    public R save(@RequestBody QiyeEntity qiye, HttpServletRequest request){
        logger.debug("save方法:,,Controller:{},,qiye:{}",this.getClass().getName(),qiye.toString());

        String role = String.valueOf(request.getSession().getAttribute("role"));
        if(false)
            return R.error(511,"永远不会进入");
        if(StringUtils.isBlank(qiye.getQiyeBianhao())){
            qiye.setQiyeBianhao(qiye.getUsername());
        }
        if(StringUtils.isBlank(qiye.getUsername())){
            qiye.setUsername(qiye.getQiyeBianhao());
        }

        Wrapper<QiyeEntity> queryWrapper = new EntityWrapper<QiyeEntity>()
            .eq("username", qiye.getUsername())
            .or()
            .eq("qiye_bianhao", qiye.getQiyeBianhao())
            .or()
            .eq("qiye_phone", qiye.getQiyePhone())
            .or()
            .eq("qiye_email", qiye.getQiyeEmail())
            ;

        logger.info("sql语句:"+queryWrapper.getSqlSegment());
        QiyeEntity qiyeEntity = qiyeService.selectOne(queryWrapper);
        if(qiyeEntity==null){
            qiye.setCreateTime(new Date());
            qiye.setPassword("123456");
            qiyeService.insert(qiye);
            return R.ok();
        }else {
            return R.error(511,"账户或者企业编号或者企业联系方式或者企业邮箱已经被使用");
        }
    }

    @RequestMapping("/update")
    public R update(@RequestBody QiyeEntity qiye, HttpServletRequest request){
        logger.debug("update方法:,,Controller:{},,qiye:{}",this.getClass().getName(),qiye.toString());
        if(StringUtils.isBlank(qiye.getQiyeBianhao())){
            qiye.setQiyeBianhao(qiye.getUsername());
        }
        if(StringUtils.isBlank(qiye.getUsername())){
            qiye.setUsername(qiye.getQiyeBianhao());
        }

        Wrapper<QiyeEntity> queryWrapper = new EntityWrapper<QiyeEntity>()
            .notIn("id",qiye.getId())
            .andNew()
            .eq("username", qiye.getUsername())
            .or()
            .eq("qiye_bianhao", qiye.getQiyeBianhao())
            .or()
            .eq("qiye_phone", qiye.getQiyePhone())
            .or()
            .eq("qiye_email", qiye.getQiyeEmail())
            ;

        logger.info("sql语句:"+queryWrapper.getSqlSegment());
        QiyeEntity qiyeEntity = qiyeService.selectOne(queryWrapper);
        if("".equals(qiye.getQiyePhoto()) || "null".equals(qiye.getQiyePhoto())){
                qiye.setQiyePhoto(null);
        }
        if("".equals(qiye.getQiyeContent()) || "null".equals(qiye.getQiyeContent())){
                qiye.setQiyeContent(null);
        }
        if(qiyeEntity==null){
            qiyeService.updateById(qiye);
            return R.ok();
        }else {
            return R.error(511,"账户或者企业编号或者企业联系方式或者企业邮箱已经被使用");
        }
    }

    @RequestMapping("/delete")
    public R delete(@RequestBody Integer[] ids){
        logger.debug("delete:,,Controller:{},,ids:{}",this.getClass().getName(),ids.toString());
        qiyeService.deleteBatchIds(Arrays.asList(ids));
        return R.ok();
    }

    @RequestMapping("/batchInsert")
    public R save( String fileName, HttpServletRequest request){
        logger.debug("batchInsert方法:,,Controller:{},,fileName:{}",this.getClass().getName(),fileName);
        Integer yonghuId = Integer.valueOf(String.valueOf(request.getSession().getAttribute("userId")));
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        try {
            List<QiyeEntity> qiyeList = new ArrayList<>();
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
                            QiyeEntity qiyeEntity = new QiyeEntity();
                            qiyeList.add(qiyeEntity);

                                if(seachFields.containsKey("username")){
                                    List<String> username = seachFields.get("username");
                                    username.add(data.get(0));
                                }else{
                                    List<String> username = new ArrayList<>();
                                    username.add(data.get(0));
                                    seachFields.put("username",username);
                                }
                                if(seachFields.containsKey("qiyePhone")){
                                    List<String> qiyePhone = seachFields.get("qiyePhone");
                                    qiyePhone.add(data.get(0));
                                }else{
                                    List<String> qiyePhone = new ArrayList<>();
                                    qiyePhone.add(data.get(0));
                                    seachFields.put("qiyePhone",qiyePhone);
                                }
                                if(seachFields.containsKey("qiyeEmail")){
                                    List<String> qiyeEmail = seachFields.get("qiyeEmail");
                                    qiyeEmail.add(data.get(0));
                                }else{
                                    List<String> qiyeEmail = new ArrayList<>();
                                    qiyeEmail.add(data.get(0));
                                    seachFields.put("qiyeEmail",qiyeEmail);
                                }
                        }

                        List<QiyeEntity> qiyeEntities_username = qiyeService.selectList(new EntityWrapper<QiyeEntity>().in("username", seachFields.get("username")));
                        if(qiyeEntities_username.size() >0 ){
                            ArrayList<String> repeatFields = new ArrayList<>();
                            for(QiyeEntity s:qiyeEntities_username){
                                repeatFields.add(s.getUsername());
                            }
                            return R.error(511,"数据库的该表中的 [账户] 字段已经存在 存在数据为:"+repeatFields.toString());
                        }
                        List<QiyeEntity> qiyeEntities_qiyePhone = qiyeService.selectList(new EntityWrapper<QiyeEntity>().in("qiye_phone", seachFields.get("qiyePhone")));
                        if(qiyeEntities_qiyePhone.size() >0 ){
                            ArrayList<String> repeatFields = new ArrayList<>();
                            for(QiyeEntity s:qiyeEntities_qiyePhone){
                                repeatFields.add(s.getQiyePhone());
                            }
                            return R.error(511,"数据库的该表中的 [企业联系方式] 字段已经存在 存在数据为:"+repeatFields.toString());
                        }
                        List<QiyeEntity> qiyeEntities_qiyeEmail = qiyeService.selectList(new EntityWrapper<QiyeEntity>().in("qiye_email", seachFields.get("qiyeEmail")));
                        if(qiyeEntities_qiyeEmail.size() >0 ){
                            ArrayList<String> repeatFields = new ArrayList<>();
                            for(QiyeEntity s:qiyeEntities_qiyeEmail){
                                repeatFields.add(s.getQiyeEmail());
                            }
                            return R.error(511,"数据库的该表中的 [企业邮箱] 字段已经存在 存在数据为:"+repeatFields.toString());
                        }
                        qiyeService.insertBatch(qiyeList);
                        return R.ok();
                    }
                }
            }
        }catch (Exception e){
            e.printStackTrace();
            return R.error(511,"批量插入数据异常，请联系管理员");
        }
    }

    @IgnoreAuth
    @RequestMapping(value = "/login")
    public R login(String username, String password, String captcha, HttpServletRequest request) {
        QiyeEntity qiye = qiyeService.selectOne(new EntityWrapper<QiyeEntity>().eq("username", username));
        if(qiye==null || !qiye.getPassword().equals(password))
            return R.error("账号或密码不正确");
        String token = tokenService.generateToken(qiye.getId(),username, "qiye", "企业");
        R r = R.ok();
        r.put("token", token);
        r.put("role","企业");
        r.put("username",qiye.getQiyeName());
        r.put("tableName","qiye");
        r.put("userId",qiye.getId());
        return r;
    }

    @IgnoreAuth
    @PostMapping(value = "/register")
    public R register(@RequestBody QiyeEntity qiye){
        Wrapper<QiyeEntity> queryWrapper = new EntityWrapper<QiyeEntity>()
            .eq("username", qiye.getUsername())
            .or()
            .eq("qiye_phone", qiye.getQiyePhone())
            .or()
            .eq("qiye_email", qiye.getQiyeEmail())
            ;
        QiyeEntity qiyeEntity = qiyeService.selectOne(queryWrapper);
        if(qiyeEntity != null)
            return R.error("账户或者企业联系方式或者企业邮箱已经被使用");
        qiye.setCreateTime(new Date());
        qiyeService.insert(qiye);
        return R.ok();
    }

    @GetMapping(value = "/resetPassword")
    public R resetPassword(Integer  id){
        QiyeEntity qiye = new QiyeEntity();
        qiye.setPassword("123456");
        qiye.setId(id);
        qiyeService.updateById(qiye);
        return R.ok();
    }

    @IgnoreAuth
    @RequestMapping(value = "/resetPass")
    public R resetPass(String username, HttpServletRequest request) {
        QiyeEntity qiye = qiyeService.selectOne(new EntityWrapper<QiyeEntity>().eq("username", username));
        if(qiye!=null){
            qiye.setPassword("123456");
            boolean b = qiyeService.updateById(qiye);
            if(!b){
               return R.error();
            }
        }else{
           return R.error("账号不存在");
        }
        return R.ok();
    }

    @RequestMapping("/session")
    public R getCurrQiye(HttpServletRequest request){
        Integer id = (Integer)request.getSession().getAttribute("userId");
        QiyeEntity qiye = qiyeService.selectById(id);
        if(qiye !=null){
            QiyeView view = new QiyeView();
            BeanUtils.copyProperties( qiye , view );

            dictionaryService.dictionaryConvert(view, request);
            return R.ok().put("data", view);
        }else {
            return R.error(511,"查不到数据");
        }
    }

    @GetMapping(value = "logout")
    public R logout(HttpServletRequest request) {
        request.getSession().invalidate();
        return R.ok("退出成功");
    }
}
