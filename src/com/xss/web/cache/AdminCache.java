package com.xss.web.cache;

import java.net.InetAddress;
import java.net.URI;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.xss.web.annotation.CacheWipe;
import com.xss.web.annotation.CacheWrite;
import com.xss.web.base.cache.CacheFinal;
import com.xss.web.cache.base.BaseCache;
import com.xss.web.model.Admin;
import com.xss.web.service.AdminService;

@Service
public class AdminCache extends BaseCache {

	@Resource
	AdminService adminService;
	@CacheWrite(key=CacheFinal.ADMIN_INFO_KEY ,validTime=60,fields="username")
	public Admin getAdmin(String username) {
		Admin admin = (Admin) baseService.findFirstByField(Admin.class, "userName",
				username);
		return admin;
	}
	@CacheWrite(key=CacheFinal.ADMIN_LIST_KEY ,validTime=60)
	public List<Admin> loadAdmins() {
		List<Admin> admins = baseService.load(Admin.class);
		return admins;
	}
	@CacheWrite(key=CacheFinal.ADMIN_INFO_KEY ,validTime=60)
	public Admin getAdmin(Integer id) {
		Admin admin = (Admin) baseService.get(Admin.class, id);
		return admin;
	}
	@CacheWipe(key=CacheFinal.ADMIN_LIST_KEY)
	@CacheWipe(key=CacheFinal.ADMIN_INFO_KEY,fields="admin.id")
	@CacheWipe(key=CacheFinal.ADMIN_INFO_KEY,fields="admin.userName")
	public void save(Admin admin) {
		adminService.saveOrUpdate(admin);
	}
	@CacheWipe(key=CacheFinal.ADMIN_INFO_KEY,fields="admin.id")
	public void delete(Integer id) {
		adminService.delete(Admin.class, id);
	}
	
	@CacheWrite(key=CacheFinal.SHELL_IP_CACHE ,validTime=60*60*24,fields="url")
	public  String getShellIp(String url){
		try {
			URI uri = new URI(url);
			String domain=uri.getHost();
			InetAddress address = InetAddress.getByName(domain);
			return address.getHostAddress().toString();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
		
	}
}
