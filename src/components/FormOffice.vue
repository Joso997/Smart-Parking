<template>
  <b-card bg-variant="light">
    <b-button @click="testSubmit">Test</b-button>
    <b-form-group
      label-cols-lg="3"
      label="Parking"
      label-size="lg"
      label-class="font-weight-bold pt-0"
      class="mb-0"
    >
      <b-form-group
        label-cols-sm="3"
        label="Naziv:"
        label-align-sm="right"
        label-for="nested-street"
      >
        <b-form-input id="nested-street" v-model="form.title"></b-form-input>
      </b-form-group>
      <b-row>
        <b-col>
          <b-form-group
            label-cols-sm="6"
            label="Longitude:"
            label-align-sm="right"
            label-for="nested-city"
          >
            <b-form-spinbutton
              v-model="form.location[0]"
              id="nested-city"
            ></b-form-spinbutton>
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group
            label-cols-sm="6"
            label="Latitude:"
            label-align-sm="right"
            label-for="nested-city"
          >
            <b-form-spinbutton
              v-model="form.location[1]"
              id="nested-city"
            ></b-form-spinbutton>
          </b-form-group>
        </b-col>
      </b-row>
      <b-row>
        <b-col>
          <b-form-group
            label-cols-sm="6"
            label="Od:"
            label-align-sm="right"
            label-for="nested-city"
          >
            <b-form-timepicker
              v-model="form.working_hours[0]"
              id="ex-disabled-readonly"
            ></b-form-timepicker>
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group
            label-cols-sm="6"
            label="Do:"
            label-align-sm="right"
            label-for="nested-city"
          >
            <b-form-timepicker
              v-model="form.working_hours[1]"
              id="ex-disabled-readonly"
            ></b-form-timepicker>
          </b-form-group>
        </b-col>
      </b-row>

      <b-row>
        <b-col>
          <b-form-group
            label-cols-sm="6"
            label="Price(Ether):"
            label-align-sm="right"
            label-for="nested-city"
          >
            <b-form-spinbutton
              v-model="form.price"
              id="ex-disabled-readonly"
            ></b-form-spinbutton>
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group
            label-cols-sm="6"
            label="Deposit(Ether):"
            label-align-sm="right"
            label-for="nested-city"
          >
            <b-form-spinbutton
              v-model="form.deposit"
              id="ex-disabled-readonly"
            ></b-form-spinbutton>
          </b-form-group>
        </b-col>
      </b-row>

      <b-row>
        <b-col>
          <b-form-group
            label-cols-sm="6"
            label="Trajanje Rezervacije (minute):"
            label-align-sm="right"
            label-for="nested-city"
          >
            <b-form-spinbutton
              v-model="form.time.waitReserve"
              id="ex-disabled-readonly"
            ></b-form-spinbutton>
          </b-form-group>
        </b-col>
        <b-col>
          <b-form-group
            label-cols-sm="6"
            label="Trajanje Najma (minute):"
            label-align-sm="right"
            label-for="nested-city"
          >
            <b-form-spinbutton
              v-model="form.time.waitLease"
              id="ex-disabled-readonly"
            ></b-form-spinbutton>
          </b-form-group>
        </b-col>
      </b-row>
      <b-form-group
        label-cols-sm="2"
        label="Podržava:"
        label-align-sm="right"
        class="mb-0"
      >
        <b-row>
          <b-col>
            <b-form-group
              label-cols-sm="6"
              label="Električno Punjenje"
              label-align-sm="right"
              class="mb-0"
            >
              <b-form-checkbox
                class="pt-2"
                id="checkbox-electric_support"
                v-model="form.electric_support"
                name="flavour-1"
              ></b-form-checkbox>
            </b-form-group>
          </b-col>
          <b-col>
            <b-form-group
              label-cols-sm="5"
              label="Krov"
              label-align-sm="right"
              class="mb-0"
            >
              <b-form-checkbox
                class="pt-2"
                id="checkbox-roof"
                v-model="form.roof"
                name="flavour-1"
              ></b-form-checkbox>
            </b-form-group>
          </b-col>
          <b-col>
            <b-form-group
              label-cols-sm="5"
              label="Pločnik"
              label-align-sm="right"
              class="mb-0"
            >
              <b-form-checkbox
                class="pt-2"
                id="checkbox-pavement"
                v-model="form.pavement"
                name="flavour-1"
              ></b-form-checkbox>
            </b-form-group>
          </b-col>
        </b-row>
      </b-form-group>
      <b-button v-if="this.item.length !== 0" variant="primary" @click="update"
        >Spremi</b-button
      >
      <b-button v-if="this.item.length === 0" variant="primary" @click="submit"
        >Spremi</b-button
      >
    </b-form-group>
  </b-card>
