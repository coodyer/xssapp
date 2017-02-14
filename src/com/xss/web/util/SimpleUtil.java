package com.xss.web.util;

import java.lang.annotation.Annotation;
import java.lang.reflect.AccessibleObject;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javassist.CtClass;
import javassist.CtMethod;
import javassist.Modifier;
import javassist.bytecode.CodeAttribute;
import javassist.bytecode.LocalVariableAttribute;
import javassist.bytecode.MethodInfo;

import com.xss.web.base.cache.CacheFinal;
import com.xss.web.entity.CtAnnotationEntity;
import com.xss.web.entity.CtBeanEntity;
import com.xss.web.entity.CtClassEntity;
import com.xss.web.entity.CtMethodEntity;

public class SimpleUtil {


	public static String getMethodKey(Method method) {
		StringBuilder sb = new StringBuilder();
		Class<?> clazz = PropertUtil.getMethodClass(method);
		sb.append(clazz.getName()).append(".").append(method.getName());
		Class<?>[] paraTypes = method.getParameterTypes();
		sb.append("(");
		if (!StringUtils.isNullOrEmpty(paraTypes)) {
			for (int i = 0; i < paraTypes.length; i++) {
				sb.append(paraTypes[i].getName());
				if (i < paraTypes.length - 1) {
					sb.append(",");
				}
			}
		}
		sb.append(")");
		return CacheFinal.SYSTEM_RUN_INFO + "-" + sb.toString();
	}

