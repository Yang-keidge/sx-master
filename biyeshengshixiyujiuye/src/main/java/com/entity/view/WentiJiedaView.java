package com.entity.view;

import com.baomidou.mybatisplus.annotations.TableName;
import com.entity.WentiJiedaEntity;
import org.apache.commons.beanutils.BeanUtils;

import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;

/**
 * 问题解答返回视图
 */
@TableName("wenti_jieda")
public class WentiJiedaView extends WentiJiedaEntity implements Serializable {
    private static final long serialVersionUID = 1L;

    private String xueshengName;
    private String xueshengXuehao;
    private String xueshengPhone;
    private String xueshengEmail;
    private Integer yuanxiTypes;
    private Integer zhuanyeTypes;
    private Integer banjiTypes;
    private String yuanxiValue;
    private String zhuanyeValue;
    private String banjiValue;
    private String laoshiName;
    private String huifuLaoshiName;

    public WentiJiedaView() {
    }

    public WentiJiedaView(WentiJiedaEntity wentiJiedaEntity) {
        try {
            BeanUtils.copyProperties(this, wentiJiedaEntity);
        } catch (IllegalAccessException | InvocationTargetException e) {
            e.printStackTrace();
        }
    }

    public String getXueshengName() {
        return xueshengName;
    }

    public void setXueshengName(String xueshengName) {
        this.xueshengName = xueshengName;
    }

    public String getXueshengXuehao() {
        return xueshengXuehao;
    }

    public void setXueshengXuehao(String xueshengXuehao) {
        this.xueshengXuehao = xueshengXuehao;
    }

    public String getXueshengPhone() {
        return xueshengPhone;
    }

    public void setXueshengPhone(String xueshengPhone) {
        this.xueshengPhone = xueshengPhone;
    }

    public String getXueshengEmail() {
        return xueshengEmail;
    }

    public void setXueshengEmail(String xueshengEmail) {
        this.xueshengEmail = xueshengEmail;
    }

    public Integer getYuanxiTypes() {
        return yuanxiTypes;
    }

    public void setYuanxiTypes(Integer yuanxiTypes) {
        this.yuanxiTypes = yuanxiTypes;
    }

    public Integer getZhuanyeTypes() {
        return zhuanyeTypes;
    }

    public void setZhuanyeTypes(Integer zhuanyeTypes) {
        this.zhuanyeTypes = zhuanyeTypes;
    }

    public Integer getBanjiTypes() {
        return banjiTypes;
    }

    public void setBanjiTypes(Integer banjiTypes) {
        this.banjiTypes = banjiTypes;
    }

    public String getYuanxiValue() {
        return yuanxiValue;
    }

    public void setYuanxiValue(String yuanxiValue) {
        this.yuanxiValue = yuanxiValue;
    }

    public String getZhuanyeValue() {
        return zhuanyeValue;
    }

    public void setZhuanyeValue(String zhuanyeValue) {
        this.zhuanyeValue = zhuanyeValue;
    }

    public String getBanjiValue() {
        return banjiValue;
    }

    public void setBanjiValue(String banjiValue) {
        this.banjiValue = banjiValue;
    }

    public String getLaoshiName() {
        return laoshiName;
    }

    public void setLaoshiName(String laoshiName) {
        this.laoshiName = laoshiName;
    }

    public String getHuifuLaoshiName() {
        return huifuLaoshiName;
    }

    public void setHuifuLaoshiName(String huifuLaoshiName) {
        this.huifuLaoshiName = huifuLaoshiName;
    }
}
