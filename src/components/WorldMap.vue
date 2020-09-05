<template>
  <gmaps-map :options="mapOptions" v-if="getParkings">
    <gmaps-marker
      @click="test(item)"
      v-for="(item, i) in getParkings"
      :key="i"
      :options="item.options"
    />
  </gmaps-map>
</template>

<script>
import { gmapsMap, gmapsMarker } from "x5-gmaps";
import { mapGetters } from "vuex";

export default {
  name: "WorldMap",
  components: { gmapsMap, gmapsMarker },
  data() {
    return {
      mapOptions: {
        center: { lat: 20, lng: 30 },
        zoom: 12,
        fullscreenControl: false,
        mapTypeControl: false,
        rotateControl: false,
        scaleControl: false,
        streetViewControl: false,
        zoomControl: false
      },
      items: []
    };
  },
  created() {
    this.$store.dispatch("drizzle/REGISTER_CONTRACT", {
      contractName: "ParkingBooks",
      method: "index",
      methodArgs: []
    });
  },
  mounted() {
    navigator.geolocation.getCurrentPosition(
      position => {
        this.mapOptions.center.lat = position.coords.latitude;
        this.mapOptions.center.lng = position.coords.longitude;
      },
      error => {
        console.log(error.message);
      }
    );
  },
  methods: {
    test(item) {
      this.$emit("customEvent", item);
    },
    resolveData(data) {
      data.forEach((item, i) => {
        console.log(item);
        console.log(i);
        this.items.push({
          id: i,
          options: {
            position: { lat: Number(item[2][0]), lng: Number(item[2][1]) }
          },
          data: item
        });
      });
      return this.items;
    }
  },
  computed: {
    ...mapGetters("drizzle", ["drizzleInstance", "isDrizzleInitialized"]),
    ...mapGetters("contracts", ["getContractData"]),
    getParkings() {
      let data = this.getContractData({
        contract: "ParkingBooks",
        method: "index"
      });
      if (data === "loading") return false;
      return this.resolveData(data);
    },
    utils() {
      return this.drizzleInstance.web3.utils;
    }
  }
};
</script>
