import * as React from "react";
import FloatingActionButton from "material-ui/FloatingActionButton";
import ContentAdd from "material-ui/svg-icons/content/add";
import ContentClear from "material-ui/svg-icons/content/clear";
import jss from "jss";
import { RouteComponentProps, Link } from "react-router-dom";
import { ChildProps, graphql, compose } from "react-apollo";
import { connect } from "react-redux";
// import {
//   List
//   // ListItem
// } from "material-ui/List";
import Avatar from "material-ui/Avatar";
import randomColor from "randomcolor";
import { grey400 } from "material-ui/styles/colors";
import IconButton from "material-ui/IconButton";
import MoreVertIcon from "material-ui/svg-icons/navigation/more-vert";
import IconMenu from "material-ui/IconMenu";
import MenuItem from "material-ui/MenuItem";

import Header from "../components/header.component";
import { NEW_EXPERIENCE_URL, POSITION_ABSOLUTE } from "../constants";
import { ExperiencesQueryWithData } from "../graphql/operation-graphql.types";
import {
  ExperiencesQuery,
  ExperienceFragmentFragment,
  FieldFragmentFragment
} from "../graphql/operation-result.types";
import EXPERIENCES_QUERY from "../graphql/experiences.query";
import { Loading } from "../App";

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
    transform: "scale(0, 0)",
    transformOrigin: "bottom right",
    transition: "transform 1s",

    "&.show": {
      transform: "scale(1, 1)",
      transformOrigin: "bottom right",
      transition: "transform 0.8s"
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
  },

  experiencesContainer: {
    boxShadow:
      "0px 1px 5px 0px rgba(0, 0, 0, 0.2), 0px 2px 2px 0px rgba(0, 0, 0, 0.14), 0px 3px 1px -2px rgba(0, 0, 0, 0.12)",
    background: "#fff"
  },

  experienceItemContainer: {
    display: "flex",
    padding: 5,
    "&:hover": {
      background: "#e8e2e2"
    },
    margin: 5,
    cursor: "pointer"
  },

  experienceItem: {
    flex: 1,
    margin: "5px 0 0 10px",
    borderBottom: "1px solid #dccfcf",
    position: "relative"
  },

  experienceItemLast: {
    borderBottom: "none"
  },

  experienceItemMenuIcon: {
    position: "absolute",
    right: -15,
    top: -15
  }
};

const { classes } = jss.createStyleSheet(styles).attach();

const iconButtonElement = (
  <IconButton touch={true} tooltip="more" tooltipPosition="bottom-left">
    <MoreVertIcon color={grey400} />
  </IconButton>
);

const RightIconMenu = () => (
  <IconMenu iconButtonElement={iconButtonElement}>
    <MenuItem>View</MenuItem>
    <MenuItem>New</MenuItem>
    <MenuItem>About</MenuItem>
  </IconMenu>
);

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

type AnExperience = ExperienceFragmentFragment & {
  fields: FieldFragmentFragment[];
};

interface ExperienceComponentProps {
  experience: AnExperience;
  index: number;
  isLast: boolean;
}

class ExperienceComponent extends React.PureComponent<
  ExperienceComponentProps
> {
  render() {
    const { id, title } = this.props.experience;
    const className = `${classes.experienceItem} ${
      this.props.isLast ? classes.experienceItemLast : ""
    } `;

    return (
      <div key={id} className={`${classes.experienceItemContainer}`}>
        <Avatar backgroundColor={randomColor()}>
          {title.slice(0, 2).toUpperCase()}
        </Avatar>
        <div className={className}>
          <span>{title.slice(0, 30)}</span>
          <div className={`${classes.experienceItemMenuIcon}`}>
            <RightIconMenu />
          </div>
        </div>
      </div>
    );
  }
}

interface ExperiencesListProps {
  experiences: AnExperience[];
}

// tslint:disable-next-line:max-classes-per-file
class ExperiencesList extends React.PureComponent<ExperiencesListProps> {
  experiencesLen: number;

  constructor(props: ExperiencesListProps) {
    super(props);
    this.renderExperience = this.renderExperience.bind(this);

    this.experiencesLen = props.experiences.length;
  }

  render() {
    return (
      <div className={`${classes.experiencesContainer}`}>
        {this.props.experiences.map(this.renderExperience)}
      </div>
    );
  }

  renderExperience(experience: AnExperience, index: number) {
    return (
      <ExperienceComponent
        key={experience.id + index}
        experience={experience}
        index={index}
        isLast={this.experiencesLen - 1 === index}
      />
    );
  }
}

interface State {
  showFloatingActions: boolean;
}

type OwnProps = RouteComponentProps<{}>;

type InputProps = ExperiencesQueryWithData & OwnProps;

type HomeProps = ChildProps<InputProps, ExperiencesQuery>;

// tslint:disable-next-line:max-classes-per-file
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
    const { loading } = this.props;
    const experiences = this.props.experiences as AnExperience[];

    if (loading && !experiences) {
      return <Loading />;
    }

    return (
      <div className={classes.home}>
        <Header />

        <ExperiencesList experiences={experiences} />

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

const fromRedux = connect<{}, {}, OwnProps, {}>(null);

const graphqlExperiences = graphql<ExperiencesQuery, InputProps>(
  EXPERIENCES_QUERY,
  {
    props: props => {
      const data = props.data as ExperiencesQueryWithData;
      return data;
    }
  }
);

export default compose(fromRedux, graphqlExperiences)(Home);
