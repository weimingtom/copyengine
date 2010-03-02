//======================
//=== Initialze
//======================
var tml=fl.getDocumentDOM().getTimeline();
for(var i=0 ; i<tml.layers.length ; i++)
{
    var elements = tml.layers[i].frames[0].elements
    for(var j=0 ; j<elements.length ; j++)
    {
        readElement(elements[j]);
    }
}

var element = elements[0];
var name = element.libraryItem.linkageClassName;
fl.trace("Name = " + name);
if(name.search("Render") > 0)
{
  fl.getDocumentDOM().library.editItem(element.libraryItem.name);
  var tml2=fl.getDocumentDOM().getTimeline();
  var elements2 = tml2.layers[0].frames[0].elements;
  for(var i=0; i<elements2.length; i++)
  {
    var element2 = elements2[i];
    fl.trace(element2.libraryItem.linkageClassName)
    fl.trace("Element Name =  " + element2.name);
  }
  fl.getDocumentDOM().exitEditMode();
}
else
{
  fl.trace("Not Found");
}

//=======================
//== Function readElement
//=======================
function readElement(_element)
{

}



//====================
//== Function XML
//====================

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