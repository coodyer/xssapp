package com.xss.web.test;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class ChileTest extends PersionTest{

	public static void main(String[] args) throws IllegalAccessException, IllegalArgumentException, InvocationTargetException {
		PersionTest t=(PersionTest)(new SuperTest());
		t.test1();
	}
	
}
