package com.entity.view;

import com.baomidou.mybatisplus.annotations.TableName;
import com.entity.YingpinEntity;

import java.io.Serializable;

/**
 * 应聘学生视图
 */
@TableName("yingpin")
public class YingpinView extends YingpinEntity implements Serializable {
    private static final long serialVersionUID = 1L;

    private String zhaopinGangweiName;
    private String zhaopinLeixing;
    private String xinziFanwei;
    private String gongzuoDizhi;
    private String gongzuoYaoqiu;
    private Integer yizhaoRenshu;
    private Integer zhaopinRenshu;

    private String qiyeName;
    private String qiyeBianhao;
    private String qiyeAddress;
    private String qiyePhone;
    private String qiyeEmail;
    private Integer qiyeTypes;
    private String qiyeValue;

    private String xueshengName;
    private String xueshengXuehao;
    private String xueshengPhone;
    private String xueshengIdNumber;
    private String xueshengPhoto;
    private String xueshengJianliFile;
    private Integer yuanxiTypes;
    private String yuanxiValue;
    private Integer zhuanyeTypes;
    private String zhuanyeValue;
    private Integer banjiTypes;
    private String banjiValue;
    private Integer ruxueYear;
    private String xueshengEmail;

    public String getZhaopinGangweiName() {
        return zhaopinGangweiName;
    }

    public void setZhaopinGangweiName(String zhaopinGangweiName) {
        this.zhaopinGangweiName = zhaopinGangweiName;
    }

    public String getZhaopinLeixing() {
        return zhaopinLeixing;
    }

    public void setZhaopinLeixing(String zhaopinLeixing) {
        this.zhaopinLeixing = zhaopinLeixing;
    }

    public String getXinziFanwei() {
        return xinziFanwei;
    }

    public void setXinziFanwei(String xinziFanwei) {
        this.xinziFanwei = xinziFanwei;
    }

    public String getGongzuoDizhi() {
        return gongzuoDizhi;
    }

    public void setGongzuoDizhi(String gongzuoDizhi) {
        this.gongzuoDizhi = gongzuoDizhi;
    }

    public String getGongzuoYaoqiu() {
        return gongzuoYaoqiu;
    }

    public void setGongzuoYaoqiu(String gongzuoYaoqiu) {
        this.gongzuoYaoqiu = gongzuoYaoqiu;
    }

    public Integer getYizhaoRenshu() {
        return yizhaoRenshu;
    }

    public void setYizhaoRenshu(Integer yizhaoRenshu) {
        this.yizhaoRenshu = yizhaoRenshu;
    }

    public Integer getZhaopinRenshu() {
        return zhaopinRenshu;
    }

    public void setZhaopinRenshu(Integer zhaopinRenshu) {
        this.zhaopinRenshu = zhaopinRenshu;
    }

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

    public String getXueshengIdNumber() {
        return xueshengIdNumber;
    }

    public void setXueshengIdNumber(String xueshengIdNumber) {
        this.xueshengIdNumber = xueshengIdNumber;
    }

    public String getXueshengPhoto() {
        return xueshengPhoto;
    }

    public void setXueshengPhoto(String xueshengPhoto) {
        this.xueshengPhoto = xueshengPhoto;
    }

    public String getXueshengJianliFile() {
        return xueshengJianliFile;
    }

    public void setXueshengJianliFile(String xueshengJianliFile) {
        this.xueshengJianliFile = xueshengJianliFile;
    }

    public Integer getYuanxiTypes() {
        return yuanxiTypes;
    }

    public void setYuanxiTypes(Integer yuanxiTypes) {
        this.yuanxiTypes = yuanxiTypes;
    }

    public String getYuanxiValue() {
        return yuanxiValue;
    }

    public void setYuanxiValue(String yuanxiValue) {
        this.yuanxiValue = yuanxiValue;
    }

    public Integer getZhuanyeTypes() {
        return zhuanyeTypes;
    }

    public void setZhuanyeTypes(Integer zhuanyeTypes) {
        this.zhuanyeTypes = zhuanyeTypes;
    }

    public String getZhuanyeValue() {
        return zhuanyeValue;
    }

    public void setZhuanyeValue(String zhuanyeValue) {
        this.zhuanyeValue = zhuanyeValue;
    }

    public Integer getBanjiTypes() {
        return banjiTypes;
    }

    public void setBanjiTypes(Integer banjiTypes) {
        this.banjiTypes = banjiTypes;
    }

    public String getBanjiValue() {
        return banjiValue;
    }

    public void setBanjiValue(String banjiValue) {
        this.banjiValue = banjiValue;
    }

    public Integer getRuxueYear() {
        return ruxueYear;
    }

    public void setRuxueYear(Integer ruxueYear) {
        this.ruxueYear = ruxueYear;
    }

    public String getXueshengEmail() {
        return xueshengEmail;
    }

    public void setXueshengEmail(String xueshengEmail) {
        this.xueshengEmail = xueshengEmail;
    }
}
