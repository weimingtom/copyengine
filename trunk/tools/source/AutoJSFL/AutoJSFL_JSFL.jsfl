// Main 
//========================================================================================
cleanFile();
var stageDoc = fl.openDocument(getReadFilePath());
readFlaToNode();
fl.trace("Generat File Successed")
//=========================================================================================

//============================
//      Function
//============================

//======================
//== Read Assets
//======================
function readFlaToNode()
{
	writeXmlFileHead();									// <?xml version=\"1.0\" encoding=\"utf-8\"?>
														// <root>
	readComponent();
	
	writeXmlFileEnd();									// </root>									
}


function readComponent()
{
	var timeline = fl.getDocumentDOM().getTimeline();
	
	writeComponentHead();
	for (var j = 0; j < timeline.layers.length; j++) 
	{
		var layer = timeline.layers[j];
		var elements = layer.frames[0].elements;
		
		writeLayerHead(layer.name);						// <layer name = "LayerName">
		
		for (var i=0; i<elements.length ; i++) 
		{
			var element = elements[i];
			readElement(element);
		}
		
		writeLayerEnd();								// </layer>
	};
	writeComponentEnd();
}

function readElement(element)
{
	if(element.libraryItem != null)
	{
		writeElementHead();								// <element>
		var linkName = element.libraryItem.linkageClassName;
		if(linkName.indexOf("BtnTween") != -1 )
		{
			writeTweenButton(element);
		}
		else if( linkName.indexOf("Container") )
		{
			stageDoc.library.editItem(element.libraryItem.name);
			readComponent();
			stageDoc.exitEditMode();
		}
		else if( linkName.indexOf("Placeholder") )
		{
			
		}
		else 
		{
			fl.trace("ERROR :: Can't analysis element type");	
		}
		writeElementEnd();								// <element/>
	}
	else
	{
		fl.trace("ERROR :: Stage only can put symbol");
	}
}

//==========================================
//== Write Assets
//==========================================

//==================
//==	BtnTween
//==================
function writeTweenButton(element)
{
	var string = "";
	string += "<symbol type = \"BtnTween\" ";
	string += readNormalElement(element);
	string += " />"
	writeString (string);
}

//==================
//== PlaceHolder
//==================
function wirtePlaceholder(element)
{
	
}


//===================
//== Normal Component
//===================

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
function readNormalElement(element)
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
	
   var string = "";
   string += "uniqueName = \"" + component.uniqueName +"\" linkClassName =\"" + component.linkClassName +"\" posX = \"" + component.posX +
   			 "\" posY = \"" + component.posY + "\" width = \"" + component.width +"\" height = \"" + component.height + "\" rotation = \"" + component.rotation +
			 "\" alpha = \"" + component.alpha + "\"";
   return string;
}

//=============================================
//====  XML
//=============================================

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

//================
//== Component
//================
function writeComponentHead()
{
	var string = "";
	string += "<component>\n";
	writeString (string);
}

function writeComponentEnd()
{
	var string = "";
	string += "</component>\n";
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

//===================
//== Element
//===================
function writeElementHead()
{
	var string = "";
	string += "<element>\n";
	writeString (string);
}

function writeElementEnd()
{
	var string = "";
	string += "</element>\n";
	writeString (string);
}

//===========================================
//=== Config
//===========================================

function getExportFilePath()
{
    return "file:///test.xml"
}

function getReadFilePath()
{
	return "file:///AutoJSFL-Test.fla";
}

//==========================================
//===  System Function
//==========================================

function writeString(_string)
{
  FLfile.write( getExportFilePath() , _string , "append");
}

function cleanFile()
{
  FLfile.write( getExportFilePath(),"");
}
