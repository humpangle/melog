/* tslint:disable */
//  This file was automatically generated and should not be edited.

export interface LoginUserInput {
  email: string,
  password: string,
};

export interface CreateUserInput {
  email: string,
  password: string,
  username?: string | null,
};

export interface LoginMutationVariables {
  user: LoginUserInput,
};

export interface LoginMutation {
  login:  {
    id: string,
    username: string | null,
    email: string,
    jwt: string,
  } | null,
};

export interface SignupMutationVariables {
  user: CreateUserInput,
};

export interface SignupMutation {
  createUser:  {
    id: string,
    username: string | null,
    email: string,
    jwt: string,
  } | null,
};

export interface UserFragmentFragment {
  id: string,
  username: string | null,
  email: string,
  jwt: string,
};
