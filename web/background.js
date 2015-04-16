
function createWindow() {
  chrome.app.window.create(
    'index.html',
    {
      id: 'mainWindow',
      outerBounds: {
        width: 800,
        height: 500,
        minWidth: 320
      },
      frame: {
        type: 'chrome',
        color: '#BDBDBD'
      }
    },
    function(appWindow) {
      appWindow.onClosed.addListener(closeSockets);
    }
  );
}

function closeSockets() {
  chrome.sockets.tcpServer.getSockets(function(sockets) {
    sockets.forEach(function(socket) {
      chrome.sockets.tcpServer.close(socket.socketId);
    });
  });
}

chrome.app.runtime.onLaunched.addListener(createWindow);
