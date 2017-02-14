package com.xss.web.cache;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.xss.web.annotation.CacheWipe;
import com.xss.web.base.cache.CacheFinal;
import com.xss.web.cache.base.BaseCache;
import com.xss.web.model.Setting;
import com.xss.web.service.SettingService;

@Service
public class SettingCache extends BaseCache {
	@Resource
	SettingService settingService;
	//@CacheHandle(key=CacheFinal.SETTING_KEY ,validTime=65)
	public Setting loadSetting() {
		Setting setting = (Setting) settingService.loadFirst(Setting.class);
		return setting;
	}
	@CacheWipe(key=CacheFinal.SETTING_KEY)
	public void saveSetting(Setting setting) {
		settingService.saveOrUpdate(setting);
		String key = CacheFinal.SETTING_KEY.toString();
		removeCache(key);
	}
}
