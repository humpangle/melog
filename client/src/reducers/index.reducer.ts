import { reducer as form, FormStateMap } from "redux-form";
import { persistCombineReducers } from "redux-persist";
import createWebStorage from "redux-persist/es/storage/createWebStorage";

import {
  SetCurrentUserAction,
  LogoutAction,
  RehydrateAction,
  AuthState,
  auth
} from "./auth.reducer";

export enum ActionTypeKeys {
  SET_CURRENT_USER = "SET_CURRENT_USER",
  LOGOUT = "LOGOUT",
  REHYDRATE = "persist/REHYDRATE",
  OTHER_ACTION = "__@chatty_any_other_action__"
}

export type ActionType = SetCurrentUserAction | LogoutAction | RehydrateAction;

export type ReduxState = FormStateMap & {
  auth: AuthState;
};

const reducer = persistCombineReducers<ReduxState>(
  {
    key: "@melog/1516740570612/v1",
    storage: createWebStorage("local"),
    blacklist: ["form"]
  },
  {
    form,
    auth
  }
);

export default reducer;

export const getUser = (state: ReduxState) => state.auth;
