import gql from "graphql-tag";

export const fieldFragment = gql`
  fragment FieldFragment on Field {
    id
    name
    fieldType
    insertedAt
  }
`;

export const experienceFragment = gql`
  fragment ExperienceFragment on Experience {
    id
    title
    intro
    insertedAt
  }
`;

export const userExperiencesQuery = gql`
  query Experiences($experience: GetExperiencesInput) {
    experiences(experience: $experience) {
      ...ExperienceFragment

      fields {
        ...FieldFragment
      }
    }
  }

  ${fieldFragment}
  ${experienceFragment}
`;

export default userExperiencesQuery;
