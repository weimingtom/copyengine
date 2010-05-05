package utils;

public class FileUtil {
	/**
	 * 获取文件后缀名
	 * 
	 * "sss.ss" 返回 "ss" 
	 * "sss." 返回 "." 
	 * "sss" 返回 ""
	 *  
	 * @param fileName 文件名 
	 * @return 后缀 
	 */
	public static String getExt(String fileName) {
		int pos = fileName.lastIndexOf(".");
		if (pos == -1) {
			return "";
		} else {
			return fileName.substring(pos, fileName.length());
		}
	}

	/** 
	 * 获取除去后缀名后的文件名 
	 * 
	 * @param fileName 文件名 
	 * @return 文件名 
	 */
	public static String getName(String fileName) {
		int pos = fileName.lastIndexOf(".");
		if (pos == -1) {
			return fileName;
		} else {
			return fileName.substring(0, pos);
		}
	}
}