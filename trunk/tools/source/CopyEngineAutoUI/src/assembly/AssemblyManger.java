package assembly;

public class AssemblyManger {
	private static AssemblyManger instance;

	public static AssemblyManger getInstance() {
		if (instance == null) {
			instance = new AssemblyManger();
		}
		return instance;
	}

	public AssemblyManger() {
	}
	
	public BasicAssembly getAssemblyByType(String type)
	{
		return null;
	}
	
	
}
