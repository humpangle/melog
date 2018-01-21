import gql from "graphql-tag";
import userFragment from "./user.fragment";

export const loginMutation = gql`
  mutation Login($user: LoginUserInput!) {
    login(user: $user) {
      ...UserFragment
    }
  }
  ${userFragment}
`;

export default loginMutation;
