package config;
import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;

import org.dom4j.Document;
import org.dom4j.Element;

import utils.XMLUtils;

import meta.FlaSourceFileMeta;


public final class ProjectConfig {

	/**
	 * project absolute path , other file path relate to asProject, will use relativepath.
	 * 
	 *  WARNINIG::
	 *  					when release this project make sure CONFIG_DOCUMENT_LOACTION is the same folder to the jar file.
	 */
	private static String CONFIG_DOCUMENT_LOACTION = "CopyEngineAutoUI-Config.xml";
	public static String AB_PATH = new File(CONFIG_DOCUMENT_LOACTION).getAbsoluteFile().getParent();

	private static ProjectConfig instance;

	public static ProjectConfig getInstance() {
		if (instance == null) {
			instance = new ProjectConfig();
		}
		return instance;
	}

	public ArrayList<FlaSourceFileMeta> flaSourceFileMetaList = new ArrayList<FlaSourceFileMeta>(0);

	public ProjectConfig() {
		init();
	}

	@SuppressWarnings("unchecked")
	private void init() {
		Document confilgFile = XMLUtils.readXml(CONFIG_DOCUMENT_LOACTION);
		Element root = confilgFile.getRootElement();
		for (Iterator flaSourceFileIt = root.element("flaSourceFile").elements("file").iterator(); flaSourceFileIt.hasNext();) {
			Element flaSourceFileElement = (Element) flaSourceFileIt.next();

			FlaSourceFileMeta file = new FlaSourceFileMeta();
			file.fileName = flaSourceFileElement.attributeValue("name");
			file.filePath = flaSourceFileElement.attributeValue("path");
			flaSourceFileMetaList.add(file);
		}
	}

}
