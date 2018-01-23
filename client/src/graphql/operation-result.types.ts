/* tslint:disable */
//  This file was automatically generated and should not be edited.

// The possible data type for a field
export enum FieldDataType {
  BOOLEAN = "BOOLEAN", // A field value that may be true or false
  DATE = "DATE", // A field value that must be a date
  DATE_TIME = "DATE_TIME", // A field value that must be date time
  DECIMAL = "DECIMAL", // A field value that must be a float
  MULTI_TEXT = "MULTI_TEXT", // A field value that must be multi line text
  NUMBER = "NUMBER", // A field value that must be an integer
  SINGLE_TEXT = "SINGLE_TEXT", // A field value that must be single line text
}


export type CreateExperienceFieldsCollectionInput = {
  // Inputs for the experience to which the fields collection belongs
  experience: CreateExperienceInput,
  // The list of fields belonging to same experience
  fields: Array< SingleField | null >,
  // For authentication in non web contexts
  jwt?: string | null,
};

export type CreateExperienceInput = {
  intro?: string | null,
  // if we are calling from a non-web context e.g. in tests, we can
  // specify the token for authentication. In web context, jwt will be taken
  // from headers
  jwt?: string | null,
  title: string,
};

export type SingleField = {
  // The data type of field. E.g. for a field named 'sleep start', date_time
  fieldType: FieldDataType,
  // The name of the field e.g 'sleep start'
  name: string,
};

export type LoginUserInput = {
  email: string,
  password: string,
};

export type CreateUserInput = {
  email: string,
  password: string,
  username?: string | null,
};

export type CreateExperienceFieldsCollectionMutationVariables = {
  experienceFields: CreateExperienceFieldsCollectionInput,
};

export type CreateExperienceFieldsCollectionMutation = {
  // Create an experience and collection of fields for the new experience.
  createExperienceFieldsCollection:  {
    // Experience to which all fields in the collection belong
    experience:  {
      id: string,
      title: string,
      intro: string | null,
    } | null,
    // The list of fields belonging to same experience
    fields:  Array< {
      id: string,
      name: string,
      fieldType: FieldDataType,
    } | null > | null,
  } | null,
};

export type LoginMutationVariables = {
  user: LoginUserInput,
};

export type LoginMutation = {
  login:  {
    id: string,
    username: string | null,
    email: string,
    jwt: string,
  } | null,
};

export type SignupMutationVariables = {
  user: CreateUserInput,
};

export type SignupMutation = {
  createUser:  {
    id: string,
    username: string | null,
    email: string,
    jwt: string,
  } | null,
};

export type FieldFragmentFragment = {
  id: string,
  name: string,
  fieldType: FieldDataType,
};

export type ExperienceFragmentFragment = {
  id: string,
  title: string,
  intro: string | null,
};

export type UserFragmentFragment = {
  id: string,
  username: string | null,
  email: string,
  jwt: string,
};
