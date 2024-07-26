import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
using Toybox.Time.Gregorian;

class Common {
  var battery, step, temperature;
  var phone_on, phone_off;
  var heart;

  //coords
  var xBattery, xStepFoot, xTemp, xPhone, xHeart, xDate;
  var sideTextColor;
  var backgroundColor;

  var yStepFoot, yTemp, yHeart, yPhone, yBattery;

  const DDMM = 0;
  const MMDD = 1;

  function getRotatedXY(
    x as Float,
    y as Float,
    xCenter as Number,
    yCenter as Float,
    angleDeg as Number
  ) as Array<Float> {
    var angleRad = Math.toRadians(angleDeg);
    var cos = Math.cos(angleRad);
    var sin = Math.sin(angleRad);

    var xResult = xCenter + (x - xCenter) * cos - (y - yCenter) * sin;
    var yResult = yCenter + (x - xCenter) * sin + (y - yCenter) * cos;
    return [xResult, yResult];
  }

  function CtoF(number as Number) as Number {
    if (
      System.getDeviceSettings().temperatureUnits == System.UNIT_METRIC ||
      number == 999
    ) {
      return number;
    } else {
      return (number * 9) / 5 + 32;
    }
  }

  function DimColor(color as Number, ratio as Float) {
    var red = (color >> 16) & 0xff;
    var green = (color >> 8) & 0xff;
    var blue = color & 0xff;

    //Calculate the dimmed values
    red = ((red * ratio) / 100).toNumber();
    green = ((green * ratio) / 100).toNumber();
    blue = ((blue * ratio) / 100).toNumber();

    return ColorRGB(red, green, blue);
  }
  function ColorRGB(red as Number, green as Number, blue as Number) as Number {
    return (red << 16) + (green << 8) + blue;
  }
  function CirclesAreIncluded(
    x1 as Float,
    y1 as Float,
    r1 as Float,
    x2 as Float,
    y2 as Float,
    r2 as Float,
    ratio as Float
  ) as Boolean {
    var distance = Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
    return distance - r2 + 2 * r2 * ratio <= r1;
  }

  var r;
  var xCenter;
  var yCenter;
  var offsetSquare;
  var top = yCenter;
  var bottom = yCenter;
  var right = xCenter;
  var left = xCenter;
  var width = right;
  var height = bottom;
  var xStep = width;
  var yStep = height;
  var font = Graphics.FONT_SYSTEM_XTINY;

  function onLayout(dc as Dc) {
    battery = Application.loadResource(Rez.Drawables.battery) as BitmapResource;
    step = Application.loadResource(Rez.Drawables.step) as BitmapResource;
    heart = Application.loadResource(Rez.Drawables.heart) as BitmapResource;
    temperature =
      Application.loadResource(Rez.Drawables.temperature) as BitmapResource;
    phone_on =
      Application.loadResource(Rez.Drawables.phone_on) as BitmapResource;
    phone_off =
      Application.loadResource(Rez.Drawables.phone_off) as BitmapResource;

    yStepFoot = dc.getHeight() / 2;
    yBattery = yStepFoot - battery.getHeight();
    yTemp = yStepFoot + step.getHeight();
    yHeart = yTemp + heart.getHeight();
    yPhone = yBattery - phone_on.getHeight();

    var yRatio = 1.4;
    var xRatio = 0.9;
    r = (0.8 * dc.getWidth()) / 2;
    xCenter = dc.getWidth() / 2;
    yCenter = dc.getHeight() / 2;
    offsetSquare = r / Math.sqrt(2);
    top = yCenter - offsetSquare * yRatio;
    bottom = yCenter + offsetSquare * yRatio;
    right = xCenter + offsetSquare * xRatio;
    left = xCenter - offsetSquare * xRatio;
    width = right - left;
    height = bottom - top;
    xStep = width / 11;
    yStep = height / 11;

    var rigthText =
      dc.getWidth() -
      dc.getTextDimensions("99999", font)[0] -
      dc.getTextDimensions(".", font)[0];

    xBattery = rigthText - battery.getWidth();
    xStepFoot = rigthText - step.getWidth();
    xTemp = rigthText - temperature.getWidth();
    xPhone = rigthText - phone_on.getWidth();
    xHeart = rigthText - heart.getWidth();
    xDate = 18;
  }

