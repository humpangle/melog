import * as React from "react";
import jss from "jss";

import Header from "../components/header.component";

const styles = {
  newExperience: {
    flex: 1
  }
};

const { classes } = jss.createStyleSheet(styles).attach();

export const NewExperience = () => {
  return (
    <div className={classes.newExperience}>
      <Header />
      New Experience
    </div>
  );
};

export default NewExperience;
