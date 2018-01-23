import * as React from "react";
import { Link } from "react-router-dom";
import { ROOT_URL } from "../constants";

// tslint:disable-next-line:no-var-requires
const logo = require("../logo.svg");

const header = ({ title = "Melog" }) => (
  <div className="App-header">
    <Link to={ROOT_URL}>
      <img src={logo} className="App-logo" alt="logo" />
    </Link>
    <h2>{title}</h2>
  </div>
);

export default header;
