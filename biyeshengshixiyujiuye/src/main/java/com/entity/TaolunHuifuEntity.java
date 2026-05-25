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
 * 讨论区回复
 */
@TableName("taolun_huifu")
public class TaolunHuifuEntity<T> implements Serializable {
    private static final long serialVersionUID = 1L;

    public TaolunHuifuEntity() {
    }

    public TaolunHuifuEntity(T t) {
        try {
            BeanUtils.copyProperties(this, t);
        } catch (IllegalAccessException | InvocationTargetException e) {
            e.printStackTrace();
        }
    }

    @TableId(type = IdType.AUTO)
    @TableField(value = "id")
    private Integer id;

    @TableField(value = "taolun_id")
    private Integer taolunId;

    @TableField(value = "huifuren_id")
    private Integer huifurenId;

    @TableField(value = "huifuren_table")
    private String huifurenTable;

    @TableField(value = "huifuren_role")
    private String huifurenRole;

    @TableField(value = "huifuren_name")
    private String huifurenName;

    @TableField(value = "huifu_content")
    private String huifuContent;

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

    public Integer getTaolunId() {
        return taolunId;
    }

    public void setTaolunId(Integer taolunId) {
        this.taolunId = taolunId;
    }

    public Integer getHuifurenId() {
        return huifurenId;
    }

    public void setHuifurenId(Integer huifurenId) {
        this.huifurenId = huifurenId;
    }

    public String getHuifurenTable() {
        return huifurenTable;
    }

    public void setHuifurenTable(String huifurenTable) {
        this.huifurenTable = huifurenTable;
    }

    public String getHuifurenRole() {
        return huifurenRole;
    }

    public void setHuifurenRole(String huifurenRole) {
        this.huifurenRole = huifurenRole;
    }

    public String getHuifurenName() {
        return huifurenName;
    }

    public void setHuifurenName(String huifurenName) {
        this.huifurenName = huifurenName;
    }

    public String getHuifuContent() {
        return huifuContent;
    }

    public void setHuifuContent(String huifuContent) {
        this.huifuContent = huifuContent;
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
        return "TaolunHuifu{" +
                "id=" + id +
                ", taolunId=" + taolunId +
                ", huifurenId=" + huifurenId +
                ", huifurenTable=" + huifurenTable +
                ", huifurenRole=" + huifurenRole +
                ", huifurenName=" + huifurenName +
                ", huifuContent=" + huifuContent +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                "}";
    }
}
