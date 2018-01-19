import * as React from "react";
import { InjectedFormProps } from "redux-form";
import jss from "jss";
import RaisedButton from "material-ui/RaisedButton";

const disabledBtn = {
  pointerEvents: "none"
};

const styles = {
  container: {
    display: "flex"
  },

  submit: {
    flex: 1,
    "&:disabled": disabledBtn
  },

  send: {
    marginRight: "5px"
  },

  reset: {
    marginLeft: "4rem",
    "&:disabled": disabledBtn
  }
};

const { classes } = jss.createStyleSheet(styles).attach();

interface OtherProps {
  text: string;
  className?: string;
}

type Props = OtherProps & Partial<InjectedFormProps>;

const RenderSubmit = ({
  reset,
  submitting,
  pristine,
  invalid,
  className,
  text
}: Props) => (
  <div className={`${classes.container} ${className || ""}`}>
    <RaisedButton
      primary={true}
      className={`${classes.submit}`}
      type="submit"
      disabled={pristine || invalid || submitting}
    >
      <span className={`fa fa-send ${classes.send}`} />
      {submitting ? "Submitting..." : text}
    </RaisedButton>
    <RaisedButton
      className={`${classes.reset}`}
      disabled={submitting}
      onClick={reset}
    >
      Reset
    </RaisedButton>
  </div>
);

export default RenderSubmit;
