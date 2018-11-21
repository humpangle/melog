import { client } from "../apollo-setup";
import { LogoutAction, SetCurrentUserAction } from "../reducers/auth.reducer";
import { ActionTypeKeys } from "../reducers/index.reducer";
import { UserFragmentFragment } from "../graphql/gen.types";

export type LogoutActionFunc = () => LogoutAction;

export const logout: LogoutActionFunc = () => {
  setTimeout(client.resetStore);
  return {
    type: ActionTypeKeys.LOGOUT
  };
};

export type SetCurrentUserActionFunc = (
  user: UserFragmentFragment
) => SetCurrentUserAction;

export const setCurrentUser: SetCurrentUserActionFunc = (
  user: UserFragmentFragment
) => ({
  user,
  type: ActionTypeKeys.SET_CURRENT_USER
});
