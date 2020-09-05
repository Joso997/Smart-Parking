<template>
  <b-card no-body class="overflow-hidden ">
    <b-row no-gutters class="title-text p-2">
      <b-col>
        <b-card-text class="h5 text-center text-uppercase">
          Parkirno mjesto {{ item[1] }}
        </b-card-text>
      </b-col>
    </b-row>
    <b-row no-gutters>
      <b-col>
        <b-card-img-lazy
          src="https://picsum.photos/400/400/?image=20"
          alt="Image"
          class="rounded-0"
        ></b-card-img-lazy>
      </b-col>
    </b-row>
  </b-card>
</template>

<script>
export default {
  name: "ReservationDetails",
  props: {
    item: {
      type: Array,
      required: true
    }
  }
};
</script>
