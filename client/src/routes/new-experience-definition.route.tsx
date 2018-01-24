import * as React from "react";
import _every from "lodash-es/every";
import jss from "jss";
import {
  Field,
  FieldArray,
  reduxForm,
  InjectedFormProps,
  WrappedFieldProps,
  WrappedFieldArrayProps,
  FieldsProps,
  SubmissionError,
  focus,
  FormAction
} from "redux-form";
import SelectField from "material-ui/SelectField";
import MenuItem from "material-ui/MenuItem";
import Paper from "material-ui/Paper";
import IconButton from "material-ui/IconButton";
import FlatButton from "material-ui/FlatButton";
import ContentAdd from "material-ui/svg-icons/content/add";
import ContentDelete from "material-ui/svg-icons/navigation/close";
import { RouteComponentProps } from "react-router-dom";
import { graphql, ChildProps, compose } from "react-apollo";
import { connect } from "react-redux";

import Header from "../components/header.component";
import RenderSubmit from "../components/render-submit.component";
import { ValidationError } from "../utils";
import {
  NEW_EXPERIENCE_DEFINITION_FORM_NAME,
  POSITION_ABSOLUTE,
  POSITION_RELATIVE,
  ROOT_URL,
  HEADER_BG_COLOR
} from "../constants";
import {
  renderTextField,
  renderServerError,
  inputUnderlineStyle,
  formUtilsStyles,
  FormTextField
} from "../components/form-utils.component";
import CREATE_EXPERIENCE_FIELD_MUTATION from "../graphql/create-experience-fields-collection.mutation";
import {
  CreateExperienceFieldsCollectionMutation,
  CreateExperienceFieldsCollectionMutationVariables,
  FieldDataType
} from "../graphql/operation-result.types";
import {
  CreateExperienceFieldsMutationFunc,
  CreateExperienceFieldsMutationProps
} from "../graphql/operation-graphql.types";

const styles = {
  newExperience: {
    flex: 1,
    display: "flex",
    flexDirection: "column",
    overflow: "hidden"
  },

  form: {
    padding: "20px",
    flex: 1,
    overflowX: "none",
    overflowY: "scroll"
  },

  allFieldsError: {
    ...formUtilsStyles.errorStyle,
    marginBottom: "15px"
  },

  fieldContainer: {
    marginBottom: 20,
    marginTop: 10,
    position: POSITION_RELATIVE
  },

  fieldControl: {
    padding: "10px"
  },

  fieldHeader: {
    color: "#fff",
    backgroundColor: HEADER_BG_COLOR,
    padding: "6px"
  },

  fieldStyle: {
    backgroundColor: "inherit"
  },

  fieldDelete: {
    position: POSITION_ABSOLUTE,
    top: "-12px",
    right: "-15px"
  }
};

const { classes } = jss.createStyleSheet(styles).attach();

interface FieldValue {
  name: string;
  fieldType: FieldDataType;
}

interface FieldError {
  name: string;
  fieldType: string;
}

interface FormData {
  experience: {
    title: string;
    intro?: string;
  };

  fields: FieldValue[];
}

const validate = (values: FormData) => {
  const errors: ValidationError = {};
  const experience = values.experience;

  if (!experience) {
    errors.experience = { title: "Required" };
  } else {
    const title = experience.title;

    if (!title) {
      errors.experience = { title: "Required" };
    } else if (title.length < 3) {
      errors.experience = { title: "Too short" };
    }
  }

  const fields = values.fields;

  if (!fields || !fields.length) {
    errors.fields = { _error: "At least one field must be defined" };
  } else {
    const allFieldsErrors = [] as FieldError[];

    fields.forEach((field, fieldIndex) => {
      const singleFieldErrors = {} as FieldError;

      if (!field || !field.name) {
        singleFieldErrors.name = "Required";
        allFieldsErrors[fieldIndex] = singleFieldErrors;
      } else {
        const name = field.name;

        if (name.length < 2) {
          singleFieldErrors.name = "Too short";
          allFieldsErrors[fieldIndex] = singleFieldErrors;
        } else if (
          fields.some(
            (f, i) => f && i !== fieldIndex && !!f.name && f.name === name
          )
        ) {
          singleFieldErrors.name = "This name is not unique";
          allFieldsErrors[fieldIndex] = singleFieldErrors;
        }
      }

      if (!field || !field.fieldType) {
        singleFieldErrors.fieldType = "Required";
        allFieldsErrors[fieldIndex] = singleFieldErrors;
      }
    });

    if (allFieldsErrors.length) {
      errors.fields = allFieldsErrors;
    }
  }

  return errors;
};

interface FromReduxDispatch {
  focus: (form: string, field: string) => FormAction;
}

type OwnProps = RouteComponentProps<{}> & InjectedFormProps<FormData, {}>;

type InputProps = OwnProps &
  CreateExperienceFieldsMutationProps &
  FromReduxDispatch;

type NewExperienceDefinitionProps = ChildProps<
  InputProps,
  CreateExperienceFieldsCollectionMutation
>;

interface State {
  fields: { [key: string]: string };
}

export class NewExperienceDefinition extends React.Component<
  NewExperienceDefinitionProps,
  State
