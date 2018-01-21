import gql from "graphql-tag";

export const userFragment = gql`
  fragment UserFragment on User {
    id
    username
    email
    jwt
  }
`;

export default userFragment;
