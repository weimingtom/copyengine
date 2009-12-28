package copyengine
{
public class CopyEngineMessage
{
	/**
	 * those message will send during copyEngine init .
	 * the all init have order step , each step must wait per step finished then can start. 
	 */	
	public static const COPYENGINE_INIT_FIRST_START:String = "CopyEngine_Init_First_Start";
	public static const COPYENGINE_INIT_FIRST_COMPLETED:String = "CopyEngine_Init_First_Completed";
	
	public static const COPYENGINE_INIT_SECOND_START:String = "CopyEngine_Init_Second_Start";
	public static const COPYENGINE_INIT_SECOND_COMPLETED:String = "CopyEngine_Init_Second_Completed";
	
	public static const COPYENGINE_INIT_THIRD_START:String = "CopyEngine_Init_Third_Start";
	public static const COPYENGINE_INIT_THIRD_COMPLETED:String = "CopyEngine_Init_Third_Complate";

	public function CopyEngineMessage ()
	{
	}
}
}