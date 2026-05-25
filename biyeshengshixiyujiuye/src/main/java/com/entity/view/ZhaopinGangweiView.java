package com.entity.view;

import com.baomidou.mybatisplus.annotations.TableName;
import com.entity.ZhaopinGangweiEntity;

import java.io.Serializable;

/**
 * 招聘岗位视图
 */
@TableName("zhaopin_gangwei")
public class ZhaopinGangweiView extends ZhaopinGangweiEntity implements Serializable {
    private static final long serialVersionUID = 1L;

    private String qiyeName;
    private String qiyeBianhao;
    private String qiyeAddress;
    private String qiyePhone;
    private String qiyeEmail;
    private Integer qiyeTypes;
    private String qiyeValue;

    public String getQiyeName() {
        return qiyeName;
    }

    public void setQiyeName(String qiyeName) {
        this.qiyeName = qiyeName;
    }

    public String getQiyeBianhao() {
        return qiyeBianhao;
    }

    public void setQiyeBianhao(String qiyeBianhao) {
        this.qiyeBianhao = qiyeBianhao;
    }

    public String getQiyeAddress() {
        return qiyeAddress;
    }

    public void setQiyeAddress(String qiyeAddress) {
        this.qiyeAddress = qiyeAddress;
    }

    public String getQiyePhone() {
        return qiyePhone;
    }

    public void setQiyePhone(String qiyePhone) {
        this.qiyePhone = qiyePhone;
    }

    public String getQiyeEmail() {
        return qiyeEmail;
    }

    public void setQiyeEmail(String qiyeEmail) {
        this.qiyeEmail = qiyeEmail;
    }

    public Integer getQiyeTypes() {
        return qiyeTypes;
    }

    public void setQiyeTypes(Integer qiyeTypes) {
        this.qiyeTypes = qiyeTypes;
    }

    public String getQiyeValue() {
        return qiyeValue;
    }

    public void setQiyeValue(String qiyeValue) {
        this.qiyeValue = qiyeValue;
    }
}
