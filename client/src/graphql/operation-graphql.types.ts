import { ApolloQueryResult } from "apollo-client-preset";
import { MutationFunc, QueryProps } from "react-apollo";

import {
  LoginMutationVariables,
  LoginMutation,
  SignupMutation,
  SignupMutationVariables,
  CreateExperienceFieldsCollectionMutation,
  CreateExperienceFieldsCollectionMutationVariables,
  ExperiencesQuery,
  ExperiencesQueryVariables
} from "./operation-result.types";

export type ExperiencesQueryWithData = QueryProps<ExperiencesQueryVariables> &
  ExperiencesQuery;

export type CreateExperienceFieldsMutationFunc = MutationFunc<
  CreateExperienceFieldsCollectionMutation,
  CreateExperienceFieldsCollectionMutationVariables
>;

export type CreateExperienceFieldsMutationProps = CreateExperienceFieldsMutationFunc & {
  create: (
    params: CreateExperienceFieldsCollectionMutationVariables
  ) => Promise<ApolloQueryResult<CreateExperienceFieldsCollectionMutation>>;
};

export type LoginMutationFunc = MutationFunc<
  LoginMutation,
  LoginMutationVariables
>;

export type LoginMutationProps = LoginMutationFunc & {
  login: (
    params: LoginMutationVariables
  ) => Promise<ApolloQueryResult<LoginMutation>>;
};

export type SignupMutationFunc = MutationFunc<
  SignupMutation,
  SignupMutationVariables
>;

export type SignupMutationProps = SignupMutationFunc & {
  signup: (
    params: SignupMutationVariables
  ) => Promise<ApolloQueryResult<SignupMutation>>;
};
