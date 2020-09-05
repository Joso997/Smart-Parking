<template>
  <div id="office" class="container">
    <h5 class="text-center text-uppercase">Vaš Ured</h5>
    <b-button block @click="resolveFunds">Razriješite Dugovanja</b-button>
    <hr />
    <b-tabs pills fill>
      <b-tab title="Vaša Parking Mjesta" :active="show.view"
        ><ViewOffice @showUpdate="showUpdate"></ViewOffice
      ></b-tab>
      <b-tab title="Dodaj Parking Mjesto" :active="show.form"
        ><FormOffice
          :item="item"
          :key="formElement"
          @submitted="showView()"
        ></FormOffice
      ></b-tab>
    </b-tabs>
  </div>
</template>

<script>
// @ is an alias to /src
import FormOffice from "../components/FormOffice";
import ViewOffice from "../components/ViewOffice";
import { mapGetters } from "vuex";
export default {
  name: "Office",
  components: { FormOffice, ViewOffice },
  data() {
    return {
      item: [],
      show: { form: false, view: true },
      formElement: 0
    };
  },
  computed: {
    ...mapGetters("drizzle", ["drizzleInstance", "isDrizzleInitialized"]),
    ...mapGetters("contracts", ["getContractData"])
  },
  methods: {
    showUpdate($event) {
      this.item = $event;
      this.show.view = false;
      this.show.form = true;
      this.formElement++;
    },
    showView() {
      this.show.view = true;
      this.show.from = false;
    },
    resolveFunds() {
      if (this.isDrizzleInitialized) {
        this.drizzleInstance.contracts.ParkingBooks.methods
          .resolveFunds()
          .send();
      } else {
        alert("Drizzle doesn't seem to be initialised / ready");
      }
    }
  }
};
</script>
