package com.entity.view;

import com.baomidou.mybatisplus.annotations.TableName;
import com.entity.GonggaoEntity;
import org.apache.commons.beanutils.BeanUtils;

import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;

/**
 * 公告返回视图
 */
@TableName("gonggao")
public class GonggaoView extends GonggaoEntity implements Serializable {
    private static final long serialVersionUID = 1L;

    /**
     * 公告类型的值
     */
    private String gonggaoValue;

    /**
     * 发布者姓名或名称
     */
    private String fabuzheName;

    /**
     * 评论数量
     */
    private Integer commentCount;

    public GonggaoView() {
    }

    public GonggaoView(GonggaoEntity gonggaoEntity) {
        try {
            BeanUtils.copyProperties(this, gonggaoEntity);
        } catch (IllegalAccessException | InvocationTargetException e) {
            e.printStackTrace();
        }
    }

    public String getGonggaoValue() {
        return gonggaoValue;
    }

    public void setGonggaoValue(String gonggaoValue) {
        this.gonggaoValue = gonggaoValue;
    }

    public String getFabuzheName() {
        return fabuzheName;
    }

    public void setFabuzheName(String fabuzheName) {
        this.fabuzheName = fabuzheName;
    }

    public Integer getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(Integer commentCount) {
        this.commentCount = commentCount;
    }
}
