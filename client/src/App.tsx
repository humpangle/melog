import * as React from "react";
import {
  BrowserRouter,
  Switch,
  Route,
  Redirect,
  RouteProps
} from "react-router-dom";
import Loadable from "react-loadable";
import { connect } from "react-redux";

import "./App.css";
import { SIGNUP_URL, LOGIN_URL, ROOT_URL } from "./constants";
import Header from "./components/header.component";
import { getUser, ReduxState } from "./reducers/index.reducer";

const loading = () => <div>Loading..</div>;

const Signin = Loadable({
  loader: () => import("./routes/signin.route"),
  loading
});

interface FromReduxState {
  jwt: string;
}

type Props = FromReduxState & {
  authComponent: React.StatelessComponent<RouteProps>;
};

const authRequired = ({
  authComponent: AuthComponent,
  jwt,
  ...rest
}: Props) => {
  const render = (childProps: RouteProps) => {
    if (jwt) {
      return <AuthComponent {...childProps} />;
    }

    return <Redirect to={LOGIN_URL} {...childProps} />;
  };

  return <Route {...rest} render={render} />;
};

const AuthRequired = connect<FromReduxState, {}, RouteProps, ReduxState>(
  state => ({
    jwt: getUser(state).jwt
  })
)(authRequired);

const Home = () => (
  <div>
    <Header />
  </div>
);

class App extends React.Component {
  render() {
    return (
      <div className="App">
        <BrowserRouter>
          <Switch>
            <Route exact={true} path={SIGNUP_URL} component={Signin} />
            <Route exact={true} path={LOGIN_URL} component={Signin} />
            <AuthRequired exact={true} path={ROOT_URL} authComponent={Home} />
            <Route render={() => <Redirect to={LOGIN_URL} />} />
          </Switch>
        </BrowserRouter>
      </div>
    );
  }
}

export default App;
