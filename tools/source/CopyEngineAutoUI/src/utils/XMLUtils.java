package utils;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

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

	public static void writeXml(String path, Document doc) {
		try {
			XMLWriter output = new XMLWriter(new FileWriter(new File(ProjectConfig.AB_PATH, path)));
			output.write(doc);
			output.close();
		} catch (IOException e) {
			System.out.println(e.getMessage());
		}
	}

}
