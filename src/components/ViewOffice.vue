<template>
  <div v-if="isDrizzleInitialized" id="office" class="container">
    <b-card-group deck>
      <b-card header="Parkirališta:">
        <b-list-group v-if="getParkings">
          <b-list-group-item variant="info">Naziv</b-list-group-item>
          <b-list-group-item
            v-for="(parking, i) in getParkings"
            :key="i"
            button
            @click="showUpdate(parking)"
            >{{ parking[1] }}</b-list-group-item
          >
        </b-list-group>
      </b-card>
    </b-card-group>
  </div>
  <div v-else>
    Loading application...
  </div>
</template>

<script>
// @ is an alias to /src
import { mapGetters } from "vuex";
export default {
  name: "ViewOffice",
  computed: {
    ...mapGetters("drizzle", ["drizzleInstance", "isDrizzleInitialized"]),
    ...mapGetters("contracts", ["getContractData"]),
    getParkings() {
      let data = this.getContractData({
        contract: "ParkingBooks",
        method: "indexByOwner"
      });
      if (data === "loading") return false;
      console.log(data);
      return data;
    },
    utils() {
      return this.drizzleInstance.web3.utils;
    }
  },
  created() {
    this.$store.dispatch("drizzle/REGISTER_CONTRACT", {
      contractName: "ParkingBooks",
      method: "indexByOwner",
      methodArgs: []
    });
  },
  methods: {
    showUpdate($event) {
      this.$emit("showUpdate", $event);
    }
  }
};
</script>
