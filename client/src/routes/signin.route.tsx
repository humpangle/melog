import * as React from "react";
import {
  Field,
  reduxForm,
  WrappedFieldProps,
  InjectedFormProps
} from "redux-form";
import TextField from "material-ui/TextField";
import RaisedButton from "material-ui/RaisedButton";
import jss from "jss";
import { orange500, green500 } from "material-ui/styles/colors";
import { RouteComponentProps, Link } from "react-router-dom";

import RenderSubmit from "../components/render-submit.component";
import { SIGNUP_URL, LOGIN_URL } from "../constants";

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

  buttonStyle: {
    color: "rgb(175, 168, 168)"
  },

  link: {
    marginTop: "20px",
    display: "block"
  }
};

const { classes } = jss.createStyleSheet(styles).attach();

const SwitchRoute = ({ signup }: { signup: boolean }) => (
  <Link to={signup ? LOGIN_URL : SIGNUP_URL} className={`${classes.link}`}>
    <RaisedButton style={styles.routeSwitch} buttonStyle={styles.buttonStyle}>
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
    errors.passwordConfirm = "Do not match";
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

type SigninProps = RouteComponentProps<{}> & InjectedFormProps<FormData, {}>;

const signin = (props: SigninProps) => {
  const { handleSubmit, pristine, reset, submitting, invalid, match } = props;

  const isSignup = match.path === SIGNUP_URL;

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

const onSubmit = (values: FormData) => {
  return values;
};

export default reduxForm<FormData>({
  validate,
  form: "signinForm"
})(signin);
