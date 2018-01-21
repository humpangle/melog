import Immutable from "seamless-immutable";
import { Reducer } from "redux";

import { ActionTypeKeys, ActionType } from "./index.reducer";
import { UserFragmentFragment } from "../graphql/operation-result-types";

export interface SetCurrentUserAction {
  type: ActionTypeKeys.SET_CURRENT_USER;
  user: UserFragmentFragment;
}

export interface LogoutAction {
  type: ActionTypeKeys.LOGOUT;
}

export type AuthState = Immutable.ImmutableObject<UserFragmentFragment>;

const initialState: AuthState = Immutable<UserFragmentFragment>({
  id: "",
  jwt: "",
  username: null,
  email: ""
});

export const auth: Reducer<AuthState> = (
  state = initialState,
  action: ActionType
) => {
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
