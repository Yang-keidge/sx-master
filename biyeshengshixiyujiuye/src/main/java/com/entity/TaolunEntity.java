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
 * 讨论区帖子
 */
@TableName("taolun")
public class TaolunEntity<T> implements Serializable {
    private static final long serialVersionUID = 1L;

    public TaolunEntity() {
    }

    public TaolunEntity(T t) {
        try {
            BeanUtils.copyProperties(this, t);
        } catch (IllegalAccessException | InvocationTargetException e) {
            e.printStackTrace();
        }
    }

    @TableId(type = IdType.AUTO)
    @TableField(value = "id")
    private Integer id;

    @TableField(value = "fabuzhe_id")
    private Integer fabuzheId;

    @TableField(value = "fabuzhe_table")
    private String fabuzheTable;

    @TableField(value = "fabuzhe_role")
    private String fabuzheRole;

    @TableField(value = "fabuzhe_name")
    private String fabuzheName;

    @TableField(value = "taolun_title")
    private String taolunTitle;

    @TableField(value = "taolun_content")
    private String taolunContent;

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

    public String getFabuzheName() {
        return fabuzheName;
    }

    public void setFabuzheName(String fabuzheName) {
        this.fabuzheName = fabuzheName;
    }

    public String getTaolunTitle() {
        return taolunTitle;
    }

    public void setTaolunTitle(String taolunTitle) {
        this.taolunTitle = taolunTitle;
    }

    public String getTaolunContent() {
        return taolunContent;
    }

    public void setTaolunContent(String taolunContent) {
        this.taolunContent = taolunContent;
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
        return "Taolun{" +
                "id=" + id +
                ", fabuzheId=" + fabuzheId +
                ", fabuzheTable=" + fabuzheTable +
                ", fabuzheRole=" + fabuzheRole +
                ", fabuzheName=" + fabuzheName +
                ", taolunTitle=" + taolunTitle +
                ", taolunContent=" + taolunContent +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                "}";
    }
}
