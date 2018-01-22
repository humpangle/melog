import * as React from "react";

// tslint:disable-next-line:no-var-requires
const logo = require("../logo.svg");

const header = () => (
  <div className="App-header">
    <img src={logo} className="App-logo" alt="logo" />
    <h2>Melog</h2>
  </div>
);

export default header;
