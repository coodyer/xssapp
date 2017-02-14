package com.xss.web.test;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class ChileTest extends PersionTest{

	public static void main(String[] args) throws IllegalAccessException, IllegalArgumentException, InvocationTargetException {
		Method [] methods=SuperTest.class.getDeclaredMethods();
		for(Method method:methods){
			SuperTest test=SuperTest.class.cast(new ChileTest());
			method.setAccessible(true);
			method.invoke(test, null);
		}
	}
	
	
	private void test2(){
		System.out.println("super 2");
	}
}
