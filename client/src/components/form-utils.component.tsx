import * as React from "react";
import TextField from "material-ui/TextField";
import DateTimePicker from "material-ui-datetimepicker";
import DatePickerDialog from "material-ui/DatePicker/DatePickerDialog";
import TimePickerDialog from "material-ui/TimePicker/TimePickerDialog";
import DatePicker from "material-ui/DatePicker";
import {
  TextFieldProps,
  DatePickerProps,
  TimePickerProps,
  RadioButtonGroupProps
} from "material-ui";
import { RadioButtonGroup } from "material-ui/RadioButton";
import {
  WrappedFieldProps,
  GenericFieldHTMLAttributes,
  WrappedFieldInputProps,
  WrappedFieldMetaProps
} from "redux-form";
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

export type FormFieldsProps = {
  names: string[];
} & {
  [key: string]: {
    input: WrappedFieldInputProps;
    meta: WrappedFieldMetaProps;
  };
};

export interface FormUtilsBase<Instance> {
  instance: Instance;
}

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

export class FormTextField extends React.PureComponent<FormTextFieldProps>
  implements FormUtilsBase<TextField> {
  instance: TextField;

  constructor(props: FormTextFieldProps) {
    super(props);
    this.makeInstance = this.makeInstance.bind(this);
  }

  render() {
    const { input, label, meta: { error, dirty }, ...custom } = this.props;

    return (
      <TextField
        floatingLabelText={label}
        errorText={dirty && error}
        errorStyle={formUtilsStyles.errorStyle}
        underlineStyle={inputUnderlineStyle(dirty && error, dirty && !error)}
        {...input}
        {...custom}
        ref={this.makeInstance}
      />
    );
  }

  makeInstance(c: TextField) {
    this.instance = c;
  }
}

type FormDateTimePickerFieldProps = GenericFieldHTMLAttributes &
  DatePickerProps &
  TimePickerProps &
  WrappedFieldProps & { [key: string]: {} };

interface FormDateTimePickerFieldState {
  date: Date | undefined;
}

// tslint:disable-next-line:max-classes-per-file
export class FormDateTimePickerField extends React.PureComponent<
  FormDateTimePickerFieldProps,
  FormDateTimePickerFieldState
> implements FormUtilsBase<DateTimePicker> {
  instance: DateTimePicker;
  input: WrappedFieldInputProps;

  constructor(props: FormDateTimePickerFieldProps) {
    super(props);

    this.setDate = this.setDate.bind(this);
    this.makeInstance = this.makeInstance.bind(this);
  }

  setDate(date: Date) {
    this.input.onChange(date);
  }

  render() {
    const { label, input, meta: { error, dirty }, ...custom } = this.props;
    this.input = input;

    const formating = custom.formating as string;
    const format = formating || "MMM DD, YYYY hh:mm A";

    return (
      <DateTimePicker
        name={input.name}
        floatingLabelText={label}
        errorText={dirty && error}
        errorStyle={formUtilsStyles.errorStyle}
        underlineStyle={inputUnderlineStyle(dirty && error, dirty && !error)}
        onChange={this.setDate}
        DatePicker={DatePickerDialog}
        TimePicker={TimePickerDialog}
        clearIcon={null}
        format={format}
        {...custom}
        ref={this.makeInstance}
      />
    );
  }

  makeInstance(c: DateTimePicker) {
    this.instance = c;
  }
}

type RadioGroupFieldProps = GenericFieldHTMLAttributes &
  RadioButtonGroupProps &
  WrappedFieldProps & { [key: string]: {} };

// tslint:disable-next-line:max-classes-per-file
export class FormRadioGroup extends React.PureComponent<RadioGroupFieldProps>
  implements FormUtilsBase<RadioButtonGroup> {
  instance: RadioButtonGroup;

  constructor(props: RadioGroupFieldProps) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
    this.makeInstance = this.makeInstance.bind(this);
  }

  render() {
    const { input, ...rest } = this.props;
    return (
      <RadioButtonGroup
        {...input}
        {...rest}
        valueSelected={input.value}
        onChange={this.handleChange(input)}
        ref={this.makeInstance}
      />
    );
  }

  handleChange(input: WrappedFieldInputProps) {
    return (event: {}, value: string) => input.onChange(value);
  }

  makeInstance(c: RadioButtonGroup) {
    this.instance = c;
  }
}

type FormDatePickerFieldProps = GenericFieldHTMLAttributes &
  DatePickerProps &
  WrappedFieldProps & { [key: string]: {} };

interface FormDatePickerFieldState {
  date: string;
}

// tslint:disable-next-line:max-classes-per-file
export class FormDatePickerField extends React.PureComponent<
  FormDatePickerFieldProps,
  FormDatePickerFieldState
> implements FormUtilsBase<DatePicker> {
  instance: DatePicker;
  input: WrappedFieldInputProps;

  constructor(props: FormDatePickerFieldProps) {
    super(props);

    this.makeInstance = this.makeInstance.bind(this);
    this.handleChange = this.handleChange.bind(this);
  }

  render() {
    const { label, input, meta: { error, dirty }, ...custom } = this.props;
    this.input = input;

    return (
      <DatePicker
        name={input.name}
        floatingLabelText={label}
        errorText={dirty && error}
        errorStyle={formUtilsStyles.errorStyle}
        underlineStyle={inputUnderlineStyle(dirty && error, dirty && !error)}
        value={input.value ? input.value : null}
        {...custom}
        ref={this.makeInstance}
        onChange={this.handleChange}
      />
    );
  }

  handleChange(event: void, d: Date) {
    this.input.onChange(d);
  }

  makeInstance(c: DatePicker) {
    this.instance = c;
  }
}
