//================
//== Initialize
//================
writeXmlFileHead();
writeStage();
writeXmlFileEnd();
fl.trace("Generat File Successed")
var inputValue = prompt("文本","默认值");
fl.trace("你输入的值为：" + inputValue);
//============================
//      Function
//============================

function writeStage()
{
	var tml = fl.getDocumentDOM().getTimeline();
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

/*
 * Read the normal component.
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
    var component = readCompoent(element);
    if()
    {
    }
}

function readTextField

//======================
//== XML
//======================

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

function writeButton(type,uniqueName,linkClassName,posX,posY,width,height,alpha,rotation)
{
}

function writeString(_string)
{
  FLfile.write( getFilePath() , _string , "append");
}

//==================
//=== Config
//==================

function getFilePath()
{
    return "file:///test.xml"
}
