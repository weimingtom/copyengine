package utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Properties;
import java.util.Set;

import config.ProjectConfig;



public final class PropertiesUtil {

	@SuppressWarnings("unchecked")
	public static Set getPropertiesAllValue(String path) {
		Properties proper = loadMProperties(path);
		Set<Object> values = new HashSet<Object>(0);
		if (proper != null) {
			for (Iterator iterator = proper.keySet().iterator(); iterator.hasNext();) {
				Object key = (Object) iterator.next();
				values.add(proper.get(key));
			}
		}
		return values;
	}

	public synchronized static Properties loadMProperties(String path) {
		InputStreamReader reader = null;
		Properties proper = new Properties();
		try {
			FileInputStream inputFile = new FileInputStream(new File(ProjectConfig.AB_PATH, path));
			reader = new InputStreamReader(inputFile, "UTF-8");
			proper.load(reader);
			return proper;
		} catch (IOException e) {
			System.out.println(e.toString());
			System.out.println("Failed to load property file :" + path);
		} finally {
			if (reader != null) {
				try {
					reader.close();
				} catch (IOException e) {
					System.out.println("Failed to close property file.");
				}
			}
		}
		return null;
	}
}
