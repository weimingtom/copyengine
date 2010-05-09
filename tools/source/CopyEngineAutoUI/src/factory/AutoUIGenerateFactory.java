package factory;

import java.util.Iterator;
import java.util.StringTokenizer;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import assembly.AssemblyManger;
import assembly.BasicAssembly;

import utils.XMLUtils;

import meta.FlaFileMeta;
import config.ProjectConfig;

public class AutoUIGenerateFactory {

	@SuppressWarnings("unchecked")
	public void generateXml() {
		Document document = DocumentHelper.createDocument();
		Element rootElement = document.addElement("root");

		for (Iterator flaDesignFileMetaIt = ProjectConfig.getInstance().flaDesignFileMetaList.iterator(); flaDesignFileMetaIt.hasNext();) {
			FlaFileMeta meta = (FlaFileMeta) flaDesignFileMetaIt.next();
			analysisFlaDesignFile(meta, rootElement);
		}
	}

	@SuppressWarnings("unchecked")
	public void analysisFlaDesignFile(FlaFileMeta meta, Element partentElement) {
		/**
		 * Add Node <Component></Component>
		 */
		Element generateComponentElement = partentElement.addElement("Component");

		/*
		 * ReadEachLayer <DOMSymbolItem><timeline><DOMTimeline><layers>...
		 */
		Document flaDesignFileDoc = XMLUtils.readXml(meta.filePath);
		Element readRootElement = flaDesignFileDoc.getRootElement().element("timeline").element(
				"DOMTimeline").element("layers");
		for (Iterator layerElementIt = readRootElement.elements("DOMLayer").iterator(); layerElementIt.hasNext();) {
			/**
			 * Add Node <layer></layer>
			 */
			Element generateLayerElement = generateComponentElement.addElement("layer");
			/*
			 * Read Each Element ... <DOMLayer><frames><DOMFrame><elements>
			 */
			Element layerElement = (Element) layerElementIt.next();
			Element elementsRoot = layerElement.element("frames").element("DOMFrame").element(
					"elements");

			for (Iterator analysElementIt = elementsRoot.elements("DOMSymbolInstance").iterator(); analysElementIt.hasNext();) {
				Element analysElement = (Element) analysElementIt.next();
				generateChildElementByType(
						analysElement.attributeValue("name"),
						generateLayerElement,
						meta.getFilePathWithoutName() + analysElement.attributeValue("libraryItemName") + ".xml");
			}
		}
	}

	/**
	 * 
	 * @param symbolOriginalName
	 * @param parentElement
	 * @param possiblePath
	 */
	private void generateChildElementByType(String symbolOriginalName, Element parentElement,
			String possiblePath) {
		StringTokenizer analysTokenizer = new StringTokenizer(symbolOriginalName, "_");

		String symbolCodeName = analysTokenizer.nextToken();
		String symbolCodeType = analysTokenizer.nextToken();
		String[] symbolParamaters = new String[analysTokenizer.countTokens()];

		int index = 0;
		while (analysTokenizer.hasMoreTokens()) {
			symbolParamaters[index] = analysTokenizer.nextToken();
			index++;
		}
		BasicAssembly assembly = AssemblyManger.getInstance().getAssemblyByType(symbolCodeType);
		if(assembly != null)
		{
			assembly.generateXmlNode(symbolCodeName, symbolParamaters, possiblePath);
		}
		else
		{
			//copy another node from other component , just recored x,y and componet name
		}
	}

}
