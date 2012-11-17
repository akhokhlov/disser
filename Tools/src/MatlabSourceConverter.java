import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Scanner;

public class MatlabSourceConverter
{
	private final static String MATLAB_DIR = ".." + File.separator + "matlab";
	private final static String THESIS_DIR = ".." + File.separator + "thesis";
	private final static String MATLAB_DIR_IN_THESIS = THESIS_DIR
			+ File.separator + "srcmat";

	public static void main(String[] args) throws IOException
	{
		File matlabDirInThesis = new File(MATLAB_DIR_IN_THESIS);
		if (!matlabDirInThesis.exists())
		{
			matlabDirInThesis.mkdir();
		}
		File matlabDir = new File(MATLAB_DIR);
		File[] files = matlabDir.listFiles();
		for (File srcDir : files)
		{
			if (srcDir.getName().startsWith("."))
			{
				continue;
			}
			copyAndRetrieveDir(srcDir);
		}
	}

	private static void copyAndRetrieveDir(File dir)
	{
		File copiedDir = new File(MATLAB_DIR_IN_THESIS + File.separator
				+ dir.getName());
		if (!copiedDir.exists())
		{
			copiedDir.mkdir();
		}
		for (File file : dir.listFiles())
		{
			if (file.getName().endsWith(".m"))
			{
				prepare(file, copiedDir);
			}
		}
	}

	private static void prepare(File file, File dir)
	{
		Scanner scan = null;
		PrintWriter writer = null;
		try
		{
			scan = new Scanner(file, "utf8");
			writer = new PrintWriter(new File(MATLAB_DIR_IN_THESIS
					+ File.separator + dir.getName(), file.getName()), "cp1251");
			//writer.println("\\begin{verbatim}");
			while (scan.hasNextLine())
			{
				String line = scan.nextLine();
				if (line.trim().length() > 1)
				{
					//line = line.replaceAll("                ", "\t\t\t\t");
					//line = line.replaceAll("        ", "\t\t");
					writer.println(line.replaceAll("    ", "\t"));
				}
			}
			//writer.println("\\end{verbatim}");
		} catch (IOException e)
		{
			e.printStackTrace();
		} finally
		{
			if (writer != null)
			{
				writer.flush();
				writer.close();
			}
		}

	}
}
