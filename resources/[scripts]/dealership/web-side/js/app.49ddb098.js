(function(e){function t(t){for(var r,a,c=t[0],o=t[1],u=t[2],f=0,d=[];f<c.length;f++)a=c[f],Object.prototype.hasOwnProperty.call(i,a)&&i[a]&&d.push(i[a][0]),i[a]=0;for(r in o)Object.prototype.hasOwnProperty.call(o,r)&&(e[r]=o[r]);l&&l(t);while(d.length)d.shift()();return s.push.apply(s,u||[]),n()}function n(){for(var e,t=0;t<s.length;t++){for(var n=s[t],r=!0,c=1;c<n.length;c++){var o=n[c];0!==i[o]&&(r=!1)}r&&(s.splice(t--,1),e=a(a.s=n[0]))}return e}var r={},i={app:0},s=[];function a(t){if(r[t])return r[t].exports;var n=r[t]={i:t,l:!1,exports:{}};return e[t].call(n.exports,n,n.exports,a),n.l=!0,n.exports}a.m=e,a.c=r,a.d=function(e,t,n){a.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:n})},a.r=function(e){"undefined"!==typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},a.t=function(e,t){if(1&t&&(e=a(e)),8&t)return e;if(4&t&&"object"===typeof e&&e&&e.__esModule)return e;var n=Object.create(null);if(a.r(n),Object.defineProperty(n,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var r in e)a.d(n,r,function(t){return e[t]}.bind(null,r));return n},a.n=function(e){var t=e&&e.__esModule?function(){return e["default"]}:function(){return e};return a.d(t,"a",t),t},a.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},a.p="";var c=window["webpackJsonp"]=window["webpackJsonp"]||[],o=c.push.bind(c);c.push=t,c=c.slice();for(var u=0;u<c.length;u++)t(c[u]);var l=o;s.push([0,"chunk-vendors"]),n()})({0:function(e,t,n){e.exports=n("56d7")},"0aae":function(e,t,n){e.exports=n.p+"img/checked.db709ceb.svg"},"0f45":function(e,t,n){e.exports=n.p+"img/trunk.b2f31973.svg"},"56d7":function(e,t,n){"use strict";n.r(t);n("e260"),n("e6cf"),n("cca6"),n("a79d");var r=n("2b0e"),i=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticStyle:{display:"none"},attrs:{id:"app"}},[n("div",{staticClass:"content"},[n("FilterMenu"),n("div",{staticClass:"vehicles-container"},e._l(e.vehicles,(function(t,r){return n("Vehicle",{key:r,style:{display:e.vehicleAppear(t)?"flex":"none"},attrs:{data:t},nativeOn:{click:function(n){return e.selectVehicle(t)}}})})),1),n("Apresentation")],1)])},s=[],a=n("1da1"),c=(n("96cf"),n("e9c4"),n("d3b7"),n("b0c0"),function(){var e=this,t=e.$createElement,r=e._self._c||t;return e.GLOBAL.selectedVehicle.price?r("div",{staticClass:"apresentation-container fade"},[r("h1",{staticClass:"name"},[e._v(e._s(e.GLOBAL.selectedVehicle.name))]),r("div",{staticClass:"infos-container",class:"Possuidos"==e.GLOBAL.filterType?"doubleGrid":"tripleGrid"},[r("div",{staticClass:"info fade"},[r("img",{attrs:{src:n("cf44")}}),r("h1",[e._v(e._s(e.UTILS.formatNumberToMoney(e.GLOBAL.selectedVehicle.price)))]),r("p",[e._v("VALOR")])]),r("div",{staticClass:"info fade"},[r("img",{attrs:{src:n("90e32")}}),r("h1",[e._v(e._s("Possuidos"==e.GLOBAL.filterType?e.GLOBAL.selectedVehicle.tax:e.UTILS.formatNumberToMoney(e.GLOBAL.selectedVehicle.tax)))]),r("p",[e._v("TAXA SEMANAL")])]),"Possuidos"!=e.GLOBAL.filterType?r("div",{staticClass:"info fade"},[r("img",{attrs:{src:n("0f45")}}),r("h1",[e._v(e._s(e.GLOBAL.selectedVehicle.chest)+"KG")]),r("p",[e._v("PORTA-MALAS")])]):e._e()]),r("div",{staticClass:"buttons-container"},["Possuidos"!=e.GLOBAL.filterType?r("div",{staticClass:"button",on:{click:function(t){return e.makeAction("requestDrive")}}},[r("h1",[e._v("TESTAR")]),r("p",[e._v("TEST-DRIVE")])]):e._e(),"Possuidos"!=e.GLOBAL.filterType?r("div",{staticClass:"button",on:{click:function(t){return e.makeAction("requestBuy")}}},[r("h1",[e._v("COMPRAR")]),r("p",[e._v("ADQUIRIR")])]):e._e(),"Possuidos"==e.GLOBAL.filterType?r("div",{staticClass:"button",on:{click:function(t){return e.makeAction("requestSell")}}},[r("h1",[e._v("VENDER")]),r("p",[e._v("VENDER")])]):e._e(),"Possuidos"==e.GLOBAL.filterType?r("div",{staticClass:"button",on:{click:function(t){return e.makeAction("requestTax")}}},[r("h1",[e._v("PAGAR")]),r("p",[e._v("PAGAR TAXA")])]):e._e()]),e._m(0)]):e._e()}),o=[function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"infos2-container"},[n("h1",[e._v("INFORMAÇÕES")]),n("p",[e._v("Os melhores veículos da cidade.")])])}],u={methods:{makeAction:function(e){var t={method:"POST",body:JSON.stringify({name:this.GLOBAL.selectedVehicle.k})};fetch(this.GLOBAL.url+"/"+e,t)}}},l=u,f=(n("eea1"),n("2877")),d=Object(f["a"])(l,c,o,!1,null,"68f26af6",null),p=d.exports,h=function(){var e=this,t=e.$createElement,r=e._self._c||t;return r("div",{staticClass:"vehicle-container appear",class:{activeVehicle:e.GLOBAL.selectedVehicle.name==e.data.name}},[r("img",{staticClass:"checked-icon fade",attrs:{src:n("0aae")}}),r("h1",[e._v(e._s(e.data.name))]),r("p",[e._v("R"+e._s(e.UTILS.formatNumberToMoney(e.data.price)))])])},v=[],m={props:{data:Object}},L=m,O=(n("56f8"),Object(f["a"])(L,h,v,!1,null,"d12d67ac",null)),y=O.exports,A=function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"filter-container"},[n("div",{staticClass:"menu-container"},e._l(e.menus,(function(t,r){return n("p",{key:r,staticClass:"menu",class:{activeMenu:e.GLOBAL.filterType==t.type},on:{click:function(n){return e.changeMenu(t)}}},[e._v(e._s(t.name))])})),0),n("div",{staticClass:"search-container"},[e._m(0),n("input",{directives:[{name:"model",rawName:"v-model",value:e.GLOBAL.filterSearch,expression:"GLOBAL.filterSearch"}],staticClass:"inputSearch",attrs:{id:"search",type:"text",placeholder:"PESQUISAR VEÍCULO"},domProps:{value:e.GLOBAL.filterSearch},on:{input:function(t){t.target.composing||e.$set(e.GLOBAL,"filterSearch",t.target.value)}}})])])},_=[function(){var e=this,t=e.$createElement,r=e._self._c||t;return r("label",{attrs:{for:"search"}},[r("img",{attrs:{src:n("d103"),alt:""}})])}],b={data:function(){return{menus:[{name:"CARROS",type:"Carros"},{name:"MOTOS",type:"Motos"},{name:"POSSUÍDOS",type:"Possuidos"}]}},methods:{changeMenu:function(e){this.GLOBAL.filterType=e.type,this.$bus.emit("changeType-event")}}},g=b,S=(n("b8d3"),Object(f["a"])(g,A,_,!1,null,"4460118e",null)),G=S.exports,T={components:{FilterMenu:G,Vehicle:y,Apresentation:p},data:function(){return{vehicles:[{k:"kuruma_armored1",name:"KURUMA BLINDADO",tax:31,chest:50,price:910821}]}},methods:{getVehicles:function(){var e=this,t={method:"POST",body:JSON.stringify({})};fetch(this.GLOBAL.url+"/request"+this.GLOBAL.filterType,t).then(function(){var e=Object(a["a"])(regeneratorRuntime.mark((function e(t){return regeneratorRuntime.wrap((function(e){while(1)switch(e.prev=e.next){case 0:return e.next=2,t.json();case 2:return e.abrupt("return",e.sent);case 3:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}()).then(function(){var t=Object(a["a"])(regeneratorRuntime.mark((function t(n){return regeneratorRuntime.wrap((function(t){while(1)switch(t.prev=t.next){case 0:e.vehicles=n.result,e.GLOBAL.selectedVehicle=e.vehicles[0],e.vehicles.length<=0&&(e.GLOBAL.selectedVehicle={name:"---"});case 3:case"end":return t.stop()}}),t)})));return function(e){return t.apply(this,arguments)}}())},selectVehicle:function(e){this.GLOBAL.selectedVehicle=e},vehicleAppear:function(e){return e.name.toLowerCase().indexOf(this.GLOBAL.filterSearch.toLowerCase())>=0}},mounted:function(){var e=this;this.listener=window.addEventListener("message",(function(t){var n=t.data;"openSystem"==n.action?(e.JQ("#app").fadeIn(500),e.getVehicles()):"closeSystem"==n.action&&e.JQ("#app").fadeOut(500)}),!1),this.$bus.on("changeType-event",(function(){e.getVehicles()})),this.listener=window.addEventListener("keyup",(function(t){var n=t.keyCode;if("27"==n){e.JQ("#app").fadeOut(500);var r={method:"POST",body:JSON.stringify({})};fetch(e.GLOBAL.url+"/closeSystem",r)}}),!1)}},B=T,C=(n("ce1e"),Object(f["a"])(B,i,s,!1,null,"1a03d09b",null)),x=C.exports,k=n("1157"),w=n.n(k),P={formatNumberToMoney:function(e){var t=new Intl.NumberFormat("en-US",{style:"currency",currency:"USD"}),n=t.format(e);return n}},V={url:"http://dealership",filterType:"Carros",filterSearch:"",selectedVehicle:{name:"---"}},R={init:function(){r["default"].mixin({data:function(){return{get GLOBAL(){return V},UTILS:P,JQ:w.a}}})}},M=R,E=n("b828"),j=n("574d"),N=n.n(j);n("04f2");M.init(),r["default"].config.productionTip=!1,r["default"].use(E["a"]),r["default"].use(N.a,{}),new r["default"]({render:function(e){return e(x)}}).$mount("#app")},"56f8":function(e,t,n){"use strict";n("dec6")},7199:function(e,t,n){},"90e32":function(e,t,n){e.exports=n.p+"img/tax.76f13691.svg"},a14f:function(e,t,n){},b8d3:function(e,t,n){"use strict";n("fdf8")},ce1e:function(e,t,n){"use strict";n("7199")},cf44:function(e,t,n){e.exports=n.p+"img/money.f8110c31.svg"},d103:function(e,t,n){e.exports=n.p+"img/search.aa373e0d.svg"},dec6:function(e,t,n){},eea1:function(e,t,n){"use strict";n("a14f")},fdf8:function(e,t,n){}});
//# sourceMappingURL=app.49ddb098.js.map