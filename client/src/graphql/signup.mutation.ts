import gql from "graphql-tag";
import userFragment from "./user.fragment";

export const signupMutation = gql`
  mutation Signup($user: CreateUserInput!) {
    createUser(user: $user) {
      ...UserFragment
    }
  }
  ${userFragment}
`;

export default signupMutation;
