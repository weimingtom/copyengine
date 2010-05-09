package vo;

import java.util.ArrayList;
import java.util.Iterator;
import meta.FlaFileMeta;

import org.dom4j.Document;
import org.dom4j.Element;

import config.ProjectConfig;

import utils.XMLUtils;

public final class FlaSourceFileVoManger {
	private static FlaSourceFileVoManger instance;

	public static FlaSourceFileVoManger getInstance() {
		if (instance == null) {
			instance = new FlaSourceFileVoManger();
		}
		return instance;
	}
	
	private ArrayList<FlaSourceFileVo> flaSourceFileVoList = new ArrayList<FlaSourceFileVo>(0);
	
	public FlaSourceFileVoManger() {
		for (Iterator<FlaFileMeta> flaSourceFileMetaIt = ProjectConfig.getInstance().flaSourceFileMetaList.iterator(); flaSourceFileMetaIt.hasNext();) {
			FlaFileMeta meta = flaSourceFileMetaIt.next();
			flaSourceFileVoList.add(analysisFlaSourceFile(meta));
		}
	}
	
	// =============
	// == Utils function
	// =============
	@SuppressWarnings("unchecked")
	public FlaSourceFileVo findFlaSourceFileVoBySymbolName(String symbolName) {
		for (Iterator flaSourceFileVoIt = flaSourceFileVoList.iterator(); flaSourceFileVoIt.hasNext();) {
			FlaSourceFileVo flaSourceFileVo = (FlaSourceFileVo) flaSourceFileVoIt.next();
			if (flaSourceFileVo.isSymbolInCurrentFile(symbolName)) {
				return flaSourceFileVo;
			}
		}
		return null;
	}
	
	//==============
	//== Private Function
	//==============
	/**
	 * Analysis each source file.xml file.
	 *  source file path should link to each fla file DOMDocument.xml.
	 *  this function will analysis DOMDocument-symbols-include node
	 *   <Include href="Btns/Building/IconAnimalHouse.xml"/>
	 *   it will find the href attribute, and use this path to find the symbol xml file.
	 *   read this file ,try to find "linkageClassName" attribute in root node.
	 */
	@SuppressWarnings("unchecked")
	private FlaSourceFileVo analysisFlaSourceFile(FlaFileMeta metaFlaSourceFile) {
		FlaSourceFileVo flaSourceFileVo = new FlaSourceFileVo();
		flaSourceFileVo.flaSourceName = metaFlaSourceFile.fileName;

		Document confilgFile = XMLUtils.readXml(metaFlaSourceFile.filePath);
		Element symbolNode = confilgFile.getRootElement().element("symbols");
		for (Iterator<Element> symbolIt = symbolNode.elements("Include").iterator(); symbolIt.hasNext();) {
			Element analysisNode = symbolIt.next();
			
			Document symbolDoc = XMLUtils.readXml(metaFlaSourceFile.getFilePathWithoutName()+analysisNode.attributeValue("href"));
			Element symbolRootEle = symbolDoc.getRootElement();
			if(symbolRootEle.attribute("linkageClassName") != null)
			{
				flaSourceFileVo.sourceSymbolList.add(symbolRootEle.attributeValue("linkageClassName"));
			}
		}
		return flaSourceFileVo;
	}

}
