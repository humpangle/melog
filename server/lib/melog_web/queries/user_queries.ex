defmodule MelogWeb.UserQueries do
  def query(:user) do
    """
    query User($user: GetUserInput!) {
      user(user: $user) {
        id
        username
        insertedAt
        updatedAt
        experiences {
          id
          title
          intro
          insertedAt
          updatedAt
        }
      }
    }
    """
  end

  @doc """
  An unauthenticated user should not have access to email field
  """
  def query(:user_error) do
    """
    query User($user: GetUserInput!) {
      user(user: $user) {
        id
        email
      }
    }
    """
  end

  def query(:users) do
    """
    query Users {
      users {
        id
        username
      }
    }
    """
  end

  def mutation(:create_user) do
    """
    mutation CreateUser($user: CreateUserInput!) {
      createUser(user: $user) {
        id
        username
        email
        jwt
        insertedAt
        updatedAt
      }
    }
    """
  end

  def mutation(:login) do
    """
    mutation LoginUser($user: LoginUserInput!) {
      login(user: $user) {
        id
        username
        email
        jwt
      }
    }
    """
  end
end
