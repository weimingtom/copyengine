package factory;

import java.util.Iterator;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import meta.FlaFileMeta;
import analysis.FlaDesignFileAnalyser;
import config.ProjectConfig;

public class AutoUIGenerateFactory {

	@SuppressWarnings("unchecked")
	public void generateXml() {
		Document document = DocumentHelper.createDocument();
		Element rootElement = document.addElement("root");
		
		for (Iterator flaDesignFileMetaIt = ProjectConfig.getInstance().flaDesignFileMetaList.iterator(); flaDesignFileMetaIt.hasNext();) {
			FlaFileMeta meta = (FlaFileMeta) flaDesignFileMetaIt.next();
			FlaDesignFileAnalyser.getInstance().analysisFlaDesignFile(meta ,rootElement);
		}
	}
}
