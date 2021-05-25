let ipcRenderer = require('electron').ipcRenderer; //used to communicate with webview
    document.addEventListener('contextmenu', function(e) {
         console.log("right click detected")
         let data = {
            x: e.pageX,
            y: e.pageY,
            hasSelection: !!window.getSelection.toString(),
            href: false,
            img: false,
            video: false
        };
        let el = document.elementFromPoint(e.pageX - window.pageXOffset, e.pageY - window.pageYOffset);
        while (el && el.tagName) {
            if (!data.img && el.tagName === 'IMG')
                data.img = el.src;
            if (!data.href && el.href)
                data.href = el.href;
            el = el.parentNode;
        }
        ipcRenderer.sendToHost('contextmenu-data', data);
    });