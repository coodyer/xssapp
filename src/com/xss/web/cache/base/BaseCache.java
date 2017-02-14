package com.xss.web.cache.base;

import java.util.Set;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.xss.web.annotation.CacheWrite;
import com.xss.web.base.cache.CacheFinal;
import com.xss.web.base.cache.CacheTimerHandler;
import com.xss.web.entity.IpAddressEntity;
import com.xss.web.service.base.BaseService;
import com.xss.web.util.IpAddressUtil;

@Service
public class BaseCache {

	@Resource
	protected BaseService baseService;

	/**
	 * 增加缓存对象
	 * 
	 * @param key
	 * @param ce
	 * @param validityTime
	 *            有效时间
	 */
	public  synchronized void addCache(String key, Object ce,
			int validityTime) {
		try {
			CacheTimerHandler.addCache(key, ce, validityTime);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public  synchronized void addCache(String key, Object ce) {
		try {
			CacheTimerHandler.addCache(key, ce);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 获取缓存对象
	 * 
	 * @param key
	 * @return
	 */
	public  synchronized Object getCache(String key) {
		try {
			return CacheTimerHandler.getCache(key);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

	}
	/**
	 * 获取缓存key列表
	 * 
	 * @param key
	 * @return
	 */
	public   Set<String> getCacheKeys() {
		try {
			return CacheTimerHandler.getCacheKeys();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	/**
	 * 检查是否含有制定key的缓冲
	 * 
	 * @param key
	 * @return
	 */
	public  synchronized boolean contains(String key) {
		try {
			return CacheTimerHandler.contains(key);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}

	}

	/**
	 * 删除缓存
	 * 
	 * @param key
	 */
	public  synchronized void removeCache(String key) {
		try {
			CacheTimerHandler.removeCache(key);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * 删除缓存
	 * 
	 * @param key
	 */
	public  synchronized void removeCacheFuzzy(String key) {
		try {
			CacheTimerHandler.removeCacheFuzzy(key);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@CacheWrite(key=CacheFinal.IP_ADDRESS_INFO ,validTime=600,fields="ip")
	public IpAddressEntity.AddressInfo getIpAddress(String ip) {
		try {
			IpAddressEntity.AddressInfo address=IpAddressUtil.getAddress(ip);
			return address;
		} catch (Exception e) {
			// TODO: handle exception
		}
		return null;
	}

}