	@SuppressWarnings("unchecked")
	public static Method getMethodByKey(String key) {
		String classKey = StringUtils.textCutCenter(key,
				CacheFinal.SYSTEM_RUN_INFO + "-", "(");
		String [] tabs=classKey.split("\\.");
		List<String> list=new ArrayList(Arrays.<String>asList(tabs));
		list.remove(list.size()-1);
		classKey=StringUtils.collectionMosaic(list, ".");
		try {
			Class<?> clazz = Class.forName(classKey);
			List<Method> methods = PropertUtil.loadMethods(clazz);
			for (Method method : methods) {
				if (key.equals(getMethodKey(method))) {
					return method;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;

	}

	public static List<CtAnnotationEntity> getCtAnnotations(
			Annotation[] annotations) {
		List<CtAnnotationEntity> ctAnnotations = new ArrayList<CtAnnotationEntity>();
		for (Annotation annotation : annotations) {
			CtAnnotationEntity ctAnnotation = new CtAnnotationEntity();
			ctAnnotation.setClazz(annotation.getClass());
			ctAnnotation.setAnnotation(annotation);
			try {
				Method[] mes = annotation.annotationType().getDeclaredMethods();
				if (StringUtils.isNullOrEmpty(mes)) {
					continue;
				}
				Map<String, Object> map = new HashMap<String, Object>();
				for (Method me : mes) {
					if (!me.isAccessible()) {
						me.setAccessible(true);
					}
					Object value = me.invoke(annotation, null);
					if (StringUtils.isNullOrEmpty(value)) {
						continue;
					}
					map.put(me.getName(), ReqJsonUtil.objectToJson(value));
				}
				if (StringUtils.isNullOrEmpty(map)) {
					continue;
				}
				ctAnnotation.setFields(map);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				ctAnnotations.add(ctAnnotation);
			}
		}
		return ctAnnotations;
	}

	public static List<CtBeanEntity> getClassFields(Class<?> cla) {
		try {
			List<Field> fields = PropertUtil.loadFields(cla);
			List<CtBeanEntity> infos = new ArrayList<CtBeanEntity>();
			for (Field f : fields) {
				if (f.getName().equalsIgnoreCase("serialVersionUID")) {
					continue;
				}
				CtBeanEntity tmp = new CtBeanEntity();
				tmp.setSourceField(f);
				tmp.setAnnotations(getCtAnnotations(f));
				tmp.setFieldName(f.getName());
				tmp.setFieldType(f.getType());
				tmp.setIsFinal(Modifier.isFinal(f.getModifiers()));
				tmp.setModifier(f.getModifiers());
				tmp.setIsStatic(Modifier.isStatic(f.getModifiers()));
				try {
					if (tmp.getIsStatic()) {
						tmp.setFieldValue(f.get(null));
					}
				} catch (Exception e) {
				}
				infos.add(tmp);
			}
			return infos;
		} catch (Exception e) {

			return null;
		}
	}

	public static List<CtAnnotationEntity> getCtAnnotations(Class<?> clazz) {
		return getCtAnnotations(clazz.getAnnotations());
	}

	public static List<CtAnnotationEntity> getCtAnnotations(
			AccessibleObject accessible) {
		return getCtAnnotations(accessible.getAnnotations());
	}
	public static List<CtBeanEntity> getBeanFields(Object obj) {
		Class<? extends Object> cla = PropertUtil.getObjClass(obj);
		List<CtBeanEntity> infos = getClassFields(cla);
		if (StringUtils.isNullOrEmpty(infos)) {
			return infos;
		}
		if (obj instanceof java.lang.Class) {
			return infos;
		}
		for (CtBeanEntity info : infos) {
			try {
				Field f = info.getSourceField();
				f.setAccessible(true);
				Object value = f.get(obj);
				info.setFieldValue(value);
			} catch (Exception e) {

			}
		}
		return infos;
	}

	public static List<CtBeanEntity> getMethodParas(Method method) {
		try {
			Class<?>[] types = method.getParameterTypes();
			if (StringUtils.isNullOrEmpty(types)) {
				return null;
			}
			Annotation[][] annotations = method.getParameterAnnotations();
			CtMethod cm = PropertUtil.parseCtMethod(method);
			MethodInfo methodInfo = cm.getMethodInfo();
			CodeAttribute codeAttribute = methodInfo.getCodeAttribute();
			LocalVariableAttribute attr = (LocalVariableAttribute) codeAttribute
					.getAttribute(LocalVariableAttribute.tag);
			CtClass[] cts = cm.getParameterTypes();
			if (StringUtils.isNullOrEmpty(cts)) {
				return null;
			}
			List<CtBeanEntity> entitys = new ArrayList<CtBeanEntity>();
			int pos = Modifier.isStatic(cm.getModifiers()) ? 0 : 1;
			for (int i = 0; i < cts.length; i++) {
				CtBeanEntity entity = new CtBeanEntity();
				entity.setFieldName(attr.variableName(i + pos));
				entity.setAnnotations(getCtAnnotations(annotations[i]));
				entity.setFieldType(types[i]);
				entitys.add(entity);
			}
			return entitys;
		} catch (Exception e) {
		}
		return null;
	}
	public static CtClassEntity getClassEntity(Class<?> clazz) {
		CtClassEntity entity = new CtClassEntity();
		entity.setSourceClass(clazz);
		List<CtBeanEntity> fields = getBeanFields(clazz);
		entity.setFields(fields);
		entity.setAnnotations(getCtAnnotations(clazz));
		entity.setName(clazz.getName());
		Method[] methods = clazz.getDeclaredMethods();
		List<CtMethodEntity> ctMethods = new ArrayList<CtMethodEntity>();
		for (Method method : methods) {
			CtMethodEntity ctMethod = new CtMethodEntity();
			if (!StringUtils.isNullOrEmpty(method.getDeclaredAnnotations())) {
				ctMethod.setAnnotations(getCtAnnotations(method));
			}
			ctMethod.setSourceMethod(method);
			ctMethod.setName(method.getName());
			ctMethod.setReturnType(method.getReturnType());
			ctMethod.setParamsType(getMethodParas(method));
			ctMethod.setIsFinal(Modifier.isFinal(method.getModifiers()));
			ctMethod.setModifier(method.getModifiers());
			ctMethod.setIsStatic(Modifier.isStatic(method.getModifiers()));
			ctMethod.setIsAbstract(Modifier.isAbstract(method.getModifiers()));
			ctMethod.setIsSynchronized(Modifier.isSynchronized(method
					.getModifiers()));
			ctMethod.setKey(getMethodKey(method));
			ctMethods.add(ctMethod);
		}
		entity.setMethods(ctMethods);
		entity.setIsAbstract(Modifier.isAbstract(clazz.getModifiers()));
		entity.setIsEnum(Modifier.isEnum(clazz.getModifiers()));
		entity.setIsInterface(Modifier.isInterface(clazz.getModifiers()));
		entity.setModifier(clazz.getModifiers());
		entity.setIsFinal(Modifier.isFinal(clazz.getModifiers()));
		entity.setSuperClass(clazz.getSuperclass());
		entity.setInterfaces(clazz.getInterfaces());
		return entity;
	}
}
