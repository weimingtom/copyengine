package
{
	public class Test
	{
		public function Test()
		{
		}
		
		public boolean function behind(Qube a, Qube b) 
		{ 
			return projectedRectanglesOverlap(a,b) 
				&& projectedRhombusOverlap(a,b) 
				&& ( layerBehind(a,b) || (!layerBehind(b,a) )
				&& ( slideBehind(a,b) || (!slideBehind(b,a) )
				&& ( xBehind(a,b) || (!xBehind(b,a) )
				&& ( yBehind(a,b) )
				)
				)
				);
		} 
	}
}