  function onUpdate(dc) {
    var c = new Common();

    if (getApp().getProperty("ShowSideText")) {
      var timeFormat = "$1$:$2$";
      var clockTime = System.getClockTime();
      var hours = clockTime.hour;
      if (!System.getDeviceSettings().is24Hour) {
        if (hours > 12) {
          hours = hours - 12;
        }
      } else {
        if (getApp().getProperty("UseMilitaryFormat")) {
          timeFormat = "$1$$2$";
          hours = hours.format("%02d");
        }
      }
      var timeString = Lang.format(timeFormat, [
        hours,
        clockTime.min.format("%02d"),
      ]);

      // Icons and datas on left
      var batteryString = System.getSystemStats().battery.toNumber() + "%";
      var stepString = "" + Toybox.ActivityMonitor.getInfo().steps;
      var now = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
      var date;
      if ((Properties.getValue("dateformat") as Number) == DDMM) {
        date =
          " " +
          now.day_of_week +
          " \n " +
          now.day +
          " " +
          now.month +
          " \n " +
          timeString +
          " ";
      } else {
        date =
          " " +
          now.day_of_week +
          ", \n " +
          now.month +
          " " +
          now.day +
          " \n " +
          timeString +
          " ";
      }

      MyWeather.refreshTemp();
      var currentCondition = MyWeather.getCurrentConditions();
      var temperatureString = "--°";
      if (currentCondition != null && currentCondition.temperature != null) {
        temperatureString =
          c.CtoF(MyWeather.getCurrentConditions().temperature) + "°";
      }
      var heartString = "--";
      var info = Toybox.Activity.getActivityInfo();
      heartString =
        info.currentHeartRate != null ? info.currentHeartRate : "--";
      dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);

      dc.fillRectangle(
        xPhone - 5,
        yPhone - phone_off.getHeight() / 2,
        200,
        yHeart - yPhone + heart.getHeight()
      );

      dc.drawBitmap2(xStepFoot, yStepFoot - step.getHeight() / 2, step, {
        :tintColor => sideTextColor,
      });
      dc.setColor(sideTextColor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        xStepFoot + step.getWidth(),
        yStepFoot,
        font,
        stepString,
        Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
      );

      dc.drawBitmap2(xBattery, yBattery - battery.getHeight() / 2, battery, {
        :tintColor => sideTextColor,
      });
      dc.drawText(
        xBattery + battery.getWidth(),
        yBattery,
        font,
        batteryString,
        Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
      );

      dc.drawBitmap2(xTemp, yTemp - temperature.getHeight() / 2, temperature, {
        :tintColor => sideTextColor,
      });
      dc.drawText(
        xTemp + temperature.getWidth(),
        yTemp,
        font,
        temperatureString,
        Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
      );

      if (System.getDeviceSettings().phoneConnected) {
        dc.drawBitmap2(xPhone, yPhone - phone_on.getHeight() / 2, phone_on, {
          :tintColor => sideTextColor,
        });
      } else {
        dc.drawBitmap2(xPhone, yPhone - phone_off.getHeight() / 2, phone_off, {
          :tintColor => sideTextColor,
        });
      }

      dc.drawBitmap2(xHeart, yHeart - heart.getHeight() / 2, heart, {
        :tintColor => sideTextColor,
      });
      dc.drawText(
        xHeart + heart.getWidth(),
        yHeart,
        font,
        heartString,
        Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
      );

      // date

      var dateDimention = dc.getTextDimensions(date, font);
      dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);

      dc.fillRectangle(
        0,
        dc.getHeight() / 2 - dateDimention[1] / 2,
        dateDimention[0],
        dateDimention[1]
      );

      dc.setColor(sideTextColor, Graphics.COLOR_TRANSPARENT);

      dc.drawText(
         dateDimention[0] / 2,
        dc.getHeight() / 2,
        font,
        date,
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
      );
    }
  }
}
