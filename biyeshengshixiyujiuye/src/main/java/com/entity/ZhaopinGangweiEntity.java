package com.entity;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.enums.FieldFill;
import com.baomidou.mybatisplus.enums.IdType;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.io.Serializable;
import java.util.Date;

/**
 * 招聘岗位
 */
@TableName("zhaopin_gangwei")
public class ZhaopinGangweiEntity<T> implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    @TableField(value = "id")
    private Integer id;

    /**
     * 企业
     */
    @TableField(value = "qiye_id")
    private Integer qiyeId;

    /**
     * 职位名称
     */
    @TableField(value = "zhaopin_gangwei_name")
    private String zhaopinGangweiName;

    /**
     * 职位类型
     */
    @TableField(value = "zhaopin_leixing")
    private String zhaopinLeixing;

    /**
     * 薪资范围
     */
    @TableField(value = "xinzi_fanwei")
    private String xinziFanwei;

    /**
     * 工作地址
     */
    @TableField(value = "gongzuo_dizhi")
    private String gongzuoDizhi;

    /**
     * 工作要求
     */
    @TableField(value = "gongzuo_yaoqiu")
    private String gongzuoYaoqiu;

    /**
     * 已招人数
     */
    @TableField(value = "yizhao_renshu")
    private Integer yizhaoRenshu;

    /**
     * 招聘人数
     */
    @TableField(value = "zhaopin_renshu")
    private Integer zhaopinRenshu;

    /**
     * 创建时间
     */
    @JsonFormat(locale = "zh", timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private Date createTime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getQiyeId() {
        return qiyeId;
    }

    public void setQiyeId(Integer qiyeId) {
        this.qiyeId = qiyeId;
    }

    public String getZhaopinGangweiName() {
        return zhaopinGangweiName;
    }

    public void setZhaopinGangweiName(String zhaopinGangweiName) {
        this.zhaopinGangweiName = zhaopinGangweiName;
    }

    public String getZhaopinLeixing() {
        return zhaopinLeixing;
    }

    public void setZhaopinLeixing(String zhaopinLeixing) {
        this.zhaopinLeixing = zhaopinLeixing;
    }

    public String getXinziFanwei() {
        return xinziFanwei;
    }

    public void setXinziFanwei(String xinziFanwei) {
        this.xinziFanwei = xinziFanwei;
    }

    public String getGongzuoDizhi() {
        return gongzuoDizhi;
    }

    public void setGongzuoDizhi(String gongzuoDizhi) {
        this.gongzuoDizhi = gongzuoDizhi;
    }

    public String getGongzuoYaoqiu() {
        return gongzuoYaoqiu;
    }

    public void setGongzuoYaoqiu(String gongzuoYaoqiu) {
        this.gongzuoYaoqiu = gongzuoYaoqiu;
    }

    public Integer getYizhaoRenshu() {
        return yizhaoRenshu;
    }

    public void setYizhaoRenshu(Integer yizhaoRenshu) {
        this.yizhaoRenshu = yizhaoRenshu;
    }

    public Integer getZhaopinRenshu() {
        return zhaopinRenshu;
    }

    public void setZhaopinRenshu(Integer zhaopinRenshu) {
        this.zhaopinRenshu = zhaopinRenshu;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}
