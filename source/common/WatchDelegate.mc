using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Timer as Timer;
using Toybox.Complications as Complications;

class WatchDelegate extends Ui.WatchFaceDelegate {
  var lib;
  function initialize(lib as CosinusLoverWatchfaceView) {
    WatchFaceDelegate.initialize();
    self.lib = lib;
  }

  public function onPress(clickEvent) {
    // grab the [x,y] position of the clickEvent
    var co_ords = clickEvent.getCoordinates();

    if (co_ords[0] < lib.common.left ||
    co_ords[0] > lib.common.right ||
    co_ords[1] < lib.common.top ||
    co_ords[1] > lib.common.bottom){
          App.Properties.setValue("ShowSideText", !(App.Properties.getValue("ShowSideText") as Lang.Boolean));
          return true;
    }


    App.Properties.setValue("screen", 1+ (App.Properties.getValue("screen") as Lang.Number) %2);
    self.lib.loadProperties();

    return true;
  }
}
