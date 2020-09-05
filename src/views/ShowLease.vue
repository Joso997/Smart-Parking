<template>
  <b-container fluid="md" class="home p-0">
    <HelloWorld msg="Welcome to Your Vue.js App" v-if="getItem" />
    <ReservationTitle v-if="getItem" :item="getItem" />
    <ShowLeaseDetails v-if="getItem" :item="getItem" :id="id" />
  </b-container>
</template>

<script>
// @ is an alias to /src
import HelloWorld from "@/components/HelloWorld.vue";
import ReservationTitle from "@/components/ReservationTitle.vue";
import ShowLeaseDetails from "@/components/ShowLeaseDetails.vue";
import { mapGetters } from "vuex";
export default {
  name: "Reserve",
  props: {
    id: {
      type: Number,
      required: false
    }
  },
  components: {
    HelloWorld,
    ShowLeaseDetails,
    ReservationTitle
  },
  created() {
    this.$store.dispatch("drizzle/REGISTER_CONTRACT", {
      contractName: "ParkingBooks",
      method: "show",
      methodArgs: []
    });
  },
  computed: {
    ...mapGetters("drizzle", ["drizzleInstance", "isDrizzleInitialized"]),
    ...mapGetters("contracts", ["getContractData"]),
    getItem() {
      let data = this.getContractData({
        contract: "ParkingBooks",
        method: "show"
      });
      if (data === "loading") return false;
      console.log(data);
      return data;
    },
    utils() {
      return this.drizzleInstance.web3.utils;
    }
  }
};
</script>
