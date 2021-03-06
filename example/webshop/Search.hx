package webshop;

import jQuery.JQuery;
import js.html.Event;
import js.html.InputElement;
import js.html.KeyboardEvent;
import mithril.M;
import webshop.models.*;
using Lambda;
using StringTools;

class Search implements View
{
    @prop var results : Array<Product>;

    public function new() {
        this.results = M.prop([]);
    }

    function search(phrase : String) {
        if(phrase.length < 2) {
            results([]);
            return;
        }
        phrase = phrase.toLowerCase();
        Product.all().then(function(products : Array<Product>) {
            products = products.filter(function(p) {
                return p.name.toLowerCase().indexOf(phrase) >= 0;
            });
            results(products);
            M.redraw();
        });
    }

    function closeEvent(e : Event) {
        // Close cart if clicking outside it.
        if(new JQuery(e.target).parents("#search").length > 0) return;
        results([]);
        M.redraw();
    }

    public function view() {
        [
            m("input.form-control", {
                placeholder: "Search...",
                oninput: M.withAttr("value", search),
                onfocus: M.withAttr("value", search)
            }),
            m("ul.dropdown-menu.dropdown-menu-right", {
                role: "menu",
                style: {display: results().length > 0 ? "block" : "none"},
                config: function(el, isInit) {
                    if(isInit) return;
                    new JQuery('html').on("click.closeSearch", closeEvent);
                }
            }, results().map(function(p) {
                m("li", {role: "presentation"},
                    m("a", {
                        role: "menuitem",
                        tabindex: -1,
                        href: '/product/${p.id}',
                        config: M.route
                    }, p.name)
                );
            }))
        ];
    }
}
