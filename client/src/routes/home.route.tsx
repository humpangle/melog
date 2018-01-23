import * as React from "react";
import FloatingActionButton from "material-ui/FloatingActionButton";
import ContentAdd from "material-ui/svg-icons/content/add";
import ContentClear from "material-ui/svg-icons/content/clear";
import jss from "jss";
import { RouteComponentProps, Link } from "react-router-dom";

import Header from "../components/header.component";
import { NEW_EXPERIENCE_URL, POSITION_ABSOLUTE } from "../constants";

const styles = {
  home: {
    flex: 1,
    display: "flex",
    flexDirection: "column",
    height: "100%"
  },

  floatingButton: {
    marginRight: "20px",
    marginBottom: "20px",
    position: POSITION_ABSOLUTE,
    bottom: 0,
    right: 0
  },

  floatingActionsUl: {
    position: POSITION_ABSOLUTE,
    bottom: "80px",
    right: 0,
    marginRight: "20px",
    marginBottom: "20px",
    opacity: 0,
    transition: "opacity 1s",

    "&.show": {
      opacity: 1,
      transition: "opacity 2s"
    }
  },

  floatingActionsLink: {
    display: "flex",
    textDecoration: "none"
  },

  floatingActionsLabel: {
    margin: "auto 20px auto 0",
    backgroundColor: "#212020",
    color: "#fff",
    padding: "8px 15px",
    fontSize: "0.82rem",
    textAlign: "center",
    height: "100%",
    flex: 1
  }
};

const { classes } = jss.createStyleSheet(styles).attach();

const FloatingActions = ({ show }: { show: boolean }) => {
  return (
    <div className={`${classes.floatingActionsUl} ${show ? "show" : ""}`}>
      <Link to={NEW_EXPERIENCE_URL} className={classes.floatingActionsLink}>
        <div className={classes.floatingActionsLabel}>
          New experience definition
        </div>
        <FloatingActionButton mini={true}>
          <ContentAdd />
        </FloatingActionButton>
      </Link>
    </div>
  );
};

interface State {
  showFloatingActions: boolean;
}

type HomeProps = RouteComponentProps<{}>;

export class Home extends React.Component<HomeProps, State> {
  state = { showFloatingActions: false };

  constructor(props: HomeProps) {
    super(props);

    this.toggleFloatingActions = this.toggleFloatingActions.bind(this);
  }

  toggleFloatingActions() {
    this.setState(prev => ({
      ...prev,
      showFloatingActions: !prev.showFloatingActions
    }));
  }

  render() {
    return (
      <div className={classes.home}>
        <Header />

        <FloatingActionButton
          className={classes.floatingButton}
          onClick={this.toggleFloatingActions}
        >
          {this.state.showFloatingActions ? <ContentClear /> : <ContentAdd />}
        </FloatingActionButton>

        <FloatingActions show={this.state.showFloatingActions} />
      </div>
    );
  }
}

export default Home;
