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
import com.xss.web.model.Letter;
import com.xss.web.model.LetterParas;
import com.xss.web.model.Project;
import com.xss.web.service.LetterService;

@Service
public class LetterCache extends BaseCache {
	@Resource
	LetterService letterService;
	@CacheWipe(key=CacheFinal.LETTER_PAGER_KEY)
	@CacheWipe(key=CacheFinal.LETTER_PARAS_KEY)
	@CacheWipe(key=CacheFinal.LETTER_INFO_KEY)
	@CacheWipe(key=CacheFinal.LETTER_CONTEXT_KEY)
	@CacheWipe(key=CacheFinal.LETTER_COUNT_KEY)
	@CacheWipe(key=CacheFinal.USER_PROJECT_LETER_COUNT_KEY)
	public void save(Letter letter) {
		letterService.saveOrUpdate(letter);
	}
	@CacheWrite(key=CacheFinal.LETTER_PARAS_KEY ,validTime=60)
	public List<LetterParas> getLetterParas(Integer letterId) {
		List<LetterParas> paras = letterService.findByField(
				LetterParas.class, "paraName", false, "letter.id", letterId);
		return paras;

	}
	@CacheWrite(key=CacheFinal.LETTER_CONTEXT_KEY ,validTime=60,fields="context")
	public Letter findLetter(String context) {
		Letter letter = (Letter) letterService.findFirstByField(Letter.class,
				"context", context);
		return letter;
	}
	@CacheWrite(key=CacheFinal.LETTER_INFO_KEY ,validTime=60,fields="id")
	public Letter getLetter(Integer id) {
		Letter letter = (Letter) letterService.get(Letter.class, id);
		return letter;
	}
	@CacheWrite(key=CacheFinal.LETTER_COUNT_KEY ,validTime=30)
	public Integer getLetterCount() {
		// 查DB
		Integer count = letterService.getLetterCount();
		return count;

	}
	@CacheWrite(key=CacheFinal.LETTER_INFO_KEY ,validTime=3)
	public List<Letter> getLetter(Integer userId, Integer... id) {
		Where where = new Where();
		where.set("project.user.id", userId);
		where.set("id", "in", id);
		List<Letter> letters = (List<Letter>) letterService
				.findByObject(Letter.class, where);
		return letters;
	}
	@CacheWipe(key=CacheFinal.LETTER_PAGER_KEY)
	@CacheWipe(key=CacheFinal.LETTER_PARAS_KEY)
	@CacheWipe(key=CacheFinal.LETTER_INFO_KEY)
	@CacheWipe(key=CacheFinal.LETTER_CONTEXT_KEY)
	@CacheWipe(key=CacheFinal.LETTER_COUNT_KEY)
	@CacheWipe(key=CacheFinal.USER_PROJECT_LETER_COUNT_KEY)
	@CacheWipe(key=CacheFinal.PAGER_COUNT_CACHE)
	public void delLetter(Integer... letteryId) {
		letterService.delLetterById(letteryId);
		String key = CacheFinal.LETTER_LIST_KEY.toString();
		removeCacheFuzzy(key);
		key = CacheFinal.LETTER_PARAS_KEY.toString();
		removeCacheFuzzy(key);
		key = CacheFinal.LETTER_INFO_KEY.toString();
		removeCacheFuzzy(key);
		key = CacheFinal.LETTER_CONTEXT_KEY.toString();
		removeCacheFuzzy(key);
		key = CacheFinal.LETTER_COUNT_KEY.toString();
		removeCacheFuzzy(key);
		key = CacheFinal.USER_PROJECT_LETER_COUNT_KEY.toString();
		removeCacheFuzzy(key);

	}
	@CacheWrite(key=CacheFinal.LETTER_INFO_KEY ,validTime=60,fields="uuid")
	public Letter getLetter(String uuid) {
		Letter letter = (Letter) letterService.findFirstByField(Letter.class, "uuid",
				uuid);
		return letter;
	}
	@CacheWrite(key=CacheFinal.LETTER_LIST_KEY)
	public Pager<Letter> getLetters(Letter letter, Pager<Letter> pager) {
		Pager<Letter> letters = letterService.findPagerByObject(letter,
				pager, "id", true);
		return letters;
	}
	public void batchSaveLeter(List<LetterParas> leters, Project project) {
		letterService.batchSave(leters);
	}
}