> {
  constructor(props: NewExperienceDefinitionProps) {
    super(props);
    this.onSubmit = this.onSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.renderSelect = this.renderSelect.bind(this);
    this.renderFields = this.renderFields.bind(this);
    this.renderField = this.renderField.bind(this);
    this.focusOnReset = this.focusOnReset.bind(this);
    this.state = { fields: {} };
  }
  async onSubmit(values: FormData) {
    const { experience, fields } = values;
    try {
      const {
        data: { createExperienceFieldsCollection: collection }
      } = await this.props.create({
        experienceFields: {
          experience,
          fields
        }
      });

      this.props.history.replace(ROOT_URL);

      console.log(
        `



      collection`,
        collection,
        `



      `
      );
    } catch (error) {
      const message = error.message as string;

      if (message.includes("Network error")) {
        throw new SubmissionError({
          _error: "You are offline"
        });
      }
    }
  }

  handleChange(name: string, cb?: (val: string) => void) {
    return (_: {}, index: number, value: string) =>
      this.setState(prevState => {
        if (cb) {
          cb(value);
        }

        return {
          ...prevState,
          fields: { ...prevState.fields, [name]: value }
        };
      });
  }

  render() {
    const {
      handleSubmit,
      pristine,
      reset,
      submitting,
      invalid,
      error
    } = this.props;
    return (
      <div className={classes.newExperience}>
        <Header title="New experience definition" />

        <form className={classes.form} onSubmit={handleSubmit(this.onSubmit)}>
          {renderServerError(error)}

          <div>
            <Field
              // https://splitme.net/expense/add
              name="experience.title"
              label="Experience title"
              hintText="E.g. Food"
              autoFocus={true}
              autoComplete="off"
              component={FormTextField}
            />
          </div>

          <div>
            <Field
              name="experience.intro"
              label="Introduction"
              hintText="E.g. To document my eating habits"
              autoComplete="off"
              multiLine={true}
              component={renderTextField}
            />
          </div>

          <FieldArray name="fields" component={this.renderFields} />

          <RenderSubmit
            className={classes.submitBtn}
            reset={reset}
            submitting={submitting}
            text="Save"
            pristine={pristine}
            invalid={invalid}
            focusOnReset={this.focusOnReset}
          />
        </form>
      </div>
    );
  }

  focusOnReset() {
    this.props.focus(NEW_EXPERIENCE_DEFINITION_FORM_NAME, "experience.title");
  }

  renderSelect({ input, meta: { error, dirty } }: WrappedFieldProps) {
    const cb = (val: string) => input.onChange(val);
    return (
      <SelectField
        floatingLabelText="Field Type"
        errorText={dirty && error}
        underlineStyle={inputUnderlineStyle(dirty && error, dirty && !error)}
        errorStyle={formUtilsStyles.errorStyle}
        value={input.value}
        onChange={this.handleChange(input.name, cb)}
      >
        <MenuItem value="BOOLEAN" primaryText="Yes/No" />
        <MenuItem value="DATE" primaryText="Date" />
        <MenuItem value="DATE_TIME" primaryText="Datetime" />
        <MenuItem value="DECIMAL" primaryText="Decimal e.g 5.0" />
        <MenuItem value="MULTI_TEXT" primaryText="Multi-line text" />
        <MenuItem value="NUMBER" primaryText="Number e.g 25" />
        <MenuItem value="SINGLE_TEXT" primaryText="Single-line text" />
      </SelectField>
    );
  }

  renderFields({
    fields,
    meta: { error, dirty, invalid }
  }: WrappedFieldArrayProps<FieldValue>) {
    const onClick = () => fields.push();

    const renderError = () => {
      if (dirty && error) {
        return <div className={`${classes.allFieldsError}`}>{error}</div>;
      }

      return undefined;
    };

    const disableAdd = () => {
      if (invalid) {
        return false;
      }

      return !(fields.getAll() && _every(fields.getAll(), Boolean));
    };

    return (
      <div>
        {fields.map(this.renderField)}

        <FlatButton
          label="Add field"
          labelPosition="before"
          primary={true}
          icon={<ContentAdd />}
          onClick={onClick}
          style={{ marginBottom: "10px" }}
          disabled={disableAdd()}
        />

        {renderError()}
      </div>
    );
  }

  renderField(name: string, index: number, fields: FieldsProps<FieldValue>) {
    const onClick = () => fields.remove(index);

    return (
      <Paper
        key={name}
        style={styles.fieldStyle}
        zDepth={1}
        rounded={false}
        className={`${classes.fieldContainer}`}
      >
        <div className={`${classes.fieldHeader}`}>
          <span>{`Field #${index + 1}`}</span>

          <IconButton style={styles.fieldDelete} onClick={onClick}>
            <ContentDelete color="#fff" />
          </IconButton>
        </div>

        <div className={`${classes.fieldControl}`}>
          <Field
            name={`${name}.name`}
            label="Field name"
            autoComplete="off"
            component={renderTextField}
          />

          <Field
            name={`${name}.fieldType`}
            value={this.state.fields.fieldType}
            component={this.renderSelect}
          />
        </div>
      </Paper>
    );
  }
}

const newExperienceDefinitionForm = reduxForm<FormData>({
  validate,
  form: NEW_EXPERIENCE_DEFINITION_FORM_NAME
});

const fromRedux = connect<{}, FromReduxDispatch, OwnProps, {}>(null, { focus });

const graphqlCreate = graphql<
  CreateExperienceFieldsCollectionMutation,
  InputProps
>(CREATE_EXPERIENCE_FIELD_MUTATION, {
  props: props => {
    const mutate = props.mutate as CreateExperienceFieldsMutationFunc;

    return {
      create: (params: CreateExperienceFieldsCollectionMutationVariables) =>
        mutate({
          variables: params
        })
    };
  }
});

export default compose(newExperienceDefinitionForm, fromRedux, graphqlCreate)(
  NewExperienceDefinition
);
