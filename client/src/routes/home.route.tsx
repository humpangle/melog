import * as React from "react";
import FloatingActionButton from "material-ui/FloatingActionButton";
import ContentAdd from "material-ui/svg-icons/content/add";
import ContentClear from "material-ui/svg-icons/content/clear";
import jss from "jss";
import { RouteComponentProps, Link } from "react-router-dom";
import { ChildProps, graphql, compose } from "react-apollo";
import { connect } from "react-redux";
import { List, ListItem } from "material-ui/List";
import Avatar from "material-ui/Avatar";
import randomColor from "randomcolor";

import Header from "../components/header.component";
import { NEW_EXPERIENCE_URL, POSITION_ABSOLUTE } from "../constants";
import { ExperiencesQueryWithData } from "../graphql/operation-graphql.types";
import {
  ExperiencesQuery,
  ExperienceFragmentFragment,
  FieldFragmentFragment
} from "../graphql/operation-result.types";
import EXPERIENCES_QUERY from "../graphql/experiences.query";

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

type AnExperience = ExperienceFragmentFragment & {
  fields: FieldFragmentFragment[];
};

interface ExperiencesListProps {
  experiences: AnExperience[];
}

class ExperiencesList extends React.PureComponent<ExperiencesListProps> {
  experiencesLen: number;

  constructor(props: ExperiencesListProps) {
    super(props);
    this.renderExperience = this.renderExperience.bind(this);

    this.experiencesLen = props.experiences.length;
  }

  render() {
    return <List>{this.props.experiences.map(this.renderExperience)}</List>;
  }

  renderExperience(experience: AnExperience, index: number) {
    const { id, title, intro = "" } = experience;

    const avatar = (
      <Avatar backgroundColor={randomColor()}>
        {title.slice(0, 2).toUpperCase()}
      </Avatar>
    );

    const nestedItems = [
      // tslint:disable-next-line:jsx-key
      <ListItem key={`intro-${id}`} secondaryText={intro} />
    ];

    return (
      <ListItem
        key={id}
        leftAvatar={avatar}
        primaryText={title.slice(0, 30)}
        nestedItems={nestedItems}
        autoGenerateNestedIndicator={true}
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
      return <div>Loading</div>;
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
