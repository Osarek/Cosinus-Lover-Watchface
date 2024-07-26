import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class CommonMenuInput  extends WatchUi.Menu2InputDelegate {
  var common;
  function initialize( ) {
    Menu2InputDelegate.initialize();
  }

  function onSelect(item) {
    switch (item.getId()) {
      case "showsidedata":
        var show = getApp().getProperty("ShowSideText");

        getApp().setProperty("ShowSideText", !show);
        break;
    }
  }

  function onBack() {
    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    // return false;
  }
}
