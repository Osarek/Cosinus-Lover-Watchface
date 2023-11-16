import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;

class CosinusLoverWatchfaceView extends WatchUi.WatchFace {
  var animator;
  var ratio = 0.9;
  function initialize() {
    WatchFace.initialize();
    // animator = new Animator();
  }

  // Load your resources here
  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.WatchFace(dc));
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() as Void {
    // animator.myTimer.start(method(:timerCallback), animator.getTimerMs(), true);
  }

  // Update the view
  function onUpdate(dc as Dc) as Void {
    View.onUpdate(dc);
    // animator.timerCounter++;

    dc.setPenWidth(1);

    // var angle = -animator.timerCounter;

    var angleHour = -90 + ((System.getClockTime().hour % 12) * 360) / 12 + (System.getClockTime().min * 360) / (60*12); //+ clockTime.sec * maxSlot;
    var angleMin = -90 + (System.getClockTime().min * 360) / 60; //+ clockTime.sec * maxSlot;
    var angleSec = -90 + (System.getClockTime().sec * 360) / 60; //+ clockTime.sec * maxSlot;

    var angleChoosen = angleMin;

    var sinMin = Math.sin(Math.toRadians(angleMin));
    var cosMin = Math.cos(Math.toRadians(angleMin));
    var sinHour = Math.sin(Math.toRadians(angleHour));
    var cosHour = Math.cos(Math.toRadians(angleHour));

    var handHourSize = 0.4;
    var colorHands = 0x999999 as Number;
    var handMinSize = 0.9;
    var handSecSize = 1.0;
    var colorCosinus = 0x009900 as Number;
    var colorSinus = 0x009999 as Number;
    var colorAngle = 0x990099 as Number;
    var segmentRatio = 0.95;

    //Hands
    // dc.setPenWidth(3);
    dc.setColor(colorHands, Graphics.COLOR_TRANSPARENT);
    // drawLine(dc, 0, 0, cosMin * handMinSize, sinMin * handMinSize,handMinSize);
    // drawLine(dc, 0, 0, cosHour * handHourSize, sinHour * handHourSize,handMinSize);


    var thinknessHand = 2.5;
    var ratioFat = 0.8;

    drawHand(dc, cosMin, sinMin,angleMin,thinknessHand,ratioFat,handMinSize,1.0);
    drawHand(dc, cosHour, sinHour,angleHour,thinknessHand,ratioFat,handHourSize,1.0);
    // var pts = [];
    // pts.add([0,0]);
    // pts.add([Math.cos(Math.toRadians(angleMin-thinknessHand))*handMinSize*ratioFat,Math.sin(Math.toRadians(angleMin-thinknessHand))*handMinSize*ratioFat]);
    // pts.add([cosMin * handMinSize,sinMin * handMinSize]);
    // pts.add([Math.cos(Math.toRadians(angleMin+thinknessHand))*handMinSize*ratioFat,Math.sin(Math.toRadians(angleMin+thinknessHand))*handMinSize*ratioFat]);
    // fillPolygon(dc,pts);

    // var pts = [];
    // pts.add([0,0]);
    // pts.add([Math.cos(Math.toRadians(angleHour-thinknessHand))*handHourSize*ratioFat,Math.sin(Math.toRadians(angleHour-thinknessHand))*handMinSize*ratioFat]);
    // pts.add([cosMin * handMinSize,sinMin * handMinSize]);
    // pts.add([Math.cos(Math.toRadians(angleHour+thinknessHand))*handHourSize*ratioFat,Math.sin(Math.toRadians(angleMin+thinknessHand))*handMinSize*ratioFat]);
    // fillPolygon(dc,pts);

    dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);

    // dc.setPenWidth(1);


