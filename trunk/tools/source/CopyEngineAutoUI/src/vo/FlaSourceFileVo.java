package vo;

import java.util.ArrayList;
import java.util.Iterator;

public class FlaSourceFileVo {
	/**
	 * the source fla file name
	 */
	public String flaSourceName;

	/**
	 * all symbol define in current file.
	 */
	public ArrayList<String> sourceSymbolList = new ArrayList<String>(0);

	@SuppressWarnings("unchecked")
	public boolean isSymbolInCurrentFile(String targetSymbolName) {
		for (Iterator symbolIt = sourceSymbolList.iterator(); symbolIt.hasNext();) {
			String symbol = (String) symbolIt.next();
			if (symbol.equals(targetSymbolName)) {
				return true;
			}
		}
		return false;
	}

}
