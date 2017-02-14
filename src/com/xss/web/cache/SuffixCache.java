package com.xss.web.cache;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.xss.web.annotation.CacheWipe;
import com.xss.web.annotation.CacheWrite;
import com.xss.web.base.cache.CacheFinal;
import com.xss.web.cache.base.BaseCache;
import com.xss.web.model.Suffix;
import com.xss.web.service.SuffixService;

@Service
public class SuffixCache extends BaseCache {

	@Resource
	private SuffixService SuffixService;
	@CacheWrite(key=CacheFinal.SITE_SUFFIX_KEY ,validTime=65)
	public List<Suffix> loadSuffix() {
		List<Suffix> list = SuffixService.loadSuffix();// 查询数据库
		return list;
	}
	@CacheWrite(key=CacheFinal.SITE_TMP_SUFFIX_KEY ,validTime=3600,fields="id")
	public Suffix getSuffix(Integer id) {
		Suffix suffix = SuffixService.getSuffix(id);
		return suffix;
	}
	@CacheWipe(key=CacheFinal.SITE_TMP_SUFFIX_KEY)
	@CacheWipe(key=CacheFinal.SITE_SUFFIX_KEY)
	@CacheWipe(key=CacheFinal.SITE_DEF_SUFFIX_KEY)
	public void updateSuffix(Suffix suffix) {
		SuffixService.updateSuffix(suffix);
	}
	@CacheWrite(key=CacheFinal.SITE_AVA_SUFFIX_KEY ,validTime=3600)
	public List<String> loadAvaSuffix() {
		List<String> suffix = SuffixService.loadAvaSuffix();
		return suffix;
	}
	@CacheWrite(key=CacheFinal.SITE_DEF_SUFFIX_KEY ,validTime=3600)
	public String loadDefSuffix() {
		String defSuffix = SuffixService.loadDefSuffix();
		return defSuffix;
	}
	@CacheWrite(key=CacheFinal.SITE_STA_SUFFIX_KEY ,validTime=3600)
	public List<String> loadStaSuffix() {
		List<String> list = SuffixService.loadStaSuffix();
		return list;
	}
	@CacheWipe(key=CacheFinal.SITE_TMP_SUFFIX_KEY)
	@CacheWipe(key=CacheFinal.SITE_SUFFIX_KEY)
	@CacheWipe(key=CacheFinal.SITE_DEF_SUFFIX_KEY)
	public void updateSuffix(Integer[] suffix) {
		SuffixService.updateSuffix(suffix);
	}
}
