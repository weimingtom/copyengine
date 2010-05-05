package utils;

import java.io.File;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.io.SAXReader;

import config.ProjectConfig;





public final class XMLUtils {

	public static Document readXml(String path) {
		SAXReader saxReader = new SAXReader();
		Document doc = null;
		try {
			doc = saxReader.read(new File(ProjectConfig.AB_PATH, path));
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		return doc;
	}
	
}
