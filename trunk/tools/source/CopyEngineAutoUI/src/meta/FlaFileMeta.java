package meta;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FlaFileMeta {
	public String fileName;
	public String filePath;

	public String getFilePathWithoutName() {
		String regex = "^(.+\\)\\.xml$";
		Pattern pattern = Pattern.compile(regex);
		Matcher matcher = pattern.matcher(filePath);
		if (matcher.find()) {
			return matcher.group(2);
		} else {
			throw new Error("can't analysis filePath :" + filePath);
		}
	}

}
