<template>
  <div class="m-2">
    <h5 class="text-center text-uppercase">
      Plaćanje skeniranjem qr koda
    </h5>
    <hr />
    <b-form-rating
      readonly
      v-model="item[3]"
      variant="warning"
      class="mb-2"
    ></b-form-rating>
    <hr />
    <b-row>
      <b-col>
        <b-list-group-item
          class="d-flex justify-content-between align-items-center"
        >
          <h5 class="text-left text-uppercase">
            Električno Punjenje
          </h5>
          <b-form-checkbox
            switch
            disabled
            class="mr-n2 text-right"
            :checked="item[5]"
          >
            <span class="sr-only">Switch for following text input</span>
          </b-form-checkbox>
        </b-list-group-item>
        <b-list-group-item
          class="d-flex justify-content-between align-items-center"
        >
          <h5 class="text-left text-uppercase">
            Krov
          </h5>
          <b-form-checkbox
            switch
            disabled
            class="mr-n2 text-right"
            :checked="item[6]"
          >
            <span class="sr-only">Switch for following text input</span>
          </b-form-checkbox>
        </b-list-group-item>
        <b-list-group-item
          class="d-flex justify-content-between align-items-center"
        >
          <h5 class="text-left text-uppercase">
            Pločnik
          </h5>
          <b-form-checkbox
            switch
            disabled
            class="mr-n2 text-right"
            :checked="item[7]"
          >
            <span class="sr-only">Switch for following text input</span>
          </b-form-checkbox>
        </b-list-group-item>
      </b-col>
    </b-row>
    <hr />
    <b-row>
      <b-col>
        <b-list-group-item
          class="d-flex justify-content-between align-items-center"
        >
          <h5 class="text-left text-uppercase">
            Cijena
          </h5>
          <h5 class="text-right text-uppercase">{{ getPrice }} Ether</h5>
        </b-list-group-item>
        <b-list-group-item
          class="d-flex justify-content-between align-items-center"
        >
          <h5 class="text-left text-uppercase">
            Deposit
          </h5>
          <h5 class="text-right text-uppercase">{{ getDeposit }} Ether</h5>
        </b-list-group-item>
        <b-list-group-item
          class="d-flex justify-content-between align-items-center"
        >
          <h5 class="text-left text-uppercase">
            Ukupno
          </h5>
          <h5 class="text-right text-uppercase">{{ getSum }} Ether</h5>
        </b-list-group-item>
      </b-col>
    </b-row>
    <hr />
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
    }
  },
  data() {
    return {
      time: { min: 0, sec: 0 }
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
    this.getTime();
  },
  methods: {
    endReserve() {
      if (this.isDrizzleInitialized) {
        this.drizzleInstance.contracts.ParkingBooks.methods
          .reserve_end()
          .send();
      } else {
        alert("Drizzle doesn't seem to be initialised / ready");
      }
    },
    getTime() {
      let timestamp = 0;
      setInterval(() => {
        if (this.item !== undefined) {
          timestamp =
            Number(this.item[12][1]) +
            Number(this.item[12][0]) -
            Date.now() / 1000;
        }
        timestamp = timestamp >= 0 ? timestamp : 0;
        let date = new Date(timestamp * 1000);
        this.time = { min: date.getMinutes(), sec: date.getSeconds() };
      }, 1000);
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
