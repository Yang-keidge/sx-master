package com.entity;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.enums.FieldFill;
import com.baomidou.mybatisplus.enums.IdType;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.beanutils.BeanUtils;
import org.springframework.format.annotation.DateTimeFormat;

import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;
import java.util.Date;

/**
 * 问题解答
 */
@TableName("wenti_jieda")
public class WentiJiedaEntity<T> implements Serializable {
    private static final long serialVersionUID = 1L;

    public WentiJiedaEntity() {
    }

    public WentiJiedaEntity(T t) {
        try {
            BeanUtils.copyProperties(this, t);
        } catch (IllegalAccessException | InvocationTargetException e) {
            e.printStackTrace();
        }
    }

    @TableId(type = IdType.AUTO)
    @TableField(value = "id")
    private Integer id;

    @TableField(value = "xuesheng_id")
    private Integer xueshengId;

    @TableField(value = "laoshi_id")
    private Integer laoshiId;

    @TableField(value = "wenti_title")
    private String wentiTitle;

    @TableField(value = "wenti_content")
    private String wentiContent;

    @TableField(value = "wenti_status")
    private String wentiStatus;

    @TableField(value = "huifu_content")
    private String huifuContent;

    @TableField(value = "huifu_laoshi_id")
    private Integer huifuLaoshiId;

    @JsonFormat(locale = "zh", timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat
    @TableField(value = "huifu_time")
    private Date huifuTime;

    @JsonFormat(locale = "zh", timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private Date createTime;

    @JsonFormat(locale = "zh", timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat
    @TableField(value = "update_time", fill = FieldFill.UPDATE)
    private Date updateTime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getXueshengId() {
        return xueshengId;
    }

    public void setXueshengId(Integer xueshengId) {
        this.xueshengId = xueshengId;
    }

    public Integer getLaoshiId() {
        return laoshiId;
    }

    public void setLaoshiId(Integer laoshiId) {
        this.laoshiId = laoshiId;
    }

    public String getWentiTitle() {
        return wentiTitle;
    }

    public void setWentiTitle(String wentiTitle) {
        this.wentiTitle = wentiTitle;
    }

    public String getWentiContent() {
        return wentiContent;
    }

    public void setWentiContent(String wentiContent) {
        this.wentiContent = wentiContent;
    }

    public String getWentiStatus() {
        return wentiStatus;
    }

    public void setWentiStatus(String wentiStatus) {
        this.wentiStatus = wentiStatus;
    }

    public String getHuifuContent() {
        return huifuContent;
    }

    public void setHuifuContent(String huifuContent) {
        this.huifuContent = huifuContent;
    }

    public Integer getHuifuLaoshiId() {
        return huifuLaoshiId;
    }

    public void setHuifuLaoshiId(Integer huifuLaoshiId) {
        this.huifuLaoshiId = huifuLaoshiId;
    }

    public Date getHuifuTime() {
        return huifuTime;
    }

    public void setHuifuTime(Date huifuTime) {
        this.huifuTime = huifuTime;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return "WentiJieda{" +
                "id=" + id +
                ", xueshengId=" + xueshengId +
                ", laoshiId=" + laoshiId +
                ", wentiTitle=" + wentiTitle +
                ", wentiContent=" + wentiContent +
                ", wentiStatus=" + wentiStatus +
                ", huifuContent=" + huifuContent +
                ", huifuLaoshiId=" + huifuLaoshiId +
                ", huifuTime=" + huifuTime +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                "}";
    }
}
