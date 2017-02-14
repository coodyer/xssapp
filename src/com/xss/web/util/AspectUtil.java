package com.xss.web.util;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.xss.web.base.cache.CacheFinal;
import com.xss.web.entity.BeanEntity;

public class AspectUtil {

	public static ThreadLocal<Map<String, Object>> moduleThread = new ThreadLocal<Map<String, Object>>();


	public static Map<String, Object> getCurrRecord() {
		Map<String, Object> record = moduleThread.get();
		if (StringUtils.isNullOrEmpty(record)) {
			record = new HashMap<String, Object>();
		}
		return record;
	}


	public static String getMethodCacheKey(Method method){
		String key=SimpleUtil.getMethodKey(method);
		key=key.replace(".", "_");
		key=key.replace(",", "_");
		return key;
	}
	public static String getFieldKey(Method method, Object[] paras,
			String key, String[] fields){
		if(StringUtils.isNullOrEmpty(key)){
			key=SimpleUtil.getMethodKey(method);
			key=key.replace(".", "_");
			key=key.replace(",", "_");
		}
		StringBuilder paraKey = new StringBuilder();
		for (String field : fields) {
			Object paraValue = AspectUtil.getMethodPara(method, field, paras);
			if (StringUtils.isNullOrEmpty(paraValue)) {
				paraValue = "";
			}
			paraKey.append("_")
					.append(JSONWriter.write(paraValue));
		}
		key=key+"_"+EncryptionUtil.md5Code(paraKey.toString());
		return key;
	}
	// 将对象内所有字段名、字段值拼接成字符串，用于缓存Key
	public static String getBeanKey(Object... obj) {
		if (StringUtils.isNullOrEmpty(obj)) {
			return "";
		}
		String str = JSONWriter.write(obj);
		return EncryptionUtil.md5Code(str);
	}
	public static Object getMethodPara(Method method, String fieldName,
			Object[] args) {
		List<BeanEntity> beanEntitys = PropertUtil.getMethodParas(method);
		if (StringUtils.isNullOrEmpty(beanEntitys)) {
			return "";
		}
		String[] fields = fieldName.split("\\.");
		BeanEntity entity = (BeanEntity) PropertUtil.getByList(
				beanEntitys, "fieldName", fields[0]);
		if (StringUtils.isNullOrEmpty(entity)) {
			return "";
		}
		Object para = args[beanEntitys.indexOf(entity)];
		if (fields.length > 1 && para != null) {
			for (int i = 1; i < fields.length; i++) {
				para = PropertUtil.getFieldValue(para, fields[i]);
			}
		}
		return para;
	}

}
