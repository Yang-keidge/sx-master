package com.entity.view;

import com.baomidou.mybatisplus.annotations.TableName;
import com.entity.GonggaoCommentEntity;
import org.apache.commons.beanutils.BeanUtils;

import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;

/**
 * 公告评论返回视图
 */
@TableName("gonggao_comment")
public class GonggaoCommentView extends GonggaoCommentEntity implements Serializable {
    private static final long serialVersionUID = 1L;

    /**
     * 公告标题
     */
    private String gonggaoName;

    public GonggaoCommentView() {
    }

    public GonggaoCommentView(GonggaoCommentEntity gonggaoCommentEntity) {
        try {
            BeanUtils.copyProperties(this, gonggaoCommentEntity);
        } catch (IllegalAccessException | InvocationTargetException e) {
            e.printStackTrace();
        }
    }

    public String getGonggaoName() {
        return gonggaoName;
    }

    public void setGonggaoName(String gonggaoName) {
        this.gonggaoName = gonggaoName;
    }
}
