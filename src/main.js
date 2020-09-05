import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import x5GMaps from "x5-gmaps";
import { BootstrapVue, IconsPlugin } from "bootstrap-vue";
import "bootstrap/dist/css/bootstrap.css";
import "bootstrap-vue/dist/bootstrap-vue.css";
import drizzleVuePlugin from "@drizzle/vue-plugin";
import drizzleOptions from "./drizzleOptions";

Vue.use(x5GMaps, "You Api Key");
Vue.use(drizzleVuePlugin, { store, drizzleOptions });
// Install BootstrapVue
Vue.use(BootstrapVue);
// Optionally install the BootstrapVue icon components plugin
Vue.use(IconsPlugin);

Vue.config.productionTip = false;

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount("#app");
