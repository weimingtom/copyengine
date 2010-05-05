package factory;

import java.util.ArrayList;
import java.util.Iterator;

import meta.FlaSourceFileMeta;
import vo.FlaSourceFileVo;
import analysis.FlaSourceFileAnalyser;
import config.ProjectConfig;

public class AutoUIGenerateFactory {
	private ArrayList<FlaSourceFileVo> flaSourceFileVoList = new ArrayList<FlaSourceFileVo>(0);

	@SuppressWarnings("unchecked")
	public void generateXml() {
		//first read flaSourceFile
		for (Iterator flaSourceFileMetaIt = ProjectConfig.getInstance().flaSourceFileMetaList.iterator(); flaSourceFileMetaIt.hasNext();) {
			FlaSourceFileMeta meta = (FlaSourceFileMeta) flaSourceFileMetaIt.next();
			flaSourceFileVoList.add(FlaSourceFileAnalyser.analysisFlaSourceFile(meta));
		}
		
		
		
	}

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
