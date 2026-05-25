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
 * 应聘学生
 */
@TableName("yingpin")
public class YingpinEntity<T> implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    @TableField(value = "id")
    private Integer id;

    /**
     * 招聘岗位
     */
    @TableField(value = "zhaopin_id")
    private Integer zhaopinId;

    /**
     * 学生
     */
    @TableField(value = "xuesheng_id")
    private Integer xueshengId;

    /**
     * 企业
     */
    @TableField(value = "qiye_id")
    private Integer qiyeId;

    /**
     * 应聘状态
     */
    @TableField(value = "yingpin_status")
    private String yingpinStatus;

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

    public Integer getZhaopinId() {
        return zhaopinId;
    }

    public void setZhaopinId(Integer zhaopinId) {
        this.zhaopinId = zhaopinId;
    }

    public Integer getXueshengId() {
        return xueshengId;
    }

    public void setXueshengId(Integer xueshengId) {
        this.xueshengId = xueshengId;
    }

    public Integer getQiyeId() {
        return qiyeId;
    }

    public void setQiyeId(Integer qiyeId) {
        this.qiyeId = qiyeId;
    }

    public String getYingpinStatus() {
        return yingpinStatus;
    }

    public void setYingpinStatus(String yingpinStatus) {
        this.yingpinStatus = yingpinStatus;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}
