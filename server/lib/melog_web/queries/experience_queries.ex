defmodule MelogWeb.ExperienceQueries do
  def mutation(:create_experience) do
    """
    mutation CreateExperienceMutation($experience: CreateExperienceInput!) {
      createExperience(experience: $experience) {
        id
        title
        intro
        insertedAt
        updatedAt
        user {
          id
          username
        }
      }
    }
    """
  end

  def query(:experience) do
    """
    query Experience($experience: GetExperienceInput!) {
      experience(experience: $experience) {
        id
        title
        intro
      }
    }
    """
  end

  def query(:experiences) do
    """
    query Experiences($experience: GetExperiencesInput!) {
      experiences(experience: $experience) {
        id
        title
        intro
      }
    }
    """
  end
end
