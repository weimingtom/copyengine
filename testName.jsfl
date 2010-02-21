var tml=fl.getDocumentDOM().getTimeline();
var elements = tml.layers[0].frames[0].elements;
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