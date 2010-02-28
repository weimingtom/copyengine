// Main 
//========================================================================================
readFlaToNode( fl.openDocument(getReadFilePath()) );
fl.trace("Generat File Successed")
//=========================================================================================

//============================
//      Function
//============================
function writeStage()
{
	var tml = document.getTimeline();
    writeString ("<Component>\n");
    for(var i=0; i< tml.layers.length ; i++)
    {
		writeLayer(tml.layers[i]);
    }
    writeString ("</Component>\n");
}

function writeLayer(_layer)
{
	var name = _layer.name
	writeString ("<layer name= \"" + name + "\" >\n");
	for(var i=0 ;i < _layer.frames.length ; i++)
	{
		writeSymbol(_layer.frames[i]);
	}
	writeString ("</layer>\n");
}

function writeSymbol(_frames)
{
	for(var i=0 ; i < _frames.elements.length ; i++)
	{
		var element = _frames.elements[i];
		var posX = element.x;
		var posY = element.y;
		var width = element.width;
		var height = element.height;
		var name = element.name;
		var rotation = element.rotation;
		
		var skin = element.libraryItem.linkageClassName;
		var alpha = element.colorAlphaPercent * 0.01;

		writeString ("<symbol "
		              +" name= \"" + name +"\""
		              +" skin= \"" + skin +"\""
					  +" posX= \"" + posY +"\"" 
					  +" posY= \"" + posY +"\""
					  +" width= \"" + width +"\""
					  +" height= \"" + height +"\""
					  +" alpha= \"" + alpha + "\""
					  +" rotation= \"" + rotation +"\""
					  +" />\n");
	}
}

//======================
//== Read Assets
//======================
function readFlaToNode(doc)
{
	writeXmlFileHead();									// <?xml version=\"1.0\" encoding=\"utf-8\"?>
														// <root>
	
	var timeLine = doc.getTimeline();
	for (var j = 0; j < timeLine.layers.length; j++) 
	{
		var layer = timeLine.layers[j];
		var elements = layer.frames[0].elements;
		
		writeLayerHead(layer.name);						// <layer name = "LayerName">
		
		for (var i=0; i<elements.length ; i++) 
		{
			var element = elements[i];
			writeElement(element);
		}
		
		writeLayerEnd();								// </layer>
	};
	
	writeXmlFileEnd();									// </root>									
}

function writeElement(element)
{
	if(element.libraryItem != null)
	{
		var linkName = element.libraryItem.linkageClassName;
		if(linkName.indexOf("BtnTween"))
		{
			writeTweenButton(element);
		}
		else if( linkName.indexOf("OtherComponent") )
		{
			
		}
		else
		{
			wirtePlaceholder(element);
		}
	}
	else
	{
		fl.trace("Can't put any no name element in stage");
	}
}

/*
 * Read the normal component.
 * 
 * uniqueName      // each component hava it uniqueName
 * linkClassName   
 * posX
 * posY
 * width
 * height
 * rotation
 * alpha
 */
function readCompoent(element)
{
   var component = new Object();
   
   component.uniqueName = element.name;
   component.linkClassName = element.libraryItem.linkageClassName;
   component.posX = element.x;
   component.posY = element.y;
   component.width = element.width;
   component.height = element.height;
   component.rotation = element.rotation;
   component.alpha = element.colorAlphaPercent * 0.01;
   
   return component;
}

function readButton(element)
{
}

//======================
//== Write Assets    XML
//======================

/**
 * Export the flaFile node data to an xml File
 * 
 * @param {Object} nodeData			current fla file node data
 * 
 */
function exportDataToXML(nodeData)
{
	writeXmlFileHead();
	writeXmlFileEnd();
}

//===============
//== Root
//===============
function writeXmlFileHead()
{   
    var string = "";
    string += "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    string += "<root>\n"
    writeString (string)
}

function writeXmlFileEnd()
{
    var string = "";
    string += "</root>";
    writeString (string);
}

//===============
//== Layer
//================
function writeLayerHead(name)
{
	var string = "";
	string += "<layer name = \"" + name + "\" >";
	string += "\n";
	writeString (string);
}

function writeLayerEnd()
{
	var string = "";
	string += "</layer>";
	string += "\n";
	writeString (string);
}

//==================
//== Normal Component
//==================
function wirtePlaceholder(element)
{
	
}

//==================
//==	BtnTween
//==================
function writeTweenButton(element)
{
}

function writeString(_string)
{
  FLfile.write( getExportFilePath() , _string , "append");
}

//==================
//=== Config
//==================

function getExportFilePath()
{
    return "file:///test.xml"
}

function getReadFilePath()
{
	return "file:///AutoJSFL-Test.fla";
}
