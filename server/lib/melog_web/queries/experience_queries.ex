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
end