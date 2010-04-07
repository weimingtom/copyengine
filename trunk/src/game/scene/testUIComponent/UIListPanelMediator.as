package game.scene.testUIComponent
{
	import com.greensock.TweenLite;
	
	import copyengine.ui.CEComponentFactory;
	import copyengine.ui.list.CEList;
	import copyengine.ui.list.animation.CEListTweenAnimation;
	import copyengine.ui.list.dataprovider.CEDataProvider;
	import copyengine.ui.panel.CEPanelCore;
	
	import game.ui.test.list.TShapeCellRender;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class UIListPanelMediator extends Mediator
	{
		public static const NAME:String = "UIListPanelMediator";

		private var panel:CEPanelCore;

		public function UIListPanelMediator()
		{
			super(NAME, null);
		}

		override public function listNotificationInterests() : Array
		{
			return [
				PanelMessage.CHANGE_STATE_TO_ONE,
				PanelMessage.CHANGE_STATE_TO_TWO,
				];
		}

		override public function handleNotification(notification:INotification) : void
		{
			switch (notification.getName())
			{
				case PanelMessage.CHANGE_STATE_TO_ONE:
					changeToStateOne();
					break;
				case PanelMessage.CHANGE_STATE_TO_TWO:
					changeToStateTwo();
					break;
			}
		}

		private function changeToStateOne() : void
		{
			CopyEngineAS.gameDialogLayer.addChild(getPanel());
		}


		private function changeToStateTwo() : void
		{
			TweenLite.to(getPanel(),0.5,{x:getPanel().x += 50 , y: getPanel().y + 50});
		}

		private function getPanel() : CEPanelCore
		{
			if (panel == null)
			{
				panel = CEComponentFactory.instance.getCEPanelByUniqueName("sdfdf");
				
				var dataProvider:CEDataProvider = new CEDataProvider();
				var ceList:CEList = panel.getChildCESpriteByUniqueName("Test_CEList") as CEList;
				for (var i:int = 0 ; i < 30 ; i++)
				{
					var data:Object = {};
					data.index = i;
					dataProvider.addData(data);
				}
				ceList.initializeCEList(dataProvider,TShapeCellRender,new CEListTweenAnimation());
			}
			return panel;
		}

	}
}