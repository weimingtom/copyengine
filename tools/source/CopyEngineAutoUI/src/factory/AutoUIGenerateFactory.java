package factory;

import java.util.ArrayList;
import java.util.Iterator;

import meta.FlaFileMeta;
import vo.FlaSourceFileVo;
import analysis.FlaDesignFileAnalyser;
import analysis.FlaSourceFileAnalyser;
import config.ProjectConfig;

public class AutoUIGenerateFactory {

	@SuppressWarnings("unchecked")
	public void generateXml() {
		for (Iterator flaDesignFileMetaIt = ProjectConfig.getInstance().flaDesignFileMetaList.iterator(); flaDesignFileMetaIt.hasNext();) {
			FlaFileMeta meta = (FlaFileMeta) flaDesignFileMetaIt.next();
			FlaDesignFileAnalyser.getInstance().analysisFlaDesignFile(meta);
		}
	}
}
