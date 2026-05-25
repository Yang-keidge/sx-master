package com.entity.view;

import com.baomidou.mybatisplus.annotations.TableName;
import com.entity.TaolunEntity;
import org.apache.commons.beanutils.BeanUtils;

import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;

/**
 * 讨论区帖子返回视图
 */
@TableName("taolun")
public class TaolunView extends TaolunEntity implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer replyCount;

    public TaolunView() {
    }

    public TaolunView(TaolunEntity taolunEntity) {
        try {
            BeanUtils.copyProperties(this, taolunEntity);
        } catch (IllegalAccessException | InvocationTargetException e) {
            e.printStackTrace();
        }
    }

    public Integer getReplyCount() {
        return replyCount;
    }

    public void setReplyCount(Integer replyCount) {
        this.replyCount = replyCount;
    }
}
