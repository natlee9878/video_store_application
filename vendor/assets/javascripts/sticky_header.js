/*!
 * StickyTableHeaders 0.1.24 (2018-01-14 23:29)
 * MIT licensed
 * Copyright (C) Jonas Mosbech - https://github.com/jmosbech/StickyTableHeaders
 */
!function (e, i, t) {
  "use strict";
  var o = "stickyTableHeaders", n = 0, d = {
    fixedOffset: 0,
    leftOffset: 0,
    marginTop: 0,
    objDocument: document,
    objHead: "head",
    objWindow: i,
    scrollableArea: i,
    cacheHeaderHeight: !1,
    zIndex: 3
  };
  e.fn[o] = function (t) {
    return this.each(function () {
      var l = e.data(this, "plugin_" + o);
      l ? "string" == typeof t ? l[t].apply(l) : l.updateOptions(t) : "destroy" !== t && e.data(this, "plugin_" + o, new function (t, l) {
        var a = this;
        a.$el = e(t), a.el = t, a.id = n++, a.$el.bind("destroyed", e.proxy(a.teardown, a)), a.$clonedHeader = null, a.$originalHeader = null, a.cachedHeaderHeight = null, a.isSticky = !1, a.hasBeenSticky = !1, a.leftOffset = null, a.topOffset = null, a.init = function () {
          a.setOptions(l), a.$el.each(function () {
            var i = e(this);
            i.css("padding", 0), a.$originalHeader = e("thead:first", this), a.$clonedHeader = a.$originalHeader.clone(), i.trigger("clonedHeader." + o, [a.$clonedHeader]), a.$clonedHeader.addClass("tableFloatingHeader"), a.$clonedHeader.css({
              display: "none",
              opacity: 0
            }), a.$originalHeader.addClass("tableFloatingHeaderOriginal"), a.$originalHeader.after(a.$clonedHeader), a.$printStyle = e('<style type="text/css" media="print">.tableFloatingHeader{display:none !important;}.tableFloatingHeaderOriginal{position:static !important;}</style>'), a.$head.append(a.$printStyle)
          }), a.$clonedHeader.find("input, select").attr("disabled", !0), a.updateWidth(), a.toggleHeaders(), a.bind()
        }, a.destroy = function () {
          a.$el.unbind("destroyed", a.teardown), a.teardown()
        }, a.teardown = function () {
          a.isSticky && a.$originalHeader.css("position", "static"), e.removeData(a.el, "plugin_" + o), a.unbind(), a.$clonedHeader.remove(), a.$originalHeader.removeClass("tableFloatingHeaderOriginal"), a.$originalHeader.css("visibility", "visible"), a.$printStyle.remove(), a.el = null, a.$el = null
        }, a.bind = function () {
          a.$scrollableArea.on("scroll." + o, a.toggleHeaders), a.isWindowScrolling || (a.$window.on("scroll." + o + a.id, a.setPositionValues), a.$window.on("resize." + o + a.id, a.toggleHeaders)), a.$scrollableArea.on("resize." + o, a.toggleHeaders), a.$scrollableArea.on("resize." + o, a.updateWidth)
        }, a.unbind = function () {
          a.$scrollableArea.off("." + o, a.toggleHeaders), a.isWindowScrolling || (a.$window.off("." + o + a.id, a.setPositionValues), a.$window.off("." + o + a.id, a.toggleHeaders)), a.$scrollableArea.off("." + o, a.updateWidth)
        }, a.debounce = function (e, i) {
          var t = null;
          return function () {
            var o = this, n = arguments;
            clearTimeout(t), t = setTimeout(function () {
              e.apply(o, n)
            }, i)
          }
        }, a.toggleHeaders = a.debounce(function () {
          a.$el && a.$el.each(function () {
            var i, t, n, d = e(this),
              l = a.isWindowScrolling ? isNaN(a.options.fixedOffset) ? a.options.fixedOffset.outerHeight() : a.options.fixedOffset : a.$scrollableArea.offset().top + (isNaN(a.options.fixedOffset) ? 0 : a.options.fixedOffset),
              s = d.offset(), r = a.$scrollableArea.scrollTop() + l, c = a.$scrollableArea.scrollLeft(),
              f = a.isWindowScrolling ? r > s.top : l > s.top;
            f && (t = a.options.cacheHeaderHeight ? a.cachedHeaderHeight : a.$clonedHeader.height(), n = (a.isWindowScrolling ? r : 0) < s.top + d.height() - t - (a.isWindowScrolling ? 0 : l)), f && n ? (i = s.left - c + a.options.leftOffset, a.$originalHeader.css({
              position: "fixed",
              "margin-top": a.options.marginTop,
              top: 0,
              left: i,
              "z-index": a.options.zIndex
            }), a.leftOffset = i, a.topOffset = l, a.$clonedHeader.css("display", ""), a.isSticky || (a.isSticky = !0, a.updateWidth(), d.trigger("enabledStickiness." + o)), a.setPositionValues()) : a.isSticky && (a.$originalHeader.css("position", "static"), a.$clonedHeader.css("display", "none"), a.isSticky = !1, a.resetWidth(e("td,th", a.$clonedHeader), e("td,th", a.$originalHeader)), d.trigger("disabledStickiness." + o))
          })
        }, 0), a.setPositionValues = a.debounce(function () {
          var e = a.$window.scrollTop(), i = a.$window.scrollLeft();
          !a.isSticky || e < 0 || e + a.$window.height() > a.$document.height() || i < 0 || i + a.$window.width() > a.$document.width() || a.$originalHeader.css({
            top: a.topOffset - (a.isWindowScrolling ? 0 : e),
            left: a.leftOffset - (a.isWindowScrolling ? 0 : i)
          })
        }, 0), a.updateWidth = a.debounce(function () {
          if (a.isSticky) {
            a.$originalHeaderCells || (a.$originalHeaderCells = e("th,td", a.$originalHeader)), a.$clonedHeaderCells || (a.$clonedHeaderCells = e("th,td", a.$clonedHeader));
            var i = a.getWidth(a.$clonedHeaderCells);
            a.setWidth(i, a.$clonedHeaderCells, a.$originalHeaderCells), a.$originalHeader.css("width", a.$clonedHeader.width()), a.options.cacheHeaderHeight && (a.cachedHeaderHeight = a.$clonedHeader.height())
          }
        }, 0), a.getWidth = function (t) {
          var o = [];
          return t.each(function (t) {
            var n, d = e(this);
            if ("border-box" === d.css("box-sizing")) {
              var l = d[0].getBoundingClientRect();
              n = l.width ? l.width : l.right - l.left
            } else if ("collapse" === e("th", a.$originalHeader).css("border-collapse")) if (i.getComputedStyle) n = parseFloat(i.getComputedStyle(this, null).width); else {
              var s = parseFloat(d.css("padding-left")), r = parseFloat(d.css("padding-right")),
                c = parseFloat(d.css("border-width"));
              n = d.outerWidth() - s - r - c
            } else n = d.width();
            o[t] = n
          }), o
        }, a.setWidth = function (e, i, t) {
          i.each(function (i) {
            var o = e[i];
            t.eq(i).css({"min-width": o, "max-width": o})
          })
        }, a.resetWidth = function (i, t) {
          i.each(function (i) {
            var o = e(this);
            t.eq(i).css({"min-width": o.css("min-width"), "max-width": o.css("max-width")})
          })
        }, a.setOptions = function (i) {
          a.options = e.extend({}, d, i), a.$window = e(a.options.objWindow), a.$head = e(a.options.objHead), a.$document = e(a.options.objDocument), a.$scrollableArea = e(a.options.scrollableArea), a.isWindowScrolling = a.$scrollableArea[0] === a.$window[0]
        }, a.updateOptions = function (e) {
          a.setOptions(e), a.unbind(), a.bind(), a.updateWidth(), a.toggleHeaders()
        }, a.init()
      }(this, t))
    })
  }
}(jQuery, window);