import * as React from "react";
import * as ReactDOM from "react-dom";
import { Provider } from "react-redux";
import MuiThemeProvider from "material-ui/styles/MuiThemeProvider";
import darkBaseTheme from "material-ui/styles/baseThemes/lightBaseTheme";
import getMuiTheme from "material-ui/styles/getMuiTheme";
import jss from "jss";
import preset from "jss-preset-default";
import { ApolloProvider } from "react-apollo";
import { PersistGate } from "redux-persist/es/integration/react";

import App from "./App";
import registerServiceWorker from "./registerServiceWorker";
import "./index.css";
import configureStore from "./store";
import { client } from "./apollo-setup";

jss.setup(preset());

const theme = getMuiTheme(darkBaseTheme);

export const { store, persistor } = configureStore();

ReactDOM.render(
  <MuiThemeProvider muiTheme={theme}>
    <Provider store={store}>
      <PersistGate persistor={persistor}>
        <ApolloProvider client={client}>
          <App />
        </ApolloProvider>
      </PersistGate>
    </Provider>
  </MuiThemeProvider>,
  document.getElementById("root") as HTMLElement
);
registerServiceWorker();
