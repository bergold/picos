
chrome.app.runtime.onLaunched.addListener(function(launchData) {
  chrome.app.window.create(
    'index.html',
    {
      id: 'mainWindow',
      outerBounds: {
        width: 800,
        height: 500
      },
      frame: {
        type: 'chrome',
        color: '#1976D2',
        activeColor: '#1976D2',
        inactiveColor: '#1976D2'
      }
    }
  );
});
