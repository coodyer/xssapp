package com.xss.web.entity;

import java.lang.annotation.Annotation;
import java.util.Map;

import com.xss.web.model.base.BaseModel;

@SuppressWarnings("serial")
public class CtAnnotationEntity extends BaseModel{

	
	private Class<?> clazz;
	
	private Map<String,Object> fields;
	
	private Annotation annotation;

	public Annotation getAnnotation() {
		return annotation;
	}

	public void setAnnotation(Annotation annotation) {
		this.annotation = annotation;
	}

	public Class<?> getClazz() {
		return clazz;
	}

	public void setClazz(Class<?> clazz) {
		this.clazz = clazz;
	}

	public Map<String, Object> getFields() {
		return fields;
	}

	public void setFields(Map<String, Object> fields) {
		this.fields = fields;
	}
	
	
}
