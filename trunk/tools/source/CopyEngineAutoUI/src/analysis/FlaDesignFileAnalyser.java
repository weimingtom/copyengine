package analysis;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.StringTokenizer;

import org.dom4j.Document;
import org.dom4j.Element;

import config.ProjectConfig;

import meta.FlaFileMeta;
import utils.XMLUtils;
import vo.FlaSourceFileVo;

public class FlaDesignFileAnalyser {
	private static FlaDesignFileAnalyser instatnce;

	public static FlaDesignFileAnalyser getInstance() {
		if (instatnce == null) {
			instatnce = new FlaDesignFileAnalyser();
		}
		return instatnce;
	}

	private ArrayList<FlaSourceFileVo> flaSourceFileVoList = new ArrayList<FlaSourceFileVo>(0);

	// ==========
	// == Initialze
	// ==========
	@SuppressWarnings("unchecked")
	public FlaDesignFileAnalyser() {
		// read flaSourceFile , get all the source symbol.
		for (Iterator flaSourceFileMetaIt = ProjectConfig.getInstance().flaSourceFileMetaList.iterator(); flaSourceFileMetaIt.hasNext();) {
			FlaFileMeta meta = (FlaFileMeta) flaSourceFileMetaIt.next();
			flaSourceFileVoList.add(FlaSourceFileAnalyser.analysisFlaSourceFile(meta));
		}
	}

	// ===========
	// == Portal function
	// ===========
	@SuppressWarnings("unchecked")
	public void analysisFlaDesignFile(FlaFileMeta meta, Element partentElement) {
		Element generateComponentElement = partentElement.addElement("Component");

		Document flaDesignFileDoc = XMLUtils.readXml(meta.filePath);
		/*
		 * <DOMSymbolItem> <timeline> <DOMTimeline> <layers> ... </layers>
		 * </DOMTimeline> </timeline> </DOMSymbolItem>
		 */
		Element readRootElement = flaDesignFileDoc.getRootElement().element("timeline").element(
				"DOMTimeline").element("layers");
		for (Iterator layerElementIt = readRootElement.elements("DOMLayer").iterator(); layerElementIt.hasNext();) {
			Element generateLayerElement = generateComponentElement.addElement("layer");
			/*
			 * ... <DOMLayer> <frames> <DOMFrame> <elements> </elements>
			 * </DOMFrame> </frames> </DOMLayer> ...
			 */
			Element layerElement = (Element) layerElementIt.next();
			Element elementsRoot = layerElement.element("frames").element("DOMFrame").element(
					"elements");

			for (Iterator analysElementIt = elementsRoot.elements("DOMSymbolInstance").iterator(); analysElementIt.hasNext();) {
				Element analysElement = (Element) analysElementIt.next();
				// make sure the
				generateChildElementByType(
						analysElement.attributeValue("name"),
						generateLayerElement,
						meta.getFilePathWithoutName() + analysElement.attributeValue("libraryItemName") + ".xml");
			}
		}

	}

	private void generateChildElementByType(String type, Element parentElement, String possiblePath) {
		StringTokenizer analysTokenizer = new StringTokenizer(type, "_");

		String symbolName = analysTokenizer.nextToken();

		String symbolType = analysTokenizer.nextToken();

		String[] symbolAttribute = new String[analysTokenizer.countTokens()];
		int index = 0;
		while (analysTokenizer.hasMoreTokens()) {
			symbolAttribute[index] = analysTokenizer.nextToken();
			index++;
		}

		// startAnalys
		if (symbolType.equals("Symbol")) {
			Document symbolDoc = XMLUtils.readXml(possiblePath);
			// name :: xxx_Symbol_xxx
			SymbolElementAnalyser.analyserSymbolNode(symbolDoc, parentElement, symbolAttribute);
		}

	}

	// =============
	// == Utils function
	// =============
	@SuppressWarnings("unchecked")
	private FlaSourceFileVo findFlaSourceFileVoBySymbolName(String symbolName) {
		for (Iterator flaSourceFileVoIt = flaSourceFileVoList.iterator(); flaSourceFileVoIt.hasNext();) {
			FlaSourceFileVo flaSourceFileVo = (FlaSourceFileVo) flaSourceFileVoIt.next();
			if (flaSourceFileVo.isSymbolInCurrentFile(symbolName)) {
				return flaSourceFileVo;
			}
		}
		return null;
	}

}