var step = 0.25;
    //horizontal
    drawLine(dc, -1, 0, 1, 0,handMinSize);
    for (var i = -1; i <= 1; i = i + 2*step) {
      drawLine(dc, i, 0, i, -0.06,handMinSize);
      drawLine(dc, i+step, 0, i+step, -0.03,handMinSize);
    }

    //vertical
    drawLine(dc, 0, -1, 0, 1,handMinSize);
    for (var i = -1; i <= 1; i = i + 2*step) {
      drawLine(dc, 0, i, 0.06, i,handMinSize);
      drawLine(dc, 0, i+step, 0.03, i+step,handMinSize);
    }

    drawText(
      dc,
      0,
      -0.6,
      Graphics.FONT_SYSTEM_XTINY,
      System.getClockTime().min + "",
      Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_RIGHT,handMinSize
    );
    drawText(
      dc,
      0,
      -0.9,
      Graphics.FONT_SYSTEM_XTINY,
      "90° ",
      Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_RIGHT,handMinSize
    );
    drawText(
      dc,
      0,
      -0.9,
      Graphics.FONT_SYSTEM_XTINY,
      " π/2 ",
      Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_LEFT,handMinSize
    );

    drawText(
      dc,
      -1,
      -0.1,
      Graphics.FONT_SYSTEM_XTINY,
      "  π ",
      Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER,handMinSize
    );
    drawText(
      dc,
      -1,
      0.1,
      Graphics.FONT_SYSTEM_XTINY,
      "180°",
      Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER,handMinSize
    );

    drawText(
      dc,
      1,
      -0.1,
      Graphics.FONT_SYSTEM_XTINY,
      "360°",
      Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER,handMinSize
    );
    drawText(
      dc,
      1,
      0.1,
      Graphics.FONT_SYSTEM_XTINY,
      "2π  ",
      Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER,handMinSize
    );

    drawText(
      dc,
      0,
      0.9,
      Graphics.FONT_SYSTEM_XTINY,
      " 3π/2 ",
      Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_RIGHT,handMinSize
    );
    drawText(
      dc,
      0,
      0.9,
      Graphics.FONT_SYSTEM_XTINY,
      " 270°",
      Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_LEFT,handMinSize
    );

    // Segments
    var angleOne = 360 / 12;
    for (var slot = 0; slot <= 12; slot++) {
      var angleHourSegment = (slot * 360) / 12; //+ clockTime.sec * maxSlot;

      var x = Math.sin(Math.toRadians(angleHourSegment));
      var y = Math.cos(Math.toRadians(angleHourSegment));

      dc.setColor(
        getApp().getProperty("ForegroundColor") as Number,
        Graphics.COLOR_TRANSPARENT
      );

      drawLine(dc, x, y, x *segmentRatio, y * segmentRatio,1.0);
    }

    //Angles
    dc.setColor(Graphics.COLOR_PURPLE, Graphics.COLOR_TRANSPARENT);

    drawText(
      dc,
      0.2,
      -0.2,
      Graphics.FONT_SYSTEM_XTINY,
      ((-angleChoosen + 360 * 2) % 360) + "°",
      Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER,handHourSize
    );
    if (angleChoosen != 0) {
      drawArc(
        dc,
        0,
        0,
        0.2,
        Graphics.ARC_COUNTER_CLOCKWISE,
        0,
        (-angleChoosen + 360 * 2) % 360,
        handMinSize
      );
    }

    //Cosinus - sinus
    dc.setColor(colorCosinus, Graphics.COLOR_TRANSPARENT);

    drawLine(dc, cosMin, 0, cosMin, sinMin,handMinSize);

    var alignCos = Graphics.TEXT_JUSTIFY_CENTER;
    var alignSin = Graphics.TEXT_JUSTIFY_RIGHT;

    if (cosMin < 0) {
      alignSin = Graphics.TEXT_JUSTIFY_LEFT;
    }

    var yCosText = 0.2;
    var xSinText = -0.05;
    if (cosMin < 0) {
      xSinText = -xSinText;
    }
    if (sinMin > 0) {
      yCosText = -yCosText;
    }

    drawText(
      dc,
      cosMin,
      yCosText,
      Graphics.FONT_SYSTEM_XTINY,
      "cos\n" + cosMin.format("%.2f"),
      Graphics.TEXT_JUSTIFY_VCENTER | alignCos,handHourSize
    );

    dc.setColor(colorSinus, Graphics.COLOR_TRANSPARENT);

    drawLine(dc, 0, sinMin, cosMin, sinMin,handMinSize);
    drawText(
      dc,
      xSinText,
      sinMin,
      Graphics.FONT_SYSTEM_XTINY,
      "sin\n" + sinMin.format("%.2f"),
      Graphics.TEXT_JUSTIFY_VCENTER | alignSin,handHourSize
    );
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() as Void {}

  // The user has just looked at their watch. Timers and animations may be started here.
  function onExitSleep() as Void {
    // animator.timerCounter = 0;
    // animator.myTimer.start(method(:timerCallback), animator.getTimerMs(), true);
  }

  // Terminate any active timers and prepare for slow updates.
  function onEnterSleep() as Void {
    // animator.timerCounter = 0;
    // animator.myTimer.stop();
  }

  // function timerCallback() as Void {
  //   animator.timerCounter = (animator.timerCounter + 1) % 360;

  //   WatchUi.requestUpdate();
  //   System.println("pif");
  // }

  function drawArc(
    dc as Dc,
    x as Number,
    y as Number,
    r as Float,
    attr as Toybox.Graphics.ArcDirection,
    degreeStart as Number,
    degreeEnd as Number,
    secondaryRatio as Float
  ) {
    x = xy(dc, x, ratio);
    y = xy(dc, y, ratio);
    r = (ratio * (r * dc.getWidth())) / 2;
    dc.drawArc(x, y, r, attr, degreeStart, degreeEnd);
  }

  // function drawCircle(
  //   dc as Dc,

  //   x as Lang.Numeric,
  //   y as Lang.Numeric,
  //   radius as Lang.Numeric
  // ) as Void {
  //   x = xy(dc, x, ratio);
  //   y = xy(dc, y);
  //   dc.drawCircle(x, y, radius);
  // }

  // function fillCircle(
  //   dc as Dc,

  //   x as Lang.Numeric,
  //   y as Lang.Numeric,
  //   radius as Lang.Numeric
  // ) as Void {
  //   x = xy(dc, x, ratio);
  //   y = xy(dc, y, ratio);
  //   dc.fillCircle(x, y, radius);
  // }

  function drawLine(
    dc as Dc,

    x1 as Lang.Numeric,
    y1 as Lang.Numeric,
    x2 as Lang.Numeric,
    y2 as Lang.Numeric,
    ratio as Float
  ) as Void {
    x1 = xy(dc, x1, ratio);
    x2 = xy(dc, x2, ratio);
    y1 = xy(dc, y1, ratio);
    y2 = xy(dc, y2, ratio);
    dc.drawLine(x1, y1, x2, y2);
  }

  function drawText(
    dc as Dc,
    x as Lang.Numeric,
    y as Lang.Numeric,
    font as Graphics.FontType,
    text as Lang.String,
    justification as Graphics.TextJustification or Lang.Number,
        ratio as Float

  ) as Void {
    x = xy(dc, x, ratio);
    y = xy(dc, y, ratio);
    dc.drawText(x, y, font, text, justification);
  }

  function fillPolygon(dc as Dc, pts as Lang.Array<Lang.Array<Lang.Numeric> >,    ratio as Float
) as Void {
    for (var i = 0; i < pts.size(); i++) {
      pts[i][0] = xy(dc, pts[i][0], ratio);
      pts[i][1] = xy(dc, pts[i][1], ratio);
    }

    dc.fillPolygon(pts);
  }

  function xy(dc as Dc, xy as Number,secondaryRatio as Float) {
    return (ratio *secondaryRatio * (xy * dc.getWidth())) / 2 + dc.getWidth() / 2;
  }

  function crop(outer as Number, inner as Number, ratio as Float) as Number {
    return ((outer - inner).toFloat() * ratio).toNumber() + inner;
  }

  function drawHand(dc as Dc, cos as Float, sin as Float, angle as Number,thinknessHand as Float,ratioFat as Float,handSize as Float, ratio as Float){
    var pts = [];
    pts.add([0,0]);
    pts.add([Math.cos(Math.toRadians(angle-thinknessHand))*handSize*ratioFat,Math.sin(Math.toRadians(angle-thinknessHand))*handSize*ratioFat]);
    pts.add([cos * handSize,sin * handSize]);
    pts.add([Math.cos(Math.toRadians(angle+thinknessHand))*handSize*ratioFat,Math.sin(Math.toRadians(angle+thinknessHand))*handSize*ratioFat]);
    fillPolygon(dc,pts,ratio);
  }
}
