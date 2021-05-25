// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// All of the Node.js APIs are available in this process.

const { ipcRenderer } = require('electron');

console.log("1==="+ ipcRenderer.sendSync('hello-sync', 'hello-renderer')) // prints "hello-main"
ipcRenderer.on('hello-async-reply', (event, arg) => {
console.log("render===" + arg) // prints "hello-main"
});
ipcRenderer.send('hello-async', 'hello-renderer');




