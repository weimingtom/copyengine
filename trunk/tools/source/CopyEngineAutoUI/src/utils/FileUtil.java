package utils;

public class FileUtil {
	/**
	 * ��ȡ�ļ���׺��
	 * 
	 * "sss.ss" ���� "ss" 
	 * "sss." ���� "." 
	 * "sss" ���� ""
	 *  
	 * @param fileName �ļ��� 
	 * @return ��׺ 
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
	 * ��ȡ��ȥ��׺������ļ��� 
	 * 
	 * @param fileName �ļ��� 
	 * @return �ļ��� 
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