import * as React from "react";
import { BrowserRouter, Switch, Route } from "react-router-dom";
import Loadable from "react-loadable";
import "./App.css";
import { SIGNUP_URL, LOGIN_URL } from "./constants";

const loading = () => <div>Loading..</div>;

const Signin = Loadable({
  loader: () => import("./routes/signin.route"),
  loading
});

class App extends React.Component {
  render() {
    return (
      <div className="App">
        <BrowserRouter>
          <Switch>
            <Route exact={true} path={SIGNUP_URL} component={Signin} />
            <Route exact={true} path={LOGIN_URL} component={Signin} />
          </Switch>
        </BrowserRouter>
      </div>
    );
  }
}

export default App;
