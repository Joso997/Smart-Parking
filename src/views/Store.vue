<template>
  <div class="home">
    <Map v-if="getStatus.map && id === undefined" @onOk="show" />
    <Reserve v-if="getStatus.reserve && id === undefined" />
    <ShowLease v-if="getStatus.lease" :id="Number(id)" />
    <Lease v-if="!getStatus.lease && id !== undefined" :id="Number(id)" />
  </div>
</template>

<script>
// @ is an alias to /src
import Map from "./Map";
import Reserve from "./Reserve";
import Lease from "./Lease";
import ShowLease from "./ShowLease";
import { mapGetters } from "vuex";
export default {
  name: "Store",
  components: { Map, Reserve, Lease, ShowLease },
  props: {
    id: {
      type: String,
      required: false
    }
  },
  data() {
    return {
      modalShow: false,
      item: {}
    };
  },
  created() {
    this.$store.dispatch("drizzle/REGISTER_CONTRACT", {
      contractName: "ParkingBooks",
      method: "checkStatus",
      methodArgs: []
    });
  },
  computed: {
    ...mapGetters("drizzle", ["drizzleInstance", "isDrizzleInitialized"]),
    ...mapGetters("contracts", ["getContractData"]),
    getStatus() {
      let data = this.getContractData({
        contract: "ParkingBooks",
        method: "checkStatus"
      });
      if (data === "loading") return false;
      let loadSection = { map: false, reserve: false, lease: false };
      switch (data) {
        case "inLease":
          loadSection.lease = true;
          break;
        case "inReserve":
          loadSection.reserve = true;
          break;
        default:
          loadSection.map = true;
          break;
      }
      console.log(loadSection);
      return loadSection;
    },
    utils() {
      return this.drizzleInstance.web3.utils;
    }
  },
  methods: {
    show(id) {
      if (this.isDrizzleInitialized) {
        this.drizzleInstance.contracts.ParkingBooks.methods.reserve(id).send();
      } else {
        alert("Drizzle doesn't seem to be initialised / ready");
      }
    }
  }
};
</script>
