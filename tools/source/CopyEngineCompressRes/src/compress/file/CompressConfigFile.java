package compress.file;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

public class CompressConfigFile {
	
	public static String CONFIG_DOCUMENT_LOACTION = "CompressConfig.xml";
	private static CompressConfigFile instance;
	public static CompressConfigFile getInstance(){
		if(instance == null){
			instance = new CompressConfigFile();
		}
		return instance;
	}
	
	public CompressConfigFile() {
		loadConfig();	
	}

	@SuppressWarnings("unchecked")
	private void loadConfig() {
		SAXReader saxReader = new SAXReader();
		File configFile = new File(CONFIG_DOCUMENT_LOACTION);
		configAbsolutePath = configFile.getAbsoluteFile().getParent();
		try {
			Document document = saxReader.read(new File(CONFIG_DOCUMENT_LOACTION));
			Element rootElm = document.getRootElement();	

			Element configResRootPath = rootElm.element("resRootPath");
			this.resRootPath = configResRootPath.getText();			

			Element configCompressPath = rootElm.element("compressPath");
			this.compressPath = configCompressPath.getText();
			
			for (Iterator iterator = rootElm.element("conversionTpye").elementIterator("type"); iterator.hasNext();) {
				Element type = (Element) iterator.next();
				conversionTpyeArray.add( type.getText() );
			}
			
		}catch (DocumentException e) {
			e.printStackTrace();
		} 
	}



	private List<String> conversionTpyeArray = new ArrayList<String>(0);
	private String resRootPath;
	private String compressPath;
	private String configAbsolutePath;
	
	
	public String getConfigAbsolutePath() {
	    return configAbsolutePath;
	}

	public List<String> getConversionTpyeArray() {
		return conversionTpyeArray;
	}

	public String getResRootPath() {
		return resRootPath;
	}

	public String getCompressPath() {
		return compressPath;
	}
	
	
	
	
	
}
