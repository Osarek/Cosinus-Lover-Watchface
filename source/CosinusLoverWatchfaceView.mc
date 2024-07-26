import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Application.Properties;

class CosinusLoverWatchfaceView extends WatchUi.WatchFace {
  var animator;
  var ratio = 1;
  var doFullRedrawOnPartial = true;

  var common;

  function initialize() {
    WatchFace.initialize();
    // animator = new Animator();
       MyWeather.registerCurrent = true;
    common = new Common();
  }

  // Load your resources here
  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.WatchFace(dc));

        common.onLayout(dc);

  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() as Void {
    // animator.myTimer.start(method(:timerCallback), animator.getTimerMs(), true);
  }

  function onPartialUpdate(dc) as Void {
    if (doFullRedrawOnPartial) {
      onUpdateFromPartial(dc);
    }
    doFullRedrawOnPartial = false;
  }

  function onUpdateFromPartial(dc as Dc) as Void {
    onUpdate(dc);
  }

  // Update the view
  function onUpdate(dc as Dc) as Void {
    View.onUpdate(dc);
        common.onUpdate(dc);

    // animator.timerCounter++;

    var TimeSegmentsColor =
      Properties.getValue("TimeSegments").toNumberWithBase(16);

    var HourHandColor =
      Properties.getValue("HourHandColor").toNumberWithBase(16);
    var MinHandColor = Properties.getValue("MinHandColor").toNumberWithBase(16);
    var SecHandColor = Properties.getValue("SecHandColor").toNumberWithBase(16);
    var CosinusColor = Properties.getValue("CosinusColor").toNumberWithBase(16);
    var SinusColor = getApp().getProperty("SinusColor").toNumberWithBase(16);
    var AngleColor = getApp().getProperty("AngleColor").toNumberWithBase(16);
    var AxisColor = getApp().getProperty("AxisColor").toNumberWithBase(16);
    var Cosinushand = getApp().getProperty("Cosinushand");
    var ShowSeconds = getApp().getProperty("ShowSeconds");

    dc.setPenWidth(1);

    // var angle = -animator.timerCounter;

    var angleHour =
      -90 +
      ((System.getClockTime().hour % 12) * 360) / 12 +
      (System.getClockTime().min * 360) / (60 * 12); //+ clockTime.sec * maxSlot;
    var angleMin =
      -90 +
      (System.getClockTime().min * 360) / 60 +
      (System.getClockTime().sec * 360) / (60 * 60); //+ clockTime.sec * maxSlot;
    var angleSec = -90 + (System.getClockTime().sec * 360) / 60; //+ clockTime.sec * maxSlot;

    var sinMin = Math.sin(Math.toRadians(angleMin));
    var cosMin = Math.cos(Math.toRadians(angleMin));
    var sinHour = Math.sin(Math.toRadians(angleHour));
    var cosHour = Math.cos(Math.toRadians(angleHour));
    var sinSec = Math.sin(Math.toRadians(angleSec));
    var cosSec = Math.cos(Math.toRadians(angleSec));

    var handHourSize = 0.4;
    var handMinSize = 0.9;
    var handSecSize = 1.0;
    var segmentRatio = 0.95;

    var angleChoosen = 0;
    var handSize = 0;
    var cos = 0;
    var sin = 0;

    switch (Cosinushand) {
      case 1:
        angleChoosen = angleHour;
        handSize = handHourSize;
        cos = cosHour;
        sin = sinHour;
        break;
      case 2:
        angleChoosen = angleMin;
        handSize = handMinSize;
        cos = cosMin;
        sin = sinMin;

        break;
      case 3:
        angleChoosen = angleSec;
        handSize = handSecSize;
        cos = cosSec;
        sin = sinSec;

        break;
    }

    // Segments
    var angleOne = 360 / 12;
    for (var slot = 0; slot <= 12; slot++) {
      var angleHourSegment = (slot * 360) / 12; //+ clockTime.sec * maxSlot;

      var x = Math.sin(Math.toRadians(angleHourSegment));
      var y = Math.cos(Math.toRadians(angleHourSegment));

      dc.setColor(TimeSegmentsColor, Graphics.COLOR_TRANSPARENT);

      drawLine(dc, x, y, x * segmentRatio, y * segmentRatio, 1.0);
    }

    //Hands
    // dc.setPenWidth(3);
    // drawLine(dc, 0, 0, cosMin * handMinSize, sinMin * handMinSize,handMinSize);
    // drawLine(dc, 0, 0, cosHour * handHourSize, sinHour * handHourSize,handMinSize);

    var thinknessHand = 2.5;
    var ratioFat = 0.8;

    dc.setColor(MinHandColor, Graphics.COLOR_TRANSPARENT);

    drawHand(
      dc,
      cosMin,
      sinMin,
      angleMin,
      thinknessHand,
      ratioFat,
      handMinSize,
      1.0
    );
    dc.setColor(HourHandColor, Graphics.COLOR_TRANSPARENT);

    drawHand(
      dc,
      cosHour,
      sinHour,
      angleHour,
      thinknessHand,
      ratioFat,
      handHourSize,
      1.0
    );

    if (ShowSeconds) {
      dc.setColor(SecHandColor, Graphics.COLOR_TRANSPARENT);

      drawHand(dc, cosSec, sinSec, angleSec, 0.8, 0.8, handSecSize, 1.0);
    }

    if (Cosinushand != 0) {
      dc.setColor(AxisColor, Graphics.COLOR_TRANSPARENT);

      // dc.setPenWidth(1);

      var step = 0.25;
      //horizontal
      drawLine(dc, -1, 0, 1, 0, handSize);
      for (var i = -1; i <= 1; i = i + 2 * step) {
        drawLine(dc, i, 0, i, -0.06, handSize);
        drawLine(dc, i + step, 0, i + step, -0.03, handSize);
      }

      //vertical
      drawLine(dc, 0, -1, 0, 1, handSize);
      for (var i = -1; i <= 1; i = i + 2 * step) {
        drawLine(dc, 0, i, 0.06, i, handSize);
        drawLine(dc, 0, i + step, 0.03, i + step, handSize);
      }

      var just180;
      var just360;

      if (Cosinushand == 1) {
        just180 = Graphics.TEXT_JUSTIFY_RIGHT;
        just360 = Graphics.TEXT_JUSTIFY_LEFT;
      } else {
        just180 = Graphics.TEXT_JUSTIFY_LEFT;
        just360 = Graphics.TEXT_JUSTIFY_RIGHT;
      }

      drawText(
        dc,
        0,
        -0.6,
        Graphics.FONT_SYSTEM_XTINY,
        System.getClockTime().min + "",
        Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_RIGHT,
        handMinSize
      );
      drawText(
        dc,
        0,
        -0.9,
        Graphics.FONT_SYSTEM_XTINY,
        "90° ",
        Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_RIGHT,
        handSize
      );
      drawText(
        dc,
        0,
        -0.9,
        Graphics.FONT_SYSTEM_XTINY,
        " π/2 ",
        Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_LEFT,
        handSize
      );

      drawText(
        dc,
        -1,
        -0.1,
        Graphics.FONT_SYSTEM_XTINY,
        "  π ",
        Graphics.TEXT_JUSTIFY_VCENTER | just180,
        handSize
      );
      drawText(
        dc,
        -1,
        0.1,
        Graphics.FONT_SYSTEM_XTINY,
        "180°",
        Graphics.TEXT_JUSTIFY_VCENTER | just180,
        handSize
      );

      drawText(
        dc,
        1,
        -0.1,
        Graphics.FONT_SYSTEM_XTINY,
        "360°",
        Graphics.TEXT_JUSTIFY_VCENTER | just360,
        handSize
      );
      drawText(
        dc,
        1,
        0.1,
        Graphics.FONT_SYSTEM_XTINY,
        "2π  ",
        Graphics.TEXT_JUSTIFY_VCENTER | just360,
        handSize
      );

      drawText(
        dc,
        0,
        0.9,
        Graphics.FONT_SYSTEM_XTINY,
        " 3π/2 ",
        Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_RIGHT,
        handSize
      );
      drawText(
        dc,
        0,
        0.9,
        Graphics.FONT_SYSTEM_XTINY,
        " 270°",
        Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_LEFT,
        handSize
      );

      //Angles

      if (angleChoosen != angleSec || ShowSeconds != false) {
        dc.setColor(AngleColor, Graphics.COLOR_TRANSPARENT);

        drawText(
          dc,
          0.2,
          -0.2,
          Graphics.FONT_SYSTEM_XTINY,
          ((-angleChoosen + 360 * 2) % 360) + "°",
          Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER,
          handHourSize
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
            handSize
          );
        }

        //Cosinus - sinus
        dc.setColor(CosinusColor, Graphics.COLOR_TRANSPARENT);

        drawLine(dc, cos, 0, cos, sin, handSize);

        var alignCos = Graphics.TEXT_JUSTIFY_CENTER;
        var alignSin = Graphics.TEXT_JUSTIFY_RIGHT;

        if (cos < 0) {
          alignSin = Graphics.TEXT_JUSTIFY_LEFT;
        }

        var yCosText = 0.2;
        var xSinText = -0.05;
        if (cos < 0) {
          xSinText = -xSinText;
        }
        if (sin > 0) {
          yCosText = -yCosText;
        }

        drawText(
          dc,
          cos,
          yCosText,
          Graphics.FONT_SYSTEM_XTINY,
          "cos\n" + cos.format("%.2f"),
          Graphics.TEXT_JUSTIFY_VCENTER | alignCos,
          handHourSize
        );

        dc.setColor(SinusColor, Graphics.COLOR_TRANSPARENT);

        drawLine(dc, 0, sin, cos, sin, handSize);
        drawText(
          dc,
          xSinText,
          sin,
          Graphics.FONT_SYSTEM_XTINY,
          "sin\n" + sin.format("%.2f"),
          Graphics.TEXT_JUSTIFY_VCENTER | alignSin,
          handHourSize
        );
      }
    }
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

  function fillPolygon(
    dc as Dc,
    pts as Lang.Array<Lang.Array<Lang.Numeric> >,
    ratio as Float
  ) as Void {
    for (var i = 0; i < pts.size(); i++) {
      pts[i][0] = xy(dc, pts[i][0], ratio);
      pts[i][1] = xy(dc, pts[i][1], ratio);
    }

    dc.fillPolygon(pts);
  }

  function xy(dc as Dc, xy as Number, secondaryRatio as Float) {
    return (
      (ratio * secondaryRatio * (xy * dc.getWidth())) / 2 + dc.getWidth() / 2
    );
  }

  function crop(outer as Number, inner as Number, ratio as Float) as Number {
    return ((outer - inner).toFloat() * ratio).toNumber() + inner;
  }

  function drawHand(
    dc as Dc,
    cos as Float,
    sin as Float,
    angle as Number,
    thinknessHand as Float,
    ratioFat as Float,
    handSize as Float,
    ratio as Float
  ) {
    var pts = [];
    pts.add([0, 0]);
    pts.add([
      Math.cos(Math.toRadians(angle - thinknessHand)) * handSize * ratioFat,
      Math.sin(Math.toRadians(angle - thinknessHand)) * handSize * ratioFat,
    ]);
    pts.add([cos * handSize, sin * handSize]);
    pts.add([
      Math.cos(Math.toRadians(angle + thinknessHand)) * handSize * ratioFat,
      Math.sin(Math.toRadians(angle + thinknessHand)) * handSize * ratioFat,
    ]);
    fillPolygon(dc, pts, ratio);
  }
}
