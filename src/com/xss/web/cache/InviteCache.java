package com.xss.web.cache;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.xss.web.annotation.CacheWipe;
import com.xss.web.annotation.CacheWrite;
import com.xss.web.base.cache.CacheFinal;
import com.xss.web.base.page.Pager;
import com.xss.web.cache.base.BaseCache;
import com.xss.web.model.Invite;
import com.xss.web.service.InviteService;
import com.xss.web.util.JUUIDUtil;

@Service
public class InviteCache extends BaseCache {
	@Resource
	InviteService inviteService;
	@CacheWrite(key=CacheFinal.INVITE_INFO_KEY ,validTime=10,fields="code")
	public Invite getInvite(String code) {
		Invite invite = (Invite) baseService.findFirstByField(Invite.class,
				"inviteCode", code);
		return invite;
	}
	@CacheWrite(key=CacheFinal.INVITE_LIST_KEY)
	public Pager<Invite> getPager(Invite invite, Pager<Invite> pager) {
		Pager<Invite> invites = baseService.findPagerByObject(invite, pager,
				"id", true);
		return invites;
	}
	@CacheWipe(key=CacheFinal.INVITE_LIST_KEY)
	public void importInvite(Integer num) {
		List<Invite> invites = new ArrayList<Invite>();
		Invite invite = null;
		for (int i = 0; i < num; i++) {
			invite = new Invite();
			invite.setInviteCode(JUUIDUtil.createUuid());
			invite.setStatus(1);
			invite.setUpdateTime(new Date());
			invites.add(invite);
		}
		baseService.batchSave(invites);
	}
	@CacheWipe(key=CacheFinal.INVITE_INFO_KEY)
	@CacheWipe(key=CacheFinal.INVITE_LIST_KEY)
	public void delete(Integer... id) {
		inviteService.delete(id);
	}
	@CacheWipe(key=CacheFinal.INVITE_INFO_KEY,fields="invite.id")
	public void save(Invite invite) {
		baseService.saveOrUpdate(invite);
	}
}
