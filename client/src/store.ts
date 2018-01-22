import { createStore, /*applyMiddleware, */ compose } from "redux";
import reducer, { ReduxState } from "./reducers/index.reducer";
import { persistStore } from "redux-persist";

const composeEnhancers =
  // tslint:disable-next-line:no-string-literal
  window["__REDUX_DEVTOOLS_EXTENSION_COMPOSE__"] || compose;

export default () => {
  const store = createStore<ReduxState>(reducer, composeEnhancers());
  const persistor = persistStore(store);
  return { store, persistor };
};
