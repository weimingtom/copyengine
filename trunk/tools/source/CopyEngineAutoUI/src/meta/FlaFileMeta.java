package meta;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FlaFileMeta {
	public String fileName;
	public String filePath;

	/**
	 * 	analysis file path , find the relative path of current meta
	 * ex:
	 * 	current file path maybe:
	 * 		../../fla/sourcefile/LIBRARY/Symbol.xml
	 * then the analysis result is 
	 * 		../../fla/sourcefile/LIBRARY/ 
	 * 
	 * more info can check in:
	 * 		http://jakarta.apache.org/regexp/applet.html
	 */
	public String getFilePathWithoutName() {
		String regex = "^((\\.+\\/|(\\w+\\/))*\\w+\\/)(\\w+)\\.xml$";
		Pattern pattern = Pattern.compile(regex);
		Matcher matcher = pattern.matcher(filePath);
		if (matcher.find()) {
			return matcher.group(1);
		} else {
			throw new Error("can't analysis filePath :" + filePath);
		}
	}

}
