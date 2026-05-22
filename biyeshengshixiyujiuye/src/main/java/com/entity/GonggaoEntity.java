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
 * 公告
 */
@TableName("gonggao")
public class GonggaoEntity<T> implements Serializable {
    private static final long serialVersionUID = 1L;

    public GonggaoEntity() {
    }

    public GonggaoEntity(T t) {
        try {
            BeanUtils.copyProperties(this, t);
        } catch (IllegalAccessException | InvocationTargetException e) {
            e.printStackTrace();
        }
    }

    /**
     * 主键
     */
    @TableId(type = IdType.AUTO)
    @TableField(value = "id")
    private Integer id;

    /**
     * 发布者id
     */
    @TableField(value = "fabuzhe_id")
    private Integer fabuzheId;

    /**
     * 发布者表名
     */
    @TableField(value = "fabuzhe_table")
    private String fabuzheTable;

    /**
     * 发布者身份
     */
    @TableField(value = "fabuzhe_role")
    private String fabuzheRole;

    /**
     * 公告标题
     */
    @TableField(value = "gonggao_name")
    private String gonggaoName;

    /**
     * 公告类型
     */
    @TableField(value = "gonggao_types")
    private Integer gonggaoTypes;

    /**
     * 公告发布日期
     */
    @JsonFormat(locale = "zh", timezone = "GMT+8", pattern = "yyyy-MM-dd")
    @DateTimeFormat
    @TableField(value = "insert_time", fill = FieldFill.INSERT)
    private Date insertTime;

    /**
     * 公告内容
     */
    @TableField(value = "gonggao_content")
    private String gonggaoContent;

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

    public Integer getFabuzheId() {
        return fabuzheId;
    }

    public void setFabuzheId(Integer fabuzheId) {
        this.fabuzheId = fabuzheId;
    }

    public String getFabuzheTable() {
        return fabuzheTable;
    }

    public void setFabuzheTable(String fabuzheTable) {
        this.fabuzheTable = fabuzheTable;
    }

    public String getFabuzheRole() {
        return fabuzheRole;
    }

    public void setFabuzheRole(String fabuzheRole) {
        this.fabuzheRole = fabuzheRole;
    }

    public String getGonggaoName() {
        return gonggaoName;
    }

    public void setGonggaoName(String gonggaoName) {
        this.gonggaoName = gonggaoName;
    }

    public Integer getGonggaoTypes() {
        return gonggaoTypes;
    }

    public void setGonggaoTypes(Integer gonggaoTypes) {
        this.gonggaoTypes = gonggaoTypes;
    }

    public Date getInsertTime() {
        return insertTime;
    }

    public void setInsertTime(Date insertTime) {
        this.insertTime = insertTime;
    }

    public String getGonggaoContent() {
        return gonggaoContent;
    }

    public void setGonggaoContent(String gonggaoContent) {
        this.gonggaoContent = gonggaoContent;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return "Gonggao{" +
                "id=" + id +
                ", fabuzheId=" + fabuzheId +
                ", fabuzheTable=" + fabuzheTable +
                ", fabuzheRole=" + fabuzheRole +
                ", gonggaoName=" + gonggaoName +
                ", gonggaoTypes=" + gonggaoTypes +
                ", insertTime=" + insertTime +
                ", gonggaoContent=" + gonggaoContent +
                ", createTime=" + createTime +
                "}";
    }
}
