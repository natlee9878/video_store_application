var Cookie = {
  getCookie: function(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
      var c = ca[i];
      while (c.charAt(0) == ' ') c = c.substring(1);
      if (c.indexOf(name) == 0) return c.substring(name.length, c.length);
    }
    return "";
  },

  createCookie: function(cname, value, days) {
    if (days) {
      var FUTURE_TIME = days*24*60*60*1000;

      var date = new Date();
      date.setTime(date.getTime() + FUTURE_TIME);
      var expires = "; expires=" + date;
    } else {
      var expires = "";
    }
    document.cookie = cname + "=" + value + expires + "; path=/";
  },

  eraseCookie: function(cname) {
    Cookie.createCookie(cname, "", -1);
  },

  areCookiesEnabled: function () {
    var r = false;
    Cookie.createCookie("testing", "Hello", 1);
    if (Cookie.getCookie("testing") != "") {
      r = true;
      Cookie.eraseCookie("testing");
    }
    return r;
  }
};

