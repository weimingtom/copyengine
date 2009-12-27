import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.zip.Deflater;
import java.util.zip.DeflaterOutputStream;

import compress.file.CompressConfigFile;


public class Compress {

	/**
	 * @param args
	 * @throws Exception
	 * @throws Exception
	 */
	public static void CompressFile(String inputFilePath, String outputFilePath)
			throws Exception {
		// get the parameters
		File inputFile = new File(inputFilePath);
		File outputFile = new File(CompressConfigFile.getInstance().getConfigAbsolutePath(),outputFilePath);

		FileInputStream fis = new FileInputStream(inputFile);
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		int curByte;
		while ((curByte = fis.read()) != -1) {
			baos.write(curByte);
		}
		fis.close();

		byte[] bytesToWrite = baos.toByteArray();
		baos.close();

		// write out the compressed binary file
		FileOutputStream fos = new FileOutputStream(outputFile);
		Deflater deflater = new Deflater(Deflater.BEST_COMPRESSION);
		DeflaterOutputStream deflaterOS = new DeflaterOutputStream(fos,
				deflater);
		deflaterOS.write(bytesToWrite);
		deflaterOS.flush();
		deflaterOS.close();
	}
}
