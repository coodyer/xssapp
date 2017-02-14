package com.xss.web.cache;

import java.util.List;

import org.springframework.stereotype.Service;

import com.xss.web.annotation.CacheWipe;
import com.xss.web.annotation.CacheWrite;
import com.xss.web.base.cache.CacheFinal;
import com.xss.web.cache.base.BaseCache;
import com.xss.web.model.Role;

@Service
public class RoleCache extends BaseCache {
	@CacheWrite(key=CacheFinal.ROLE_INFO_KEY ,validTime=65,fields="roleId")
	public Role loadRole(Integer roleId) {
		Role roles = (Role) baseService.get(Role.class, roleId);
		return roles;
	}
	@CacheWipe(key=CacheFinal.ROLE_INFO_KEY,isModel=true)
	@CacheWipe(key=CacheFinal.ROLE_LIST_KEY,isModel=true)
	@CacheWipe(key=CacheFinal.ROLE_MENU_LIST_KEY,isModel=true)
	public void save(Role role) {
		baseService.saveOrUpdate(role);
	}
	@CacheWipe(key=CacheFinal.ROLE_INFO_KEY,isModel=true)
	@CacheWipe(key=CacheFinal.ROLE_LIST_KEY,isModel=true)
	@CacheWipe(key=CacheFinal.ROLE_MENU_LIST_KEY,isModel=true)
	public void del(Integer roleId) {
		baseService.delete(Role.class, roleId);
	}
	@CacheWrite(key=CacheFinal.ROLE_LIST_KEY ,validTime=65)
	public List<Role> loadRoles() {
		List<Role> roles =baseService.load(Role.class);
		return roles;
	}

}
