using Toybox.WatchUi;

class CommonMenuSettings extends WatchUi.Menu2 {
  function initialize() {
    System.println("MenuSettings");
    Menu2.initialize(null);
    Menu2.setTitle("Settings");
     Menu2.addItem(
      new WatchUi.ToggleMenuItem(
        "show side data",
        null,
        "showsidedata",
        getApp().getProperty("ShowSideText"),
        null
      )
    );


    //other things
  }
}
