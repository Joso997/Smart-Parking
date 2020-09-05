// eslint-disable-next-line no-undef
const ParkingBooks = artifacts.require("ParkingBooks");

module.exports = function(deployer) {
  deployer.deploy(ParkingBooks);
};
