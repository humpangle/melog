import * as React from "react";
import * as ReactDOM from "react-dom";
import { Provider } from "react-redux";
import MuiThemeProvider from "material-ui/styles/MuiThemeProvider";
import darkBaseTheme from "material-ui/styles/baseThemes/darkBaseTheme";
import getMuiTheme from "material-ui/styles/getMuiTheme";
import jss from "jss";
import preset from "jss-preset-default";
import App from "./App";
import registerServiceWorker from "./registerServiceWorker";
import "./index.css";
import configureStore from "./store";

jss.setup(preset());

const theme = getMuiTheme(darkBaseTheme);

export const store = configureStore();

ReactDOM.render(
  <MuiThemeProvider muiTheme={theme}>
    <Provider store={store}>
      <App />
    </Provider>
  </MuiThemeProvider>,
  document.getElementById("root") as HTMLElement
);
registerServiceWorker();
