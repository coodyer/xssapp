package com.xss.web.cache;

import java.util.List;

import org.springframework.stereotype.Service;

import com.xss.web.annotation.CacheWipe;
import com.xss.web.annotation.CacheWrite;
import com.xss.web.base.cache.CacheFinal;
import com.xss.web.cache.base.BaseCache;
import com.xss.web.model.Email;

@Service
public class EmailCache extends BaseCache {
	@CacheWrite(key=CacheFinal.LETTER_LIST_KEY ,validTime=60)
	public List<Email> loadEmails() {
		List<Email> emails =baseService.load(Email.class);
		return emails;
	}
	@CacheWrite(key=CacheFinal.EMAIL_INFO_KEY ,validTime=60,fields="id")
	public Email getEmail(Integer id) {
		Email email = (Email) baseService.get(Email.class, id);
		return email;
	}
	@CacheWipe(key=CacheFinal.EMAIL_INFO_KEY,fields="email.id")
	@CacheWipe(key=CacheFinal.LETTER_LIST_KEY,isModel=true)
	public void save(Email email) {
		baseService.saveOrUpdate(email);
	}
	@CacheWipe(key=CacheFinal.EMAIL_INFO_KEY,fields="id")
	public void delete(Integer id) {
		baseService.delete(Email.class, id);
	}
}
