(function (d, i) {
	d.uniform = {
		options: {
			selectClass: "selector",
			radioClass: "radio",
			checkboxClass: "checker",
			fileClass: "uploader",
			filenameClass: "filename",
			fileBtnClass: "action",
			fileDefaultText: "No file selected",
			fileBtnText: "Choose File",
			checkedClass: "checked",
			focusClass: "focus",
			disabledClass: "disabled",
			buttonClass: "button",
			activeClass: "active",
			hoverClass: "hover",
			useID: !0,
			idPrefix: "uniform",
			resetSelector: !1,
			autoHide: !0,
			selectAutoWidth: !1
		},
		elements: []
	};
	//d.support.selectOpacity = d.browser.msie && 7 > d.browser.version ? !1 : !0;
	d.support.selectOpacity = !0;
	d.fn.uniform = function (b) {
		function j(a) {
			var c = d("<div>"),
				e = d("<span>"),
				f;
			c.addClass(b.buttonClass);
			b.useID && a.attr("id") && c.attr("id", b.idPrefix + "-" + a.attr("id"));
			a.is("a, button") ? f = a.text() : a.is(":submit, :reset, input[type=button]") && (f = a.attr("value"));
			f = f || (a.is(":reset") ? "Reset" : "Submit");
			e.text(f);
			a.css("display", "none");
			a.wrap(c);
			a.wrap(e);
			c = a.closest("div");
			e = a.closest("span");
			a.is(":disabled") && c.addClass(b.disabledClass);
			c.bind("mouseenter.uniform", function () {
				c.addClass(b.hoverClass)
			}).bind("mouseleave.uniform",
				function () {
					c.removeClass(b.hoverClass);
					c.removeClass(b.activeClass)
				}).bind("mousedown.uniform touchbegin.uniform", function () {
				c.addClass(b.activeClass)
			}).bind("mouseup.uniform touchend.uniform", function () {
				c.removeClass(b.activeClass)
			}).bind("click.uniform touchend.uniform", function (b) {
				d(b.target).is("span, div") && (a[0].dispatchEvent ? (b = document.createEvent("MouseEvents"), b.initEvent("click", !0, !0), a[0].dispatchEvent(b)) : a.click())
			});
			a.bind("focus.uniform", function () {
				c.addClass(b.focusClass)
			}).bind("blur.uniform",
				function () {
					c.removeClass(b.focusClass)
				});
			d.uniform.noSelect(c);
			h(a)
		}

		function k(a) {
			var c = d("<div />"),
				e = d("<span />"),
				f = a.width();
			"none" == a.css("display") && b.autoHide && c.hide();
			c.addClass(b.selectClass);
			if (b.selectAutoWidth) {
				var g = c.width(),
					l = e.width() - f;
				c.width(g - l + 25);
				a.width(f + 32);
				a.css("left", "2px");
				e.width(f)
			}
			b.useID && a.attr("id") && c.attr("id", b.idPrefix + "-" + a.attr("id"));
			g = a.find(":selected:first");
			g.length || (g = a.find("option:first"));
			e.html(g.html());
			a.css("opacity", 0);
			a.wrap(c);
			a.before(e);
			c = a.parent("div");
			e = a.siblings("span");
			b.selectAutoWidth && (g = parseInt(c.css("paddingLeft"), 10), e.width(f - g - 15), a.width(f + g), a.css("min-width", f + g + "px"), c.width(f + g));
			a.bind("change.uniform", function () {
				e.html(a.find(":selected").html());
				c.removeClass(b.activeClass)
			}).bind("focus.uniform", function () {
				c.addClass(b.focusClass)
			}).bind("blur.uniform", function () {
				c.removeClass(b.focusClass);
				c.removeClass(b.activeClass)
			}).bind("mousedown.uniform touchbegin.uniform", function () {
				c.addClass(b.activeClass)
			}).bind("mouseup.uniform touchend.uniform",
				function () {
					c.removeClass(b.activeClass)
				}).bind("click.uniform touchend.uniform", function () {
				c.removeClass(b.activeClass)
			}).bind("mouseenter.uniform", function () {
				c.addClass(b.hoverClass)
			}).bind("mouseleave.uniform", function () {
				c.removeClass(b.hoverClass);
				c.removeClass(b.activeClass)
			}).bind("keyup.uniform", function () {
				e.html(a.find(":selected").html())
			});
			a.is(":disabled") && c.addClass(b.disabledClass);
			d.uniform.noSelect(e);
			h(a)
		}

		function m(a) {
			var c = d("<div />"),
				e = d("<span />");
			"none" == a.css("display") && b.autoHide &&
				c.hide();
			c.addClass(b.checkboxClass);
			b.useID && a.attr("id") && c.attr("id", b.idPrefix + "-" + a.attr("id"));
			a.wrap(c);
			a.wrap(e);
			e = a.parent();
			c = e.parent();
			a.css("opacity", 0).bind("focus.uniform", function () {
				c.addClass(b.focusClass)
			}).bind("blur.uniform", function () {
				c.removeClass(b.focusClass)
			}).bind("click.uniform touchend.uniform", function () {
				a.is(":checked") ? (a.attr("checked", "checked"), e.addClass(b.checkedClass)) : (a.removeAttr("checked"), e.removeClass(b.checkedClass))
			}).bind("mousedown.uniform touchbegin.uniform",
				function () {
					c.addClass(b.activeClass)
				}).bind("mouseup.uniform touchend.uniform", function () {
				c.removeClass(b.activeClass)
			}).bind("mouseenter.uniform", function () {
				c.addClass(b.hoverClass)
			}).bind("mouseleave.uniform", function () {
				c.removeClass(b.hoverClass);
				c.removeClass(b.activeClass)
			});
			a.is(":checked") && (a.attr("checked", "checked"), e.addClass(b.checkedClass));
			a.is(":disabled") && c.addClass(b.disabledClass);
			h(a)
		}

		function n(a) {
			var c = d("<div />"),
				e = d("<span />");
			"none" == a.css("display") && b.autoHide && c.hide();
			c.addClass(b.radioClass);
			b.useID && a.attr("id") && c.attr("id", b.idPrefix + "-" + a.attr("id"));
			a.wrap(c);
			a.wrap(e);
			e = a.parent();
			c = e.parent();
			a.css("opacity", 0).bind("focus.uniform", function () {
				c.addClass(b.focusClass)
			}).bind("blur.uniform", function () {
				c.removeClass(b.focusClass)
			}).bind("click.uniform touchend.uniform", function () {
				if (a.is(":checked")) {
					var c = b.radioClass.split(" ")[0];
					d("." + c + " span." + b.checkedClass + ":has([name='" + a.attr("name") + "'])").removeClass(b.checkedClass);
					e.addClass(b.checkedClass)
				} else e.removeClass(b.checkedClass)
			}).bind("mousedown.uniform touchend.uniform",
				function () {
					a.is(":disabled") || c.addClass(b.activeClass)
				}).bind("mouseup.uniform touchbegin.uniform", function () {
				c.removeClass(b.activeClass)
			}).bind("mouseenter.uniform touchend.uniform", function () {
				c.addClass(b.hoverClass)
			}).bind("mouseleave.uniform", function () {
				c.removeClass(b.hoverClass);
				c.removeClass(b.activeClass)
			});
			a.is(":checked") && e.addClass(b.checkedClass);
			a.is(":disabled") && c.addClass(b.disabledClass);
			h(a)
		}

		function o(a) {
			var c = d("<div />"),
				e = d("<span>" + b.fileDefaultText + "</span>"),
				f = d("<span>" +
					b.fileBtnText + "</span>");
			"none" == a.css("display") && b.autoHide && c.hide();
			c.addClass(b.fileClass);
			e.addClass(b.filenameClass);
			f.addClass(b.fileBtnClass);
			b.useID && a.attr("id") && c.attr("id", b.idPrefix + "-" + a.attr("id"));
			a.wrap(c);
			a.after(f);
			a.after(e);
			c = a.closest("div");
			e = a.siblings("." + b.filenameClass);
			f = a.siblings("." + b.fileBtnClass);
			a.attr("size") || a.attr("size", c.width() / 10);
			var g = function () {
				var c = a.val();
				"" === c ? c = b.fileDefaultText : (c = c.split(/[\/\\]+/), c = c[c.length - 1]);
				e.text(c)
			};
			g();
			a.css("opacity",
				0).bind("focus.uniform", function () {
				c.addClass(b.focusClass)
			}).bind("blur.uniform", function () {
				c.removeClass(b.focusClass)
			}).bind("mousedown.uniform", function () {
				a.is(":disabled") || c.addClass(b.activeClass)
			}).bind("mouseup.uniform", function () {
				c.removeClass(b.activeClass)
			}).bind("mouseenter.uniform", function () {
				c.addClass(b.hoverClass)
			}).bind("mouseleave.uniform", function () {
				c.removeClass(b.hoverClass);
				c.removeClass(b.activeClass)
			});
			//d.browser.msie ? a.bind("click.uniform.ie7", function () { setTimeout(g, 0) }) : a.bind("change.uniform", g);
			a.bind("change.uniform", g);
			a.is(":disabled") && c.addClass(b.disabledClass);
			d.uniform.noSelect(e);
			d.uniform.noSelect(f);
			h(a)
		}

		function h(a) {
			a.data("uniformed", "true");
			elem = a.get();
			1 < elem.length ? d.each(elem, function (c, a) {
				d.uniform.elements.push(a)
			}) : d.uniform.elements.push(elem)
		}
		var p = this,
			b = d.extend({}, d.uniform.options, b);
		!1 !== b.resetSelector && d(b.resetSelector).mouseup(function () {
			window.setTimeout(function () {
				d.uniform.update(p)
			}, 10)
		});
		d.uniform.restore = function (a) {
			a == i && (a = d(d.uniform.elements));
			d(a).each(function () {
				if (d(this).data("uniformed")) {
					d(this).is(":checkbox") ?
						d(this).unwrap().unwrap() : d(this).is("select") ? (d(this).siblings("span").remove(), d(this).unwrap()) : d(this).is(":radio") ? d(this).unwrap().unwrap() : d(this).is(":file") ? (d(this).siblings("span").remove(), d(this).unwrap()) : d(this).is("button, :submit, :reset, a, input[type='button']") && d(this).unwrap().unwrap();
					d(this).unbind(".uniform");
					d(this).css("opacity", "1");
					var c = d.inArray(d(a), d.uniform.elements);
					d.uniform.elements.splice(c, 1);
					d(this).removeData("uniformed")
				}
			})
		};
		d.uniform.noSelect = function (a) {
			var c =
				function () {
					return !1
				};
			d(a).each(function () {
				this.onselectstart = this.ondragstart = c;
				d(this).mousedown(c).css({
					MozUserSelect: "none"
				})
			})
		};
		d.uniform.update = function (a) {
			a == i && (a = d(d.uniform.elements));
			a = d(a);
			a.each(function () {
				var a = d(this);
				if (a.data("uniformed"))
					if (a.is("select")) {
						var e = a.siblings("span"),
							f = a.parent("div");
						f.removeClass(b.hoverClass + " " + b.focusClass + " " + b.activeClass);
						e.html(a.find(":selected").html());
						a.is(":disabled") ? f.addClass(b.disabledClass) : f.removeClass(b.disabledClass)
					} else a.is(":checkbox") ?
						(e = a.closest("span"), f = a.closest("div"), f.removeClass(b.hoverClass + " " + b.focusClass + " " + b.activeClass), e.removeClass(b.checkedClass), a.is(":checked") && e.addClass(b.checkedClass), a.is(":disabled") ? f.addClass(b.disabledClass) : f.removeClass(b.disabledClass)) : a.is(":radio") ? (e = a.closest("span"), f = a.closest("div"), f.removeClass(b.hoverClass + " " + b.focusClass + " " + b.activeClass), e.removeClass(b.checkedClass), a.is(":checked") && e.addClass(b.checkedClass), a.is(":disabled") ? f.addClass(b.disabledClass) : f.removeClass(b.disabledClass)) :
						a.is(":file") ? (e = a.parent("div"), f = a.siblings("." + b.filenameClass), btnTag = a.siblings(b.fileBtnClass), e.removeClass(b.hoverClass + " " + b.focusClass + " " + b.activeClass), f.text(a.val()), a.is(":disabled") ? e.addClass(b.disabledClass) : e.removeClass(b.disabledClass)) : a.is(":submit, :reset, button, a, input[type='button']") && (e = a.closest("div"), e.removeClass(b.hoverClass + " " + b.focusClass + " " + b.activeClass), a.is(":disabled") ? e.addClass(b.disabledClass) : e.removeClass(b.disabledClass))
			})
		};
		return this.each(function () {
			var a =
				d(this);
			if (!a.data("uniformed") && d.support.selectOpacity)
				if (a.is("select")) {
					if (!this.multiple) {
						var b = a.attr("size");
						(b == i || 1 >= b) && k(a)
					}
				} else a.is(":checkbox") ? m(a) : a.is(":radio") ? n(a) : a.is(":file") ? o(a) : a.is(":text, :password, input[type='email'], input[type='search'], input[type='tel'], input[type='url'], input[type='datetime'], input[type='date'], input[type='month'], input[type='week'], input[type='time'], input[type='datetime-local'], input[type='number'], input[type='color']") ? (a.addClass(a.attr("type")),
					h(a)) : a.is("textarea") ? (a.addClass("uniform"), h(a)) : a.is("a, :submit, :reset, button, input[type='button']") && j(a)
		})
	}
})(jQuery);

