<template>
  <b-container fluid="md" class="home p-0">
    <HelloWorld msg="Welcome to Your Vue.js App" v-if="getItem" />
    <ReservationTitle v-if="getItem" :item="getItem" />
    <LeaseDetails v-if="getItem" :item="getItem" :id="id" />
  </b-container>
</template>

<script>
// @ is an alias to /src
import HelloWorld from "@/components/HelloWorld.vue";
import ReservationTitle from "@/components/ReservationTitle.vue";
import LeaseDetails from "@/components/LeaseDetails.vue";
import { mapGetters } from "vuex";
export default {
  name: "Lease",
  props: {
    id: {
      type: Number,
      required: true
    }
  },
  components: {
    HelloWorld,
    LeaseDetails,
    ReservationTitle
  },
  created() {
    this.$store.dispatch("drizzle/REGISTER_CONTRACT", {
      contractName: "ParkingBooks",
      method: "show",
      methodArgs: [this.id]
    });
  },
  computed: {
    ...mapGetters("drizzle", ["drizzleInstance", "isDrizzleInitialized"]),
    ...mapGetters("contracts", ["getContractData"]),
    getItem() {
      let data = this.getContractData({
        contract: "ParkingBooks",
        method: "show",
        methodArgs: this.id
      });
      if (data === "loading") return false;
      console.log(this.id);
      console.log(data);
      return data;
    },
    utils() {
      return this.drizzleInstance.web3.utils;
    }
  }
};
</script>
