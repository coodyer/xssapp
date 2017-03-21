package com.xss.web.aspect;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;
import org.springframework.util.StopWatch;

import com.alibaba.fastjson.JSON;
import com.xss.web.base.cache.CacheTimerHandler;
import com.xss.web.entity.MonitorEntity;
import com.xss.web.util.PropertUtil;
import com.xss.web.util.StringUtils;

@Aspect
@Component
public class SysAspect {
	@SuppressWarnings("unchecked")
	@Around("execution(* com.xss.web..*.*(..)))")
	public Object serviceMonitor(ProceedingJoinPoint pjp) throws Throwable {
		StopWatch sw = new StopWatch(getClass().getSimpleName());
		try {
			// AOP启动监听
			sw.start(pjp.getSignature().toShortString());
			// AOP获取方法执行信息
			Signature signature = pjp.getSignature();
			MethodSignature methodSignature = (MethodSignature) signature;
			Method method = methodSignature.getMethod();
			String key=PropertUtil.getMethodKey(method);
			if(CacheTimerHandler.contains(key)){
				Object[] args = pjp.getArgs();
				Date runTime=new Date();
				Object result =pjp.proceed();
				Date resultTime=new Date();
				try {
					String input=getJson(args);
					String output=getJson(result);
					MonitorEntity entity=new MonitorEntity();
					entity.setInput(input);
					entity.setOutput(output);
					entity.setRunTime(runTime);
					entity.setResultTime(resultTime);
					List<MonitorEntity> entitys=(List<MonitorEntity>) CacheTimerHandler.getCache(key);
					if(StringUtils.isNullOrEmpty(entitys)){
						entitys=new ArrayList<MonitorEntity>();
					}
					entitys.add(entity);
					CacheTimerHandler.addCache(key, entitys);
				} catch (Exception e) {
					e.printStackTrace();
				}
				return result;
			}
			Object result = pjp.proceed();
			return result;
		} finally {
			sw.stop();
		}
	}
	/**
	 * 新版本迭代控制未测试状态方法
	 * 
	 * @param pjp
	 * @return
	 * @throws Throwable
	 */
	@Around("@annotation(com.xss.web.annotation.DeBug)")
	public Object deBugMonitor(ProceedingJoinPoint pjp) throws Throwable {
		StopWatch sw = new StopWatch(getClass().getSimpleName());
		try {
			// AOP启动监听
			sw.start(pjp.getSignature().toShortString());
			try {
				return pjp.proceed();
			} catch (Exception e) {
			    e.printStackTrace();
				return null;
			}
		} finally {
			sw.stop();
		}
	}
	
	private static String getJson(Object...args){
		if(StringUtils.isNullOrEmpty(args)){
			return "";
		}
		List<Object> newArgs=new ArrayList<Object>();
		for(Object arg:args){
			Object tmp=arg;
			if(arg!=null){
				if(ServletRequest.class.isAssignableFrom(arg.getClass())||ServletResponse.class.isAssignableFrom(arg.getClass())){
					tmp=arg.getClass();
				}
			}
			newArgs.add(tmp);
		}
		return JSON.toJSONString(newArgs);
	}
	
	
	public static void main(String[] args) {
		
	}
}
