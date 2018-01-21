import * as React from "react";
import {
  Field,
  reduxForm,
  WrappedFieldProps,
  InjectedFormProps,
  SubmissionError
} from "redux-form";
import TextField from "material-ui/TextField";
import RaisedButton from "material-ui/RaisedButton";
import jss from "jss";
import { orange500, green500 } from "material-ui/styles/colors";
import { RouteComponentProps, Link } from "react-router-dom";
import { graphql, ChildProps, compose } from "react-apollo";
import { connect } from "react-redux";

import RenderSubmit from "../components/render-submit.component";
import {
  SIGNUP_URL,
  LOGIN_URL,
  SIGNIN_FORM_NAME,
  ROOT_URL
} from "../constants";
import LOGIN_MUTATION from "../graphql/login.mutation";
import SIGNUP_MUTATION from "../graphql/signup.mutation";
import {
  LoginMutation,
  LoginMutationVariables,
  SignupMutation,
  SignupMutationVariables
} from "../graphql/operation-result-types";
import {
  LoginMutationProps,
  LoginMutationFunc,
  SignupMutationProps,
  SignupMutationFunc
} from "../graphql/operation-graphql-types";
import {
  setCurrentUser,
  SetCurrentUserActionFunc
} from "../actions/auth.action";

const processGraphQlError = (error: string) => {
  const pattern = /(\[.+:\s.+\])/g;
  const pattern1 = /\[(.+):\s(.+)\]/g;

  if (!pattern.test(error)) {
    return { _error: error.replace("GraphQL error: ", "") };
  }

  const errors = {};

  error.replace(pattern, (_, p) => {
    const p1 = pattern1.exec(p);
    if (p1) {
      const m = p1[2];
      errors[p1[1]] = m[0].toUpperCase() + m.slice(1);
    }
    return "";
  });

  return errors;
};

const styles = {
  container: {
    display: "flex",
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
    padding: "20px"
  },

  form: {
    flex: 1
  },

  submitBtn: {
    marginTop: "20px"
  },

  errorStyle: {
    color: orange500
  },

  errorUnderlineStyle: {
    borderColor: orange500
  },

  fieldValidUnderlineStyle: {
    borderColor: green500
  },

  routeSwitch: {
    display: "block"
  },

  link: {
    marginTop: "20px",
    display: "block"
  },

  serverError: {
    border: `1px solid ${orange500}`,
    color: orange500,
    padding: "8px",
    borderRadius: "2px"
  }
};

const { classes } = jss.createStyleSheet(styles).attach();

const SwitchRoute = ({ signup }: { signup: boolean }) => (
  <Link to={signup ? LOGIN_URL : SIGNUP_URL} className={`${classes.link}`}>
    <RaisedButton style={styles.routeSwitch}>
      {signup ? "Login to your account" : "Create an account"}
    </RaisedButton>
  </Link>
);

interface FormData {
  email?: string;
  password?: string;
  passwordConfirm?: string;
}

interface ValidationError {
  [key: string]: string;
}

const validate = (values: FormData) => {
  const errors: ValidationError = {};
  const requiredFields = ["email", "password", "passwordConfirm"];

  requiredFields.forEach(f => {
    if (!values[f]) {
      errors[f] = "Required";
    }
  });

  const { email, password, passwordConfirm } = values;

  if (email && !/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.test(email)) {
    errors.email = "Invalid email address";
  }

  if (password && password.length < 3) {
    errors.password = "Too short";
  }

  if (password !== passwordConfirm) {
    errors.passwordConfirm = "Passwords don't match";
  }

  return errors;
};

interface RenderArg {
  label: string;
}

const renderTextField: React.StatelessComponent<
  WrappedFieldProps & RenderArg
