package meta;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FlaFileMeta {
	public String fileName;
	public String filePath;

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
