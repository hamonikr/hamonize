const {ipcRenderer} = require('electron');
const {BrowserWindow} = require('electron');

install_program_version_chkeck();
function install_program_version_chkeck(){
	ipcRenderer.send('argumentData_chkeck'); 
} 

ipcRenderer.on('argumentData_chkeck_Async_Result', (event, dataVal) => {

	if( dataVal.length > 0 ) {
		dataVal = dataVal.toString().replace(/,/g,' ')
		dataVal = dataVal.toString().replace(/-/g,'<br>')
		$(".info_01").text(dataVal);
		$(".info_01").css('padding','65px 30px 15px 118px');
	}
});