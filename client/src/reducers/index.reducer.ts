import { combineReducers } from "redux";
import { reducer as form, FormStateMap } from "redux-form";

import { SetCurrentUserAction, LogoutAction, AuthState, auth } from "./auth.reducer";

export enum ActionTypeKeys {
  SET_CURRENT_USER = "SET_CURRENT_USER",
  LOGOUT = "LOGOUT",
  REHYDRATE = "persist/REHYDRATE",
  OTHER_ACTION = "__@chatty_any_other_action__",
}

export type ActionType = SetCurrentUserAction | LogoutAction;

export type ReduxState = FormStateMap & {
  auth: AuthState
};

const reducer = combineReducers<ReduxState>({
  form,
  auth
});

export default reducer;

export const getUser = (state: ReduxState) => state.auth;
