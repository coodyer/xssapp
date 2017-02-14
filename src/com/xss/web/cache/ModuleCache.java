package com.xss.web.cache;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.xss.web.annotation.CacheWipe;
import com.xss.web.annotation.CacheWrite;
import com.xss.web.base.cache.CacheFinal;
import com.xss.web.base.page.Pager;
import com.xss.web.cache.base.BaseCache;
import com.xss.web.entity.Where;
import com.xss.web.model.Module;
import com.xss.web.service.ModuleService;

@Service
public class ModuleCache extends BaseCache {
	@Resource
	ModuleService moduleService;
	@CacheWrite(key=CacheFinal.MODULE_PAGER_KEY ,validTime=10)
	public Pager<Module> getPager(Module module, Pager<Module> pager) {
		Pager<Module> pageData = moduleService.findPagerByObject(module,
				pager, "id", true);
		return pageData;
	}
	@CacheWrite(key=CacheFinal.USER_MODULE_LIST_KEY ,validTime=60,fields="userId")
	public List<Module> loadUserModules(Integer userId) {
		List<Module> modules =  moduleService.findByField(Module.class,
				"user.id", userId);
		return modules;
	}
	@CacheWrite(key=CacheFinal.USER_MODULE_INFO_KEY ,validTime=60)
	public Module getModule(Integer id) {
		Module module = (Module) moduleService.get(Module.class, id);
		return module;
	}
	@CacheWipe(key=CacheFinal.USER_MODULE_INFO_KEY)
	@CacheWipe(key=CacheFinal.USER_MODULE_REPLACE_KEY)
	@CacheWipe(key=CacheFinal.USER_MODULE_LIST_KEY)
	@CacheWipe(key=CacheFinal.SYS_MODULE_LIST_KEY)
	@CacheWipe(key=CacheFinal.ALL_MODULE_LIST_KEY)
	@CacheWipe(key=CacheFinal.MODULE_PAGER_KEY)
	public void del(Integer... moduleId) {
		moduleService.cleanModule(moduleId);
		moduleService.deleteModule(moduleId);
	}
	@CacheWipe(key=CacheFinal.USER_MODULE_INFO_KEY)
	@CacheWipe(key=CacheFinal.USER_MODULE_REPLACE_KEY)
	@CacheWipe(key=CacheFinal.USER_MODULE_LIST_KEY)
	@CacheWipe(key=CacheFinal.SYS_MODULE_LIST_KEY)
	@CacheWipe(key=CacheFinal.ALL_MODULE_LIST_KEY)
	@CacheWipe(key=CacheFinal.MODULE_PAGER_KEY)
	public void save(Module module) {
		moduleService.saveOrUpdate(module);
		String key = CacheFinal.USER_MODULE_INFO_KEY.toString();
		removeCacheFuzzy(key);
		key = CacheFinal.USER_MODULE_REPLACE_KEY.toString();
		removeCacheFuzzy(key);
		key = CacheFinal.USER_MODULE_LIST_KEY.toString();
		removeCacheFuzzy(key);
		key = CacheFinal.SYS_MODULE_LIST_KEY.toString();
		removeCacheFuzzy(key);
		key = CacheFinal.ALL_MODULE_LIST_KEY.toString();
		removeCacheFuzzy(key);
		key = CacheFinal.MODULE_PAGER_KEY.toString();
		removeCacheFuzzy(key);
	}
	@CacheWrite(key=CacheFinal.USER_MODULE_REPLACE_KEY ,validTime=65)
	public Module getModuleReplaceCurr(Integer id, Integer userId, String title) {
		Where where = new Where().set("user.id", userId).set("title", title)
				.set("id", "<>", id);
		Module module = (Module) moduleService.findFirstByObject(new Module(), where);
		return module;
	}
	@CacheWrite(key=CacheFinal.SYS_MODULE_LIST_KEY ,validTime=65)
	public List<Module> loadSysModules() {
		List<Module> modules =moduleService.findByField(Module.class,
				"type", 0);
		return modules;
	}
	@CacheWrite(key=CacheFinal.ALL_MODULE_LIST_KEY ,validTime=65)
	public List<Module> loadAllModules() {
		List<Module> modules = moduleService.load(Module.class);
		return modules;
	}
	@CacheWrite(key=CacheFinal.MODULE_COUNT_KEY ,validTime=30)
	public Integer getModuleCount() {
		// 查DB
		Integer count = moduleService.getModuleCount();
		return count;

	}
}
