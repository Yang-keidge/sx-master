package com.entity.view;

import com.baomidou.mybatisplus.annotations.TableName;
import com.entity.TaolunHuifuEntity;
import org.apache.commons.beanutils.BeanUtils;

import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;

/**
 * 讨论区回复返回视图
 */
@TableName("taolun_huifu")
public class TaolunHuifuView extends TaolunHuifuEntity implements Serializable {
    private static final long serialVersionUID = 1L;

    private String taolunTitle;

    public TaolunHuifuView() {
    }

    public TaolunHuifuView(TaolunHuifuEntity taolunHuifuEntity) {
        try {
            BeanUtils.copyProperties(this, taolunHuifuEntity);
        } catch (IllegalAccessException | InvocationTargetException e) {
            e.printStackTrace();
        }
    }

    public String getTaolunTitle() {
        return taolunTitle;
    }

    public void setTaolunTitle(String taolunTitle) {
        this.taolunTitle = taolunTitle;
    }
}
