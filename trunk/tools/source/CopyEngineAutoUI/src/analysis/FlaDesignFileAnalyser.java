package analysis;

import java.util.ArrayList;
import java.util.Iterator;

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
	
	//==========
	//== Initialze
	//==========
	@SuppressWarnings("unchecked")
	public FlaDesignFileAnalyser() {
		//read flaSourceFile , get all the source symbol.
		for (Iterator flaSourceFileMetaIt = ProjectConfig.getInstance().flaSourceFileMetaList.iterator(); flaSourceFileMetaIt.hasNext();) {
			FlaFileMeta meta = (FlaFileMeta) flaSourceFileMetaIt.next();
			flaSourceFileVoList.add(FlaSourceFileAnalyser.analysisFlaSourceFile(meta));
		}
	}
	
	//===========
	//== Portal function
	//===========
	public Element analysisFlaDesignFile(FlaFileMeta meta) {
		Document flaDesignFileDoc = XMLUtils.readXml(meta.filePath);
		
		return null;
	}
	
	
	//=============
	//== Utils function
	//=============
	@SuppressWarnings("unchecked")
	private  FlaSourceFileVo findFlaSourceFileVoBySymbolName(String symbolName) {
		for (Iterator flaSourceFileVoIt = flaSourceFileVoList.iterator(); flaSourceFileVoIt.hasNext();) {
			FlaSourceFileVo flaSourceFileVo = (FlaSourceFileVo) flaSourceFileVoIt.next();
			if (flaSourceFileVo.isSymbolInCurrentFile(symbolName)) {
				return flaSourceFileVo;
			}
		}
		return null;
	}

}
