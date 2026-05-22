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
 * 公告评论
 */
@TableName("gonggao_comment")
public class GonggaoCommentEntity<T> implements Serializable {
    private static final long serialVersionUID = 1L;

    public GonggaoCommentEntity() {
    }

    public GonggaoCommentEntity(T t) {
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
     * 公告
     */
    @TableField(value = "gonggao_id")
    private Integer gonggaoId;

    /**
     * 评论人
     */
    @TableField(value = "pinglunren_id")
    private Integer pinglunrenId;

    /**
     * 评论人表名
     */
    @TableField(value = "pinglunren_table")
    private String pinglunrenTable;

    /**
     * 评论人身份
     */
    @TableField(value = "pinglunren_role")
    private String pinglunrenRole;

    /**
     * 评论人名称
     */
    @TableField(value = "pinglunren_name")
    private String pinglunrenName;

    /**
     * 评论内容
     */
    @TableField(value = "gonggao_comment_content")
    private String gonggaoCommentContent;

    /**
     * 创建时间
     */
    @JsonFormat(locale = "zh", timezone = "GMT+8", pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private Date createTime;

    /**
     * 更新时间
     */
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

    public Integer getGonggaoId() {
        return gonggaoId;
    }

    public void setGonggaoId(Integer gonggaoId) {
        this.gonggaoId = gonggaoId;
    }

    public Integer getPinglunrenId() {
        return pinglunrenId;
    }

    public void setPinglunrenId(Integer pinglunrenId) {
        this.pinglunrenId = pinglunrenId;
    }

    public String getPinglunrenTable() {
        return pinglunrenTable;
    }

    public void setPinglunrenTable(String pinglunrenTable) {
        this.pinglunrenTable = pinglunrenTable;
    }

    public String getPinglunrenRole() {
        return pinglunrenRole;
    }

    public void setPinglunrenRole(String pinglunrenRole) {
        this.pinglunrenRole = pinglunrenRole;
    }

    public String getPinglunrenName() {
        return pinglunrenName;
    }

    public void setPinglunrenName(String pinglunrenName) {
        this.pinglunrenName = pinglunrenName;
    }

    public String getGonggaoCommentContent() {
        return gonggaoCommentContent;
    }

    public void setGonggaoCommentContent(String gonggaoCommentContent) {
        this.gonggaoCommentContent = gonggaoCommentContent;
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
        return "GonggaoComment{" +
                "id=" + id +
                ", gonggaoId=" + gonggaoId +
                ", pinglunrenId=" + pinglunrenId +
                ", pinglunrenTable=" + pinglunrenTable +
                ", pinglunrenRole=" + pinglunrenRole +
                ", pinglunrenName=" + pinglunrenName +
                ", gonggaoCommentContent=" + gonggaoCommentContent +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                "}";
    }
}
