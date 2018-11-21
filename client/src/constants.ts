export const ROOT_URL = "/";
export const SIGNUP_URL = "/signup";
export const LOGIN_URL = "/login";
export const NEW_EXPERIENCE_DEF_URL = "/new-experience-def";
export const NEW_EXPERIENCE_URL_ID_PARAM_NAME = ":experienceId";
export const NEW_EXPERIENCE_URL = `/new-experience/${NEW_EXPERIENCE_URL_ID_PARAM_NAME}`;
export const SIGNIN_FORM_NAME = "SIGNIN_FORM";
export const NEW_EXPERIENCE_DEFINITION_FORM_NAME =
  "NEW_EXPERIENCE_DEFINITION_FORM";
export const POSITION_ABSOLUTE = "absolute" as "absolute";
export const POSITION_RELATIVE = "relative" as "relative";
export const HEADER_BG_COLOR = "#24282e";
export const NEW_EXPERIENCE_FORM_NAME = "NEW_EXPERIENCE_FORM";

export const makeNewExpUrl = (id: string) =>
  NEW_EXPERIENCE_URL.replace(NEW_EXPERIENCE_URL_ID_PARAM_NAME, id);
