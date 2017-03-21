package com.xss.web.util;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

@Component
@SuppressWarnings("unchecked")
public class SpringContextHelper implements ApplicationContextAware {
	
	private static ApplicationContext context;

	@SuppressWarnings("static-access")
	public void setApplicationContext(ApplicationContext context)
			throws BeansException {
		this.context = context;
	}
	
	
	public static <T> T getBean(String beanName){
		return (T) context.getBean(beanName);
	}
	
	public static <T> T getBean(Class<?> clazz){
		return (T) context.getBean(clazz);
	}

}
