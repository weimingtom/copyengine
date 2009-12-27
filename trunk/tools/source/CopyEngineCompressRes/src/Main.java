import java.io.File;
import java.util.Iterator;

import compress.file.CompressConfigFile;


public class Main {

	/**
	 * @param args
	 * @throws Exception 
	 */
	public static void main(String[] args) throws Exception {
		refreshFileList( CompressConfigFile.getInstance().getResRootPath() );
	}
	
	public static void refreshFileList(String strPath) throws Exception {
		File dir = new File(strPath);
		File[] files = dir.listFiles();
		if (files == null)
			return;
		for (int i = 0; i < files.length; i++) {
			if ( files[i].isDirectory() ) {
				refreshFileList(files[i].getAbsolutePath());
			} else {
				String strFileName = files[i].getName();
				if( isNeedType(strFileName ) ){
					String fileName = strFileName.substring(0, strFileName.lastIndexOf(".") );
					Compress.CompressFile(files[i].getAbsolutePath() , CompressConfigFile.getInstance().getCompressPath() +"\\"+fileName+".bin");
				}
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	public static boolean isNeedType(String fileName){
		for (Iterator iterator = CompressConfigFile.getInstance().getConversionTpyeArray().iterator(); iterator.hasNext();) {
			String type = (String) iterator.next();
			if( fileName.lastIndexOf(".") != -1 ){
				String fileType = fileName.substring(fileName.lastIndexOf(".")+1);
				if( type.equals(fileType) ){
					return true;
				}				
			}else{
				return false;
			}
		}
		return false;
	}
	
	
	
}
