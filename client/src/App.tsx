import * as React from "react";
import {
  BrowserRouter,
  Switch,
  Route,
  Redirect,
  RouteProps
} from "react-router-dom";
import Loadable, { LoadableComponent } from "react-loadable";
import { connect } from "react-redux";
import jss from "jss";

import {
  SIGNUP_URL,
  LOGIN_URL,
  ROOT_URL,
  NEW_EXPERIENCE_URL
} from "./constants";
import { getUser, ReduxState } from "./reducers/index.reducer";

const styles = {
  app: {
    display: "flex",
    height: "100%"
  },

  loadingIndicator: {
    display: "flex",
    flex: 1,
    "justify-content": "center",
    "align-items": "center",
    background: "#757575",
    color: "#fff",
    "font-size": "1.5rem",
    height: "100%"
  }
};

const { classes } = jss.createStyleSheet(styles).attach();

export const Loading = () => (
  <div className={`${classes.loadingIndicator} ${classes.app}`}>
    <div>Loading...</div>
  </div>
);

const Signin = Loadable({
  loader: () => import("./routes/signin.route"),
  loading: Loading
});

const Home = Loadable({
  loader: () => import("./routes/home.route"),
  loading: Loading
});

const NewExperience = Loadable({
  loader: () => import("./routes/new-experience-definition.route"),
  loading: Loading
});

interface FromReduxState {
  jwt: string;
}

type Props = FromReduxState & {
  authComponent:
    | (React.ComponentClass<{}> & LoadableComponent)
    | (React.StatelessComponent<{}> & LoadableComponent);
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
  state => {
    return {
      jwt: getUser(state).jwt
    };
  }
)(authRequired);

const redirectToLogin = () => <Redirect to={LOGIN_URL} />;

class App extends React.Component {
  render() {
    return (
      <div className={`${classes.app}`}>
        <BrowserRouter>
          <Switch>
            <Route exact={true} path={SIGNUP_URL} component={Signin} />
            <Route exact={true} path={LOGIN_URL} component={Signin} />
            <AuthRequired exact={true} path={ROOT_URL} authComponent={Home} />
            <AuthRequired
              exact={true}
              path={NEW_EXPERIENCE_URL}
              authComponent={NewExperience}
            />
            <Route render={redirectToLogin} />
          </Switch>
        </BrowserRouter>
      </div>
    );
  }
}

export default App;
