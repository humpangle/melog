import * as React from "react";
import { RouteComponentProps } from "react-router-dom";
import { ChildProps, graphql, compose } from "react-apollo";
import {
  Field,
  reduxForm,
  InjectedFormProps,
  // FieldArray,
  FieldsProps,
  WrappedFieldArrayProps
} from "redux-form";
import jss from "jss";
import moment from "moment";
import { RadioButton } from "material-ui/RadioButton";

import Header from "../components/header.component";
import { Loading, AppRouteClassName } from "../App";
import { ExperienceFieldsMetaOnlyQueryWithData } from "../graphql/ops.types";
import {
  ExperienceFieldsMetaOnlyQuery,
  ExperienceFieldsMetaOnlyFragmentFragment,
  ExperienceFieldsMetaOnlyFieldFragmentFragment,
  FieldDataType
} from "../graphql/gen.types";
import EXPERIENCE_FIELDS_ONLY_QUERY from "../graphql/experience-fields-meta-only.query";
import {
  FormTextField,
  FormDateTimePickerField,
  FormRadioGroup,
  FormDatePickerField
} from "../components/form-utils.component";
import { NEW_EXPERIENCE_FORM_NAME } from "../constants";
import RenderSubmit from "../components/render-submit.component";

const DATETIME_FORMAT = "ddd DD/MMM/YY HH:mm A";
const DATEFORMAT = "ddd DD/MMM/YY";

const formatDate = (d: Date) => moment(d).format(DATEFORMAT);

const styles = {
  formControllsContainer: {
    padding: 5
  }
};

const { classes } = jss.createStyleSheet(styles).attach();

interface FormData {
  // tslint:disable-next-line:no-any
  [key: string]: any;
}

const validate = (values: FormData) => {
  const errors: { [key: string]: string } = {};

  for (const [key, value] of Object.entries(values)) {
    const { fieldType } = JSON.parse(key) as {
      slug: string;
      fieldType: FieldDataType;
    };

    switch (fieldType) {
      case FieldDataType.DATE_TIME:
        if (!value || !moment(value, DATETIME_FORMAT).isValid()) {
          errors[key] = "Invalid datetime";
        }
        break;

      case FieldDataType.DATE:
        if (!value || !moment(value, DATEFORMAT).isValid()) {
          errors[key] = "Invalid date";
        }
        break;

      case FieldDataType.BOOLEAN:
        if (!value) {
          errors[key] = "Select yes or no";
        }
        break;

      case FieldDataType.NUMBER:
      case FieldDataType.DECIMAL:
        if (value === "" || isNaN(+value)) {
          errors[key] = "Not a valid number";
        }
        break;

      default:
        if (!value) {
          errors[key] = "A value is required";
        }
    }
  }

  return errors;
};

type OwnProps = InjectedFormProps<FormData, {}> &
  RouteComponentProps<{ experienceId: string }>;

type InputProps = ExperienceFieldsMetaOnlyQueryWithData & OwnProps;

type NewExperienceProps = ChildProps<InputProps, ExperienceFieldsMetaOnlyQuery>;

interface FieldInputRef {
  // tslint:disable-next-line:no-any
  instance?: any;
  // tslint:disable-next-line:no-any
  input?: any;
  // tslint:disable-next-line:no-any
  component?: any;
  fieldType: FieldDataType;
}

interface NewExperienceState {
  fieldInstances: {
    [key: string]: FieldInputRef;
  };
}

class NewExperience extends React.Component<
  NewExperienceProps,
  NewExperienceState
