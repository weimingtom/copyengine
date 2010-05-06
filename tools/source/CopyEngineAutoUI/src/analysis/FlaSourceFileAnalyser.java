package analysis;

import java.util.Iterator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.dom4j.Document;
import org.dom4j.Element;

import meta.FlaFileMeta;

import utils.XMLUtils;
import vo.FlaSourceFileVo;

public final class FlaSourceFileAnalyser {

	@SuppressWarnings("unchecked")
	public static FlaSourceFileVo analysisFlaSourceFile(FlaFileMeta metaFlaSourceFile) {
		FlaSourceFileVo flaSourceFileVo = new FlaSourceFileVo();
		flaSourceFileVo.flaSourceName = metaFlaSourceFile.fileName;

		Document confilgFile = XMLUtils.readXml(metaFlaSourceFile.filePath);
		Element symbolNode = confilgFile.getRootElement().element("symbols");
		for (Iterator symbolIt = symbolNode.elements("Include").iterator(); symbolIt.hasNext();) {
			Element analysisNode = (Element) symbolIt.next();

			String regex = "^(\\w+\\/)*(\\w+)\\.xml$";
			Pattern pattern = Pattern.compile(regex);
			Matcher matcher = pattern.matcher(analysisNode.attributeValue("href"));
			if (matcher.find()) {
				flaSourceFileVo.sourceSymbolList.add(matcher.group(2));
			} else {
				System.err.println("Can't analysis symbol :" + analysisNode.attributeValue("href"));
			}
		}
		return flaSourceFileVo;
	}
}
