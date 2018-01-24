import * as React from "react";
import TextField from "material-ui/TextField";
import { TextFieldProps } from "material-ui";
import { WrappedFieldProps, GenericFieldHTMLAttributes } from "redux-form";
import jss from "jss";
import { orange500, green500 } from "material-ui/styles/colors";

export const formUtilsStyles = {
  errorStyle: {
    color: orange500
  },

  errorUnderlineStyle: {
    borderColor: orange500
  },

  fieldValidUnderlineStyle: {
    borderColor: green500
  },

  serverError: {
    border: `1px solid ${orange500}`,
    color: orange500,
    padding: "8px",
    borderRadius: "2px"
  }
};

const { classes } = jss.createStyleSheet(formUtilsStyles).attach();

export type FieldComponent =
  | React.StatelessComponent<
      TextFieldProps & WrappedFieldProps & { [key: string]: {} }
    >
  | React.ComponentClass<
      TextFieldProps & WrappedFieldProps & { [key: string]: {} }
    >;

export const inputUnderlineStyle = (failure: boolean, success: boolean) => {
  if (failure) {
    return formUtilsStyles.errorUnderlineStyle;
  }

  if (success) {
    return formUtilsStyles.fieldValidUnderlineStyle;
  }

  return undefined;
};

export const renderServerError = (error: string) =>
  error ? <div className={`${classes.serverError}`}>{error}</div> : undefined;

type FormTextFieldProps = GenericFieldHTMLAttributes &
  TextFieldProps &
  WrappedFieldProps & { [key: string]: {} };

export class FormTextField extends React.PureComponent<FormTextFieldProps> {
  textField: TextField;

  constructor(props: FormTextFieldProps) {
    super(props);
    this.makeTextField = this.makeTextField.bind(this);
  }

  render() {
    const { input, label, meta: { error, dirty }, ...custom } = this.props;

    return (
      <TextField
        hintText={label}
        floatingLabelText={label}
        errorText={dirty && error}
        errorStyle={formUtilsStyles.errorStyle}
        underlineStyle={inputUnderlineStyle(dirty && error, dirty && !error)}
        {...input}
        {...custom}
        ref={this.makeTextField}
      />
    );
  }

  makeTextField(c: TextField) {
    this.textField = c;
  }
}
