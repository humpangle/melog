import gql from "graphql-tag";

const fieldFragment = gql`
  fragment FieldFragment on Field {
    id
    name
    fieldType
  }
`;

const experienceFragment = gql`
  fragment ExperienceFragment on Experience {
    id
    title
    intro
  }
`;

export const createExperienceFieldsCollectionMutation = gql`
  mutation CreateExperienceFieldsCollection(
    $experienceFields: CreateExperienceFieldsCollectionInput!
  ) {
    createExperienceFieldsCollection(experienceFields: $experienceFields) {
      experience {
        ...ExperienceFragment
      }
      fields {
        ...FieldFragment
      }
    }
  }
  ${fieldFragment}
  ${experienceFragment}
`;

export default createExperienceFieldsCollectionMutation;