> = props => {
  const { input, label, meta: { error, dirty }, ...custom } = props;
  const underlineStyle = () => {
    if (dirty && error) {
      return styles.errorUnderlineStyle;
    }

    if (dirty && !error) {
      return styles.fieldValidUnderlineStyle;
    }

    return undefined;
  };

  return (
    <TextField
      hintText={label}
      floatingLabelText={label}
      errorText={dirty && error}
      errorStyle={styles.errorStyle}
      underlineStyle={underlineStyle()}
      {...input}
      {...custom}
    />
  );
};

interface FromReduxState {
  isSignup: boolean;
  graphlResponse: "login" | "createUser";
}

interface FromReduxDispatch {
  setCurrentUser: SetCurrentUserActionFunc;
}

type OwnProps = RouteComponentProps<{}> & InjectedFormProps<FormData, {}>;

type InputProps = OwnProps &
  LoginMutationProps &
  SignupMutationProps &
  FromReduxState &
  FromReduxDispatch;

type SigninProps = ChildProps<InputProps, LoginMutation & SignupMutation>;

const signin = (props: SigninProps) => {
  const {
    handleSubmit,
    pristine,
    reset,
    submitting,
    invalid,
    login,
    signup,
    isSignup,
    graphlResponse,
    error,
    history
  } = props;

  const onSubmit = async (values: FormData) => {
    const { email = "", password = "" } = values;

    try {
      const { data } = await (isSignup
        ? signup({ user: { email, password } })
        : login({ user: { email, password } }));

      const user = data[graphlResponse];
      props.setCurrentUser(user);
      history.replace(ROOT_URL);
    } catch (error) {
      const message = error.message as string;

      if (message.includes("GraphQL error")) {
        throw new SubmissionError(processGraphQlError(message));
      }

      if (message.includes("Network error")) {
        throw new SubmissionError({
          _error: "You are offline"
        });
      }
    }
  };

  const renderPasswordConfirm = () => {
    if (isSignup) {
      return (
        <div>
          <Field
            type="password"
            name="passwordConfirm"
            label="Repeat Password"
            component={renderTextField}
          />
        </div>
      );
    }

    return undefined;
  };

  return (
    <div className={classes.container}>
      <form className={classes.form} onSubmit={handleSubmit(onSubmit)}>
        {error ? (
          <div className={`${classes.serverError}`}>{error}</div>
        ) : (
          undefined
        )}

        <div>
          <Field
            name="email"
            label="Email"
            autoFocus={true}
            autoComplete="off"
            component={renderTextField}
          />
        </div>

        <div>
          <Field
            type="password"
            name="password"
            label="Password"
            component={renderTextField}
          />
        </div>

        {renderPasswordConfirm()}

        <RenderSubmit
          className={classes.submitBtn}
          reset={reset}
          submitting={submitting}
          text={isSignup ? "Sign Up" : "Login"}
          pristine={pristine}
          invalid={invalid}
        />

        <SwitchRoute signup={isSignup} />
      </form>
    </div>
  );
};

const signinForm = reduxForm<FormData>({
  validate,
  form: SIGNIN_FORM_NAME
});

const graphqlLogin = graphql<LoginMutation, InputProps>(LOGIN_MUTATION, {
  props: props => {
    const mutate = props.mutate as LoginMutationFunc;

    return {
      login: (params: LoginMutationVariables) =>
        mutate({
          variables: params
        })
    };
  }
});

const graphqlSignup = graphql<SignupMutation, InputProps>(SIGNUP_MUTATION, {
  props: props => {
    const mutate = props.mutate as SignupMutationFunc;

    return {
      signup: (params: SignupMutationVariables) =>
        mutate({
          variables: params
        })
    };
  }
});

const fromRedux = connect<{}, FromReduxDispatch, OwnProps, {}>(
  (_, ownProps) => {
    const isSignup = ownProps.match.path === SIGNUP_URL;
    return {
      isSignup,
      graphlResponse: isSignup ? "createUser" : "login"
    };
  },
  {
    setCurrentUser
  }
);

export default compose(signinForm, fromRedux, graphqlLogin, graphqlSignup)(
  signin
);
