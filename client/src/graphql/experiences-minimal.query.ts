import gql from "graphql-tag";

import experienceFragment from "./experience-minimal.fragment";

export const experiencesMinimalQuery = gql`
  query ExperiencesMinimal($experience: GetExperiencesInput) {
    experiences(experience: $experience) {
      ...ExperienceFragment
    }
  }

  ${experienceFragment}
`;

export default experiencesMinimalQuery;
