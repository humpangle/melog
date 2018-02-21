import gql from "graphql-tag";

import { fieldFragment, experienceFragment } from "./experiences.query";

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