> {
  fields: ExperienceFieldsMetaOnlyFieldFragmentFragment[];

  constructor(props: NewExperienceProps) {
    super(props);
    this.state = {
      fieldInstances: {}
    };
    this.onSubmit = this.onSubmit.bind(this);
    this.reset = this.reset.bind(this);
    this.renderField = this.renderField.bind(this);
    this.renderField1 = this.renderField1.bind(this);
    this.renderFields = this.renderFields.bind(this);
    this.getFieldInstance = this.getFieldInstance.bind(this);
  }

  render() {
    const experience = this.props
      .experience as ExperienceFieldsMetaOnlyFragmentFragment;

    if (this.props.loading && !experience) {
      return <Loading />;
    }

    const fields = experience.fields as ExperienceFieldsMetaOnlyFieldFragmentFragment[];
    this.fields = fields;

    const { pristine, reset, submitting, invalid, handleSubmit } = this.props;

    return (
      <div className={`${AppRouteClassName}`}>
        <Header title="New experience" />
        <span>{`${experience.title}`}</span>

        <form
          className={`${classes.formControllsContainer}`}
          onSubmit={handleSubmit(this.onSubmit)}
        >
          {fields.map(this.renderField)}

          <RenderSubmit
            className={classes.submitBtn}
            reset={this.reset(reset)}
            submitting={submitting}
            text="Save"
            pristine={pristine}
            invalid={invalid}
          />
        </form>
      </div>
    );
  }

  renderFields({
    fields
  }: WrappedFieldArrayProps<ExperienceFieldsMetaOnlyFieldFragmentFragment>) {
    this.fields.forEach(f => fields.push(f));

    return <div>{fields.map(this.renderField1)}</div>;
  }

  renderField1(
    fieldsName: string,
    index: number,
    fields: FieldsProps<ExperienceFieldsMetaOnlyFieldFragmentFragment>
  ) {
    const { name, slug, fieldType } = fields.get(index);
    // tslint:disable-next-line:no-any
    const ref = this.getFieldInstance(slug, fieldType) as any;

    const attrs = {
      key: slug,
      name: JSON.stringify({ slug, fieldType }),
      label: name,
      withRef: true,
      ref
    };

    switch (fieldType) {
      case FieldDataType.NUMBER:
        return (
          <Field
            {...attrs}
            component={FormTextField}
            autoComplete="off"
            hintText="E.g. 25"
          />
        );

      case FieldDataType.DECIMAL:
        return (
          <Field
            {...attrs}
            component={FormTextField}
            autoComplete="off"
            hintText="E.g. 25.0"
          />
        );

      case FieldDataType.SINGLE_TEXT:
        return (
          <Field
            {...attrs}
            component={FormTextField}
            autoComplete="off"
            hintText="Single line text"
          />
        );

      case FieldDataType.MULTI_TEXT:
        return (
          <Field
            {...attrs}
            component={FormTextField}
            autoComplete="off"
            hintText="Text spanning multiple lines"
            multiLine={true}
          />
        );

      case FieldDataType.DATE_TIME:
        return (
          <Field
            {...attrs}
            component={FormDateTimePickerField}
            hintText="Click to select date"
            readOnly="readonly"
            formating={DATETIME_FORMAT}
          />
        );

      case FieldDataType.DATE:
        return (
          <Field
            {...attrs}
            component={FormDatePickerField}
            hintText="Click to select date"
            readOnly={true}
            formatDate={formatDate}
          />
        );

      case FieldDataType.BOOLEAN:
        return (
          <Field {...attrs} component={FormRadioGroup}>
            <RadioButton value="true" label="Yes" />
            <RadioButton value="false" label="No" />
          </Field>
        );

      default:
        return <div />;
    }
  }

  renderField(f: ExperienceFieldsMetaOnlyFieldFragmentFragment) {
    const { name, slug, fieldType } = f;

    const attrs = {
      key: slug,
      name: JSON.stringify({ slug, fieldType }),
      label: name,
      withRef: true,
      ref: this.getFieldInstance(slug, fieldType)
    };

    switch (fieldType) {
      case FieldDataType.NUMBER:
        return (
          <Field
            {...attrs}
            component={FormTextField}
            autoComplete="off"
            hintText="E.g. 25"
          />
        );

      case FieldDataType.DECIMAL:
        return (
          <Field
            {...attrs}
            component={FormTextField}
            autoComplete="off"
            hintText="E.g. 25.0"
          />
        );

      case FieldDataType.SINGLE_TEXT:
        return (
          <Field
            {...attrs}
            component={FormTextField}
            autoComplete="off"
            hintText="Single line text"
          />
        );

      case FieldDataType.MULTI_TEXT:
        return (
          <Field
            {...attrs}
            component={FormTextField}
            autoComplete="off"
            hintText="Text spanning multiple lines"
            multiLine={true}
          />
        );

      case FieldDataType.DATE_TIME:
        return (
          <Field
            {...attrs}
            component={FormDateTimePickerField}
            hintText="Click to select date"
            readOnly="readonly"
            formating={DATETIME_FORMAT}
          />
        );

      case FieldDataType.DATE:
        return (
          <Field
            {...attrs}
            component={FormDatePickerField}
            hintText="Click to select date"
            readOnly={true}
            formatDate={formatDate}
          />
        );

      case FieldDataType.BOOLEAN:
        return (
          <Field {...attrs} component={FormRadioGroup}>
            <RadioButton value="true" label="Yes" />
            <RadioButton value="false" label="No" />
          </Field>
        );

      default:
        return <div />;
    }
  }

  getFieldInstance(slug: string, fieldType: FieldDataType) {
    return (c: Field) => {
      const fieldInstances = this.state.fieldInstances;
      const instance = fieldInstances[slug];

      if (instance) {
        return;
      }

      // tslint:disable-next-line:no-any
      const component = c.getRenderedComponent() as any;

      if (!component || !component.instance) {
        return;
      }

      const components = { fieldType } as FieldInputRef;

      switch (fieldType) {
        case FieldDataType.DATE_TIME:
          components.instance = component.instance;
          components.input = component.props.input;
          components.component = component;
          break;

        case FieldDataType.DATE:
          components.instance = component.instance;
          components.input = component.props.input;
          break;

        case FieldDataType.NUMBER:
        case FieldDataType.BOOLEAN:
          components.input = component.props.input;
          break;
      }

      fieldInstances[slug] = components;

      this.setState({ fieldInstances });
    };
  }

  reset(reset: () => void) {
    return () => {
      const fieldInstances = this.state.fieldInstances;

      for (const slug of Object.keys(fieldInstances)) {
        const { instance, fieldType, input } = fieldInstances[slug];

        switch (fieldType) {
          case FieldDataType.DATE_TIME:
            if (instance) {
              instance.clearState();
            }
            break;

          case FieldDataType.DATE:
            if (input) {
              input.onChange(null);
            }
            break;
        }
      }

      return reset();
    };
  }

  async onSubmit(values: FormData) {
    console.log(
      `



    formdata`,
      values,
      `



    `
    );
  }
}

const graphqlExperiences = graphql<ExperienceFieldsMetaOnlyQuery, InputProps>(
  EXPERIENCE_FIELDS_ONLY_QUERY,
  {
    props: props => {
      const data = props.data as ExperienceFieldsMetaOnlyQueryWithData;
      return data;
    },

    options: ownProps => {
      return {
        variables: { experience: { id: ownProps.match.params.experienceId } }
      };
    }
  }
);

const newExperienceForm = reduxForm<FormData>({
  validate,
  form: NEW_EXPERIENCE_FORM_NAME
});

export default compose(newExperienceForm, graphqlExperiences)(NewExperience);
