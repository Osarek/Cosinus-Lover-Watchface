using Toybox.Time;
using Toybox.Lang;
using Toybox.Position;
import Toybox.System;

class MyWeather {
  static var currentCondition;
  static var dailyForecast;
  static var hourlyForecast;

  // static var yesterdaySunset, todaySunset;
  // static var todaySunrise, tomorrowSunrise;

  static var nextRefreshTimeTemp = Time.now();
  static var nextRefreshTimeSunrine = Time.now();
  static var refreshPeriod = 60;

  static var registerCurrent = false;
  static var registerDaily = false;
  static var registerHourly = false;

  static function refreshTemp() {
    if (nextRefreshTimeTemp.lessThan(Time.now())) {
      if (registerCurrent) {
        currentCondition = Toybox.Weather.getCurrentConditions();
      }
      // if (registerDaily) {
      //   dailyForecast = Toybox.Weather.getDailyForecast();
      // }
      // if (registerHourly) {
      //   hourlyForecast = Toybox.Weather.getHourlyForecast();
      // }

      nextRefreshTimeTemp = Time.now().add(new Time.Duration(refreshPeriod));
    }
  }

  // static function validPosition(positionInfo as Position.Info) {
  //   if (positionInfo.position == null) {
  //     return false;
  //   } else {
  //     return (
  //       positionInfo.position.toDegrees()[0] != (180).toFloat() &&
  //       positionInfo.position.toDegrees()[1] != (180).toFloat()
  //     );
  //   }
  // }

  // static function refreshSunrise() {
  //   var positionInfo = Position.getInfo();

  //   if (
  //     nextRefreshTimeSunrine.lessThan(Time.now()) &&
  //     validPosition(positionInfo)
  //   ) {
  //     var today = Time.today();

  //     yesterdaySunset = Toybox.Weather.getSunset(
  //       positionInfo.position,
  //       Time.today().add(new Time.Duration(-Time.Gregorian.SECONDS_PER_DAY))
  //     );
  //     todaySunrise = Toybox.Weather.getSunrise(positionInfo.position, today);
  //     todaySunset = Toybox.Weather.getSunset(positionInfo.position, today);

  //     tomorrowSunrise = Toybox.Weather.getSunrise(
  //       positionInfo.position,
  //       Time.today().add(new Time.Duration(Time.Gregorian.SECONDS_PER_DAY))
  //     );
  //   }
  // }
  static function getCurrentConditions() {
    refreshTemp();
    return currentCondition;
  }
  // static function getHourlyForecast() {
  //   refreshTemp();
  //   return hourlyForecast;
  // }
  // static function getDailyForecast() {
  //   refreshTemp();
  //   return dailyForecast;
  // }

  // static function getYesterdaySunset() as Time.Moment? {
  //   refreshSunrise();
  //   return yesterdaySunset;
  // }
  // static function getTodaySunset() as Time.Moment? {
  //   refreshSunrise();
  //   return todaySunset;
  // }
  // static function getTodaySunrise() as Time.Moment? {
  //   refreshSunrise();
  //   return todaySunrise;
  // }
  // static function getTomorrowSunrise() as Time.Moment? {
  //   refreshSunrise();
  //   return tomorrowSunrise;
  // }
}
