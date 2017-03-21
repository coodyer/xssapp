package com.xss.web.cache;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.xss.web.annotation.CacheWipe;
import com.xss.web.annotation.CacheWrite;
import com.xss.web.base.cache.CacheFinal;
import com.xss.web.cache.base.BaseCache;
import com.xss.web.entity.Where;
import com.xss.web.model.Suffix;
import com.xss.web.service.SuffixService;
import com.xss.web.util.PropertUtil;
import com.xss.web.util.StringUtils;

@Service
@SuppressWarnings("unchecked")
public class SuffixCache extends BaseCache {

	@Resource
	private SuffixService suffixService;
	@CacheWrite(key=CacheFinal.SITE_SUFFIX_KEY ,validTime=65)
	public List<Suffix> loadSuffix() {
		List<Suffix> list = suffixService.loadSuffix();// 查询数据库
		return list;
	}
	@CacheWrite(key=CacheFinal.SITE_TMP_SUFFIX_KEY ,validTime=3600,fields="id")
	public Suffix getSuffix(Integer id) {
		Suffix suffix = suffixService.getSuffix(id);
		return suffix;
	}
	@CacheWipe(key=CacheFinal.SITE_TMP_SUFFIX_KEY,isModel=true)
	@CacheWipe(key=CacheFinal.SITE_SUFFIX_KEY,isModel=true)
	@CacheWipe(key=CacheFinal.SITE_DEF_SUFFIX_KEY,isModel=true)
	public void updateSuffix(Suffix suffix) {
		suffixService.updateSuffix(suffix);
	}
	@CacheWipe(key=CacheFinal.SITE_TMP_SUFFIX_KEY,isModel=true)
	@CacheWipe(key=CacheFinal.SITE_SUFFIX_KEY,isModel=true)
	@CacheWipe(key=CacheFinal.SITE_DEF_SUFFIX_KEY,isModel=true)
	public void delSuffix(Suffix suffix) {
		suffixService.delete(suffix);
	}
	@CacheWipe(key=CacheFinal.SITE_TMP_SUFFIX_KEY,isModel=true)
	@CacheWipe(key=CacheFinal.SITE_SUFFIX_KEY,isModel=true)
	@CacheWipe(key=CacheFinal.SITE_DEF_SUFFIX_KEY,isModel=true)
	public void addSuffix(Suffix suffix) {
		suffixService.saveOrUpdate(suffix);
	}
	@CacheWrite(key=CacheFinal.SITE_AVA_SUFFIX_KEY ,validTime=3600)
	public List<String> loadAvaSuffix() {
		List<String> suffix = suffixService.loadAvaSuffix();
		return suffix;
	}
	@CacheWrite(key=CacheFinal.SITE_DEF_SUFFIX_KEY ,validTime=3600)
	public String loadDefSuffix() {
		String defSuffix = suffixService.loadDefSuffix();
		return defSuffix;
	}
	@CacheWrite(key=CacheFinal.SITE_STA_SUFFIX_KEY ,validTime=3600)
	public List<String> loadStaSuffix() {
		List<String> list = suffixService.loadStaSuffix();
		return list;
	}
	@CacheWrite(key=CacheFinal.SPRING_SUFFIXS,validTime=3600)
	public List<String> loadSpringSuffixs(){
		//执行语句：select * from suffix where status in (1,2)
		Where where=new Where();
		where.set("status", "in",new Integer[]{1,2});
		List<Suffix> suffixs=(List<Suffix>) suffixService.findByObject(Suffix.class, where);
		if(StringUtils.isNullOrEmpty(suffixs)){
			return new ArrayList<String>();
		}
		return (List<String>) PropertUtil.getFieldValues(suffixs, "suffix");
	}
	@CacheWipe(key=CacheFinal.SITE_TMP_SUFFIX_KEY,isModel=true)
	@CacheWipe(key=CacheFinal.SITE_SUFFIX_KEY,isModel=true)
	@CacheWipe(key=CacheFinal.SITE_DEF_SUFFIX_KEY,isModel=true)
	public void updateSuffix(Integer[] suffix) {
		suffixService.updateSuffix(suffix);
	}
}
