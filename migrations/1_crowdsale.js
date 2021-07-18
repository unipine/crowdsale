const Crowdsale = artifacts.require("Crowdsale");

module.exports = function (deployer) {
  deployer.deploy(Crowdsale, {
    from: "0xE7A7DaEBd304851B0085D72902614F28000Cdf45"
  });
};
