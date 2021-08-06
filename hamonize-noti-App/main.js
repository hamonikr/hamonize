const electronLocalshortcut = require('electron-localshortcut');
const parseArgs = require('electron-args');
const { app, BrowserWindow } = require('electron')
const {ipcMain} = require('electron')  

let mainWindow = null
const cli = parseArgs(`
    hamonikr-open-viewer
 
    Usage
      $ hamonikr-open-viewer [path]
 
    Options
      --help     show help
      --version  show version
      --auto     slide show [Default: false]
 
    Examples
      $ sample-viewer . --auto
      $ sample-viewer ~/Pictures/
`, {
    alias: {
        h: 'help'
    },
    default: {
        auto: false
    }
});


let ArgumentData = '';
function createWindow () {

  mainWindow = new BrowserWindow({
    skipTaskbar: false,  
    frame:false,
    transparent: true,
    width: 500, 
    height: 280
  })

  // ArgumentData = cli.input[0];
  const tmpData =cli.input;
  ArgumentData = tmpData;

  mainWindow.loadURL('file://' + __dirname + '/hamonize-notiApp.html')
  mainWindow.on('closed', () => {
    mainWindow = null
  })

  electronLocalshortcut.register(mainWindow, 'F12', () => {
    console.log('F12 is pressed')
    mainWindow.webContents.toggleDevTools()
  });
  
}


app.on('ready', () => {
  
  setTimeout(createWindow, 200);
  
})


ipcMain.on('argumentData_chkeck', (event ) => {
  argumentData_chkeck_Async(event);
});

const argumentData_chkeck_Async = async(event) => {
  event.sender.send('argumentData_chkeck_Async_Result', ArgumentData);
}