// ActionScript file

//UnUseCode for sorting , get from ActionScript for Multiplayer Games and Virtual Worlds

//		private function sortIsoObjects(_objs:Vector.<IIsoObject>) : void
//		{
//			var list:Vector.<IIsoObject> = _objs.slice(0);
//			_objs = new Vector.<IIsoObject>();
//			for (var i:int = 0 ; i < list.length ; i++)
//			{
//				var newSortObject:IIsoObject = list[i];
//				var added:Boolean = false;
//				for (var j:int = 0 ; j < _objs.length ; j++)
//				{
//					var sortedObject:IIsoObject = _objs[j];
//					if (newSortObject.col <= sortedObject.col+sortedObject.maxCols -1
//						&& newSortObject.row <= sortedObject.row + sortedObject.maxRows -1)
//					{
//						_objs.splice(j,0,newSortObject);
//						added = true;
//						break;
//					}
//				}
//				if (!added)
//				{
//					_objs.push(newSortObject);
//				}
//			}
//			for (var k:int = 0 ; k < _objs.length ; k++)
//			{
//				isoObjectMangerContainer.addChildAt(_objs[k].container,k);
//			}
//		}