package com.xss.web.aspect;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Method;
import java.net.URLDecoder;

import javax.annotation.Resource;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;
import org.springframework.util.StopWatch;

import com.xss.web.annotation.CacheWipe;
import com.xss.web.annotation.CacheWrite;
import com.xss.web.base.cache.CacheTimerHandler;
import com.xss.web.cache.base.BaseCache;
import com.xss.web.util.AspectUtil;
import com.xss.web.util.ConcurrentUtil;
import com.xss.web.util.PropertUtil;
import com.xss.web.util.SpringContextHelper;
import com.xss.web.util.StringUtils;

/**
 * AOP缓存
 * @author Administrator
 *
 */
@Aspect
@Component
public class CacheAspect {


	@Resource
	private BaseCache baseCache;

	@Around("execution(* com.xss.web..*.*(..)) && @annotation(com.xss.web.annotation.CacheWrite)")
	public Object cCacheWrite(ProceedingJoinPoint pjp) throws Throwable {
		StopWatch sw = new StopWatch(getClass().getSimpleName());
		try {
			// AOP启动监听
			sw.start(pjp.getSignature().toShortString());
			// AOP获取方法执行信息
			Signature signature = pjp.getSignature();
			MethodSignature methodSignature = (MethodSignature) signature;
			Method method = methodSignature.getMethod();
			if (method == null) {
				return pjp.proceed();
			}
			// 获取注解
			CacheWrite handle = method.getAnnotation(CacheWrite.class);
			if (handle == null) {
				return pjp.proceed();
			}
			// 封装缓存KEY
			Object[] args = pjp.getArgs();
			String key = handle.key();
			try {
				if (StringUtils.isNullOrEmpty(key)) {
					key = AspectUtil.getMethodCacheKey(method);
				}
				if (StringUtils.isNullOrEmpty(handle.fields())) {
					key += "_";
					key += AspectUtil.getBeanKey(args);
				}
				if (!StringUtils.isNullOrEmpty(handle.fields())) {
					key = AspectUtil.getFieldKey(method, args, key,
							handle.fields());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			Integer cacheTimer = ((handle.validTime() == 0) ? 24 * 3600
					: handle.validTime());
			// 获取缓存
			try {
				Object result = CacheTimerHandler.getCache(key);
				if (!StringUtils.isNullOrEmpty(result)) {
					return result;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			Object result = pjp.proceed();
			if (result != null) {
				try {
					CacheTimerHandler.addCache(key, result, cacheTimer);
				} catch (Exception e) {
				}
			}
			return result;
		} finally {
			sw.stop();
		}
	}

	/**
	 * 缓存清理
	 * 
	 * @param pjp
	 * @return
	 * @throws Throwable
	 */
	@Around("execution(* com.xss.web..*.*(..)) && (@annotation(com.xss.web.annotation.CacheWipe)||@annotation(com.xss.web.annotation.CacheWipes))")
	public Object zCacheWipe(ProceedingJoinPoint pjp) throws Throwable {
		StopWatch sw = new StopWatch(getClass().getSimpleName());
		try {
			// 启动监听
			sw.start(pjp.getSignature().toShortString());
			Signature signature = pjp.getSignature();
			MethodSignature methodSignature = (MethodSignature) signature;
			Method method = methodSignature.getMethod();
			if (method == null) {
				return pjp.proceed();
			}
			Object[] paras = pjp.getArgs();
			Object result = pjp.proceed();
			CacheWipe[] handles = method.getAnnotationsByType(CacheWipe.class);
			if (StringUtils.isNullOrEmpty(handles)) {
				return result;
			}
			for (CacheWipe wipe : handles) {
				try {
					String key=wipe.key();
					if (StringUtils.isNullOrEmpty(wipe.key())) {
						key = (AspectUtil.getMethodCacheKey(method));
					}
						String cacheKey = AspectUtil.getFieldKey(method, paras,
								key, wipe.fields());
						CacheTimerHandler.removeCache(cacheKey);
				} catch (Exception e) {
				}
			}
			return result;
		} finally {
			sw.stop();
		}
	}
	
	public static void main(String[] args) throws UnsupportedEncodingException {
		System.out.println(URLDecoder.decode("jobarea%7E%60000000%7C%21ord_field%7E%600%7C%21recentSearch0%7E%601%A1%FB%A1%FA000000%2C00%A1%FB%A1%FA000000%A1%FB%A1%FA0000%A1%FB%A1%FA00%A1%FB%A1%FA9%A1%FB%A1%FA99%A1%FB%A1%FA99%A1%FB%A1%FA99%A1%FB%A1%FA99%A1%FB%A1%FA99%A1%FB%A1%FA99%A1%FB%A1%FA%B5%E7%C9%CC%A1%FB%A1%FA2%A1%FB%A1%FA%A1%FB%A1%FA-1%A1%FB%A1%FA1474782052%A1%FB%A1%FA0%A1%FB%A1%FA%A1%FB%A1%FA%7C%21","GBK"));
	}
}
