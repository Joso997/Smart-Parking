<template>
  <div class="m-2">
    <h5 class="text-center text-uppercase">
      Ocjenite i potvrdite odlazak prije isteka najma
    </h5>
    <hr />
    <h5 class="text-center text-uppercase">
      Najam istjeće za:
      <b-button
        size="lg"
        variant="outline-dark"
        class="button-round pl-4 pr-4 pt-1 pd-1"
        >{{ this.time.min }}:{{ this.time.sec }} min</b-button
      >
    </h5>
    <div class="text-center" v-if="isNaN(id)">
      <b-button
        size="lg"
        variant="primary"
        class="button-round button-danger text-uppercase pl-4 pr-4 pt-1 pd-1"
        @click="updateLease"
        >Produži</b-button
      >
    </div>
    <div class="text-center" v-if="!isNaN(id)">
      <hr />
      <b-alert
        :show="dismissCountDown"
        dismissible
        variant="warning"
        @dismissed="dismissCountDown = 0"
        @dismiss-count-down="countDownChanged"
      >
        Morate dati ocjenu.
      </b-alert>
      <b-form-rating
        v-model="score"
        variant="warning"
        class="mb-2"
      ></b-form-rating>
      <b-button
        size="lg"
        variant="primary"
        class="button-round button-danger text-uppercase pl-4 pr-4 pt-1 pd-1"
        @click="endLease"
        >Potvrdi</b-button
      >
    </div>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
export default {
  name: "ReservationDetails",
  props: {
    item: {
      type: Array,
      required: true
    },
    id: {
      type: Number,
      required: false
    }
  },
  data() {
    return {
      time: { min: 0, sec: 0 },
      score: 0,
      dismissSecs: 5,
      dismissCountDown: 0
    };
  },
  computed: {
    ...mapGetters("drizzle", ["drizzleInstance", "isDrizzleInitialized"]),
    ...mapGetters("contracts", ["getContractData"]),
    getPrice() {
      let sum = 0;
      if (this.item !== undefined) {
        sum += Number(
          this.drizzleInstance.web3.utils.fromWei(this.item[8], "ether")
        );
      }

      return sum;
    },
    getDeposit() {
      let sum = 0;
      if (this.item !== undefined) {
        sum += Number(
          this.drizzleInstance.web3.utils.fromWei(this.item[9], "ether")
        );
      }

      return sum;
    },
    getSum() {
      return this.getPrice + this.getDeposit;
    }
  },
  mounted() {
    console.log(this.id);
    this.getTime();
  },
  methods: {
    updateLease() {
      if (this.isDrizzleInitialized) {
        this.drizzleInstance.contracts.ParkingBooks.methods
          .leaseUpdate(this.item[0])
          .send({
            value: Number(this.item[8]) + Number(this.item[9])
          });
      } else {
        alert("Drizzle doesn't seem to be initialised / ready");
      }
    },
    endLease() {
      if (this.score !== 0) {
        if (this.isDrizzleInitialized) {
          this.drizzleInstance.contracts.ParkingBooks.methods
            .lease_end(this.id, this.score)
            .send();
        } else {
          alert("Drizzle doesn't seem to be initialised / ready");
        }
      } else {
        this.dismissCountDown = this.dismissSecs;
      }
    },
    getTime() {
      let timestamp = 0;
      setInterval(() => {
        if (this.item !== undefined) {
          timestamp =
            Number(this.item[12][2]) +
            Number(this.item[12][3]) -
            Date.now() / 1000;
        }
        timestamp = timestamp >= 0 ? timestamp : 0;
        let date = new Date(timestamp * 1000);
        this.time = { min: date.getMinutes(), sec: date.getSeconds() };
      }, 1000);
    },
    countDownChanged(dismissCountDown) {
      this.dismissCountDown = dismissCountDown;
    }
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style>
.row {
  margin-left: inherit;
  margin-right: inherit;
}
.title-text {
  background-color: #f5f2f2;
}
.button-round {
  border-radius: 1em;
}
.button-danger {
  border-color: gray;
}
img {
  display: block;
  max-width: 100%;
  height: 15em;
}
@media only screen and (min-width: 400px) {
  img {
    display: block;
    max-width: 100%;
    height: 20em;
  }
}
</style>
