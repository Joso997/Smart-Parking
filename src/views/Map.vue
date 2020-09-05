<template>
  <div class="map-wrapper">
    <world-map @customEvent="openModal" />
    <b-modal v-model="modalShow" id="modal-1" @ok="test" :title="item[1]">
      <template v-slot:modal-footer="{ ok, cancel }">
        <b-button variant="secondary" @click="cancel()">
          Cancel
        </b-button>
        <b-button variant="primary" @click="ok()">
          Rezerviraj
        </b-button>
      </template>
      <InfoDetails :item="item"></InfoDetails>
    </b-modal>
  </div>
</template>

<script>
// @ is an alias to /src
import WorldMap from "../components/WorldMap";
import InfoDetails from "../components/InfoDetails";

export default {
  name: "Map",
  components: { WorldMap, InfoDetails },
  data() {
    return {
      modalShow: false,
      item: {}
    };
  },
  methods: {
    openModal($event) {
      this.item = $event.data;
      this.item.id = $event.id;
      this.modalShow = true;
    },
    test() {
      this.$emit("onOk", this.item.id);
    }
  }
};
</script>
