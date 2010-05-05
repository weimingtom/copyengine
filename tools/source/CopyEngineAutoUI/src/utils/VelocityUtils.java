package utils;

import java.io.FileWriter;
import java.io.StringWriter;

import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.apache.velocity.exception.ParseErrorException;
import org.apache.velocity.exception.ResourceNotFoundException;

public final class VelocityUtils {

	public static void writeVelocity(String templatePaht, String exportPath, VelocityContext context) {
		VelocityEngine ve = new VelocityEngine();
		StringWriter writer = new StringWriter();
		Template t;
		FileWriter fw;
		try {
			ve.init();
			t = ve.getTemplate(templatePaht);
			t.merge(context, writer);
			fw = new FileWriter(exportPath);
			fw.write(writer.toString(), 0, writer.toString().length());
			fw.flush();
			fw.close();
		} catch (ResourceNotFoundException e) {
			e.printStackTrace();
		} catch (ParseErrorException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
