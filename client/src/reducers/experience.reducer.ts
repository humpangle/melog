import Immutable from "seamless-immutable";
import { Reducer, combineReducers } from "redux";

import { ActionTypeKeys, ActionType } from "./index.reducer";
import {
  ExperienceFragmentFragment,
  FieldFragmentFragment
} from "../graphql/gen.types";

export interface SetExperienceFieldsCollectionAction {
  type: ActionTypeKeys.ADD_EXPERIENCE;
  experience: Experience;
}

export interface Experience {
  experience: ExperienceFragmentFragment;
  fields: FieldFragmentFragment[];
}

export type ExperienceState = Immutable.ImmutableObject<Experience>;

export type ExperienceIds = string[];

export interface Experiences {
  [key: string]: ExperienceState;
}

export type ExperiencesState = Immutable.ImmutableObject<Experiences>;

export const experienceIds: Reducer<ExperienceIds> = (
  state = [],
  action: ActionType
) => {
  switch (action.type) {
    case ActionTypeKeys.ADD_EXPERIENCE:
      return [...state, action.experience.experience.id];

    default:
      return state;
  }
};

export const experiences: Reducer<ExperiencesState> = (
  state = Immutable({} as Experiences),
  action: ActionType
) => {
  switch (action.type) {
    case ActionTypeKeys.ADD_EXPERIENCE:
      const id = action.experience.experience.id;
      return state.merge({ [id]: Immutable(action.experience) });

    default:
      return state;
  }
};

export default combineReducers({ experiences, experienceIds });