</template>

<script>
import { mapGetters } from "vuex";
export default {
  name: "FormOffice",
  props: {
    item: Array
  },
  data() {
    return {
      form: {
        title: "",
        location: [0, 0],
        working_hours: ["0", "0"],
        electric_support: false,
        roof: false,
        pavement: false,
        price: 0,
        deposit: 0,
        enabled: true,
        time: {
          waitReserve: 0,
          endReserve: 0,
          waitLease: 0,
          endLease: 0
        }
      }
    };
  },
  mounted() {
    if (this.item.length !== 0) {
      let element = 1;
      const temp = {
        title: this.item[element++],
        location: [
          Number(this.item[element][0]),
          Number(this.item[element++][1])
        ],
        working_hours: [this.item[++element][0], this.item[element++][1]],
        electric_support: this.item[element++],
        roof: this.item[element++],
        pavement: this.item[element++],
        price: Number(
          this.drizzleInstance.web3.utils.fromWei(this.item[element++], "ether")
        ),
        deposit: Number(
          this.drizzleInstance.web3.utils.fromWei(this.item[element++], "ether")
        ),
        enabled: this.item[element++],
        time: {
          waitReserve: Number(this.item[++element][0]),
          endReserve: Number(this.item[element][1]),
          waitLease: Number(this.item[element][2]),
          endLease: Number(this.item[element][3])
        }
      };
      this.form = temp;
    }
  },
  computed: {
    ...mapGetters("drizzle", ["drizzleInstance", "isDrizzleInitialized"]),
    ...mapGetters("contracts", ["getContractData"]),
    utils() {
      return this.drizzleInstance.web3.utils;
    }
  },
  methods: {
    submit() {
      console.log(this.form);
      if (this.isDrizzleInitialized) {
        this.drizzleInstance.contracts.ParkingBooks.methods
          .store(
            this.form.title,
            this.form.location,
            this.form.location,
            this.form.electric_support,
            this.form.roof,
            this.form.pavement,
            this.drizzleInstance.web3.utils.toWei(
              this.form.price + "",
              "ether"
            ),
            this.drizzleInstance.web3.utils.toWei(
              this.form.deposit + "",
              "ether"
            ),
            this.form.enabled,
            [
              this.form.time.waitReserve * 60,
              0,
              this.form.time.waitLease * 60,
              0
            ]
          )
          .send();
        this.$emit("submitted");
      } else {
        alert("Drizzle doesn't seem to be initialised / ready");
      }
    },
    update() {
      console.log(this.form);
      if (this.isDrizzleInitialized) {
        this.drizzleInstance.contracts.ParkingBooks.methods
          .update(
            this.item[0],
            this.form.title,
            this.form.location,
            this.form.location,
            this.form.electric_support,
            this.form.roof,
            this.form.pavement,
            this.drizzleInstance.web3.utils.toWei(
              this.form.price + "",
              "ether"
            ),
            this.drizzleInstance.web3.utils.toWei(
              this.form.deposit + "",
              "ether"
            ),
            //this.form.enabled,
            [
              this.form.time.waitReserve * 60,
              0,
              this.form.time.waitLease * 60,
              0
            ]
          )
          .send();
        this.$emit("submitted");
      } else {
        alert("Drizzle doesn't seem to be initialised / ready");
      }
    },
    testSubmit() {
      if (this.isDrizzleInitialized) {
        this.drizzleInstance.contracts.ParkingBooks.methods.testStore().send();
      } else {
        alert("Drizzle doesn't seem to be initialised / ready");
      }
    }
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
