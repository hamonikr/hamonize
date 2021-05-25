// node api 
const  { ipcRenderer }  =  require ( 'electron' )

ipcRenderer . on ( 'getContent' ,  function () { 
  var  content  =  document . getElementsById ( "content" ); 
  ipcRenderer . sendToHost ( 'getContent' ,  content . innerText ); 
});