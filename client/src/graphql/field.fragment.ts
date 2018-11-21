import gql from "graphql-tag";

export const fieldFragment = gql`
  fragment FieldFragment on Field {
    id
    name
    fieldType
    insertedAt
    slug
  }
`;

export default fieldFragment;
