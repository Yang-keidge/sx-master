
package com.service.impl;


import java.util.Map;

import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.dao.ConfigDao;
import com.entity.ConfigEntity;
import com.service.ConfigService;
import com.utils.PageUtils;
import com.utils.Query;


/**
 * 系统用户
 * @author yangliyuan
 * @date 2019年10月10日 上午9:17:59
 */
@Service("configService")
public class ConfigServiceImpl extends ServiceImpl<ConfigDao, ConfigEntity> implements ConfigService {
	@Override
	public PageUtils queryPage(Map<String, Object> params) {
		EntityWrapper<ConfigEntity> wrapper = new EntityWrapper<ConfigEntity>();
		Object name = params.get("name");
		Object value = params.get("value");
		if (name != null && !"".equals(String.valueOf(name)) && !"null".equals(String.valueOf(name))) {
			wrapper.like("name", String.valueOf(name));
		}
		if (value != null && !"".equals(String.valueOf(value)) && !"null".equals(String.valueOf(value))) {
			wrapper.like("value", String.valueOf(value));
		}
		Page<ConfigEntity> page = this.selectPage(
                new Query<ConfigEntity>(params).getPage(),
                wrapper
        );
        return new PageUtils(page);
	}
}
