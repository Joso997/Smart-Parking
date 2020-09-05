<template>
  <div id="app">
    <b-navbar sticky type="dark" variant="dark" class="container">
      <b-navbar-brand href="#">SmartParking App</b-navbar-brand>
      <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

      <b-collapse id="nav-collapse" is-nav>
        <b-navbar-nav>
          <b-nav-item to="/store">Store</b-nav-item>
          <b-nav-item to="/office">Office</b-nav-item>
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>
    <router-view />
  </div>
</template>

<script>
export default {
  name: "App"
};
</script>

<style>
.map-wrapper {
  position: fixed;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
}
</style>
