import gql from "graphql-tag";

import experienceFragment from "./experience-minimal.fragment";
import fieldFragment from "./field.fragment";

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
