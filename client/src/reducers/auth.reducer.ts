import Immutable from "seamless-immutable";
import { Reducer } from "redux";

import { ActionTypeKeys, ActionType } from "./index.reducer";

export interface SetCurrentUserAction {
  type: ActionTypeKeys.SET_CURRENT_USER;
  user: AuthState;
}

export interface LogoutAction {
  type: ActionTypeKeys.LOGOUT;
}

export type AuthState = Immutable.ImmutableObject<State>;

interface State {
  id: string;
  jwt: string;
  username: string;
  email: string;
}

const initialState: AuthState = Immutable<State>({
  id: "",
  jwt: "",
  username: "",
  email: "",
});

export const auth: Reducer<AuthState> = (state = initialState, action: ActionType) => {
  switch (action.type) {

    case ActionTypeKeys.SET_CURRENT_USER:
      return state.merge(action.user);

    case ActionTypeKeys.LOGOUT:
      return initialState;

    default:
      return state;
  }
};

export default auth;
