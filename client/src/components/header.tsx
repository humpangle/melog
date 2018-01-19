import * as React from "react";

// tslint:disable-next-line:no-var-requires
const logo = require("./logo.svg");

const header = () => (
  <div className="App-header">
    <img src={logo} className="App-logo" alt="logo" />
    <h2>Melog</h2>
    <p className="App-intro">Self discovery, one keystroke at a time.</p>
  </div>
);

export default header;
