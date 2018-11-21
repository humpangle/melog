import gql from "graphql-tag";

const fieldFragment = gql`
  fragment ExperienceFieldsMetaOnlyFieldFragment on Field {
    name
    fieldType
    slug
  }
`;

const experienceFieldsMetaOnlyFragment = gql`
  fragment ExperienceFieldsMetaOnlyFragment on Experience {
    title
    fields {
      ...ExperienceFieldsMetaOnlyFieldFragment
    }
  }

  ${fieldFragment}
`;

export const experienceFieldsMetaOnlyQuery = gql`
  query ExperienceFieldsMetaOnly($experience: GetExperienceInput!) {
    experience(experience: $experience) {
      ...ExperienceFieldsMetaOnlyFragment
    }
  }

  ${experienceFieldsMetaOnlyFragment}
`;

export default experienceFieldsMetaOnlyQuery;